import axios, {AxiosError, AxiosInstance, AxiosRequestConfig, AxiosResponse,} from "axios";
import {notification} from "ant-design-vue";
import i18n from "@/locales";
import {setTimeoutPromise} from "@/utils/common";
import {refresh} from "@/api/auth/admin";
import {$local} from "@/utils/storage";
import {RefreshResult} from "@/api/types/user";
import router from "@/router";

const {t} = i18n.global;

interface PendingTask {
  config: AxiosRequestConfig;
  resolve: Function;
}

class AxiosUtils {
  public baseUrl: string = import.meta.env.VITE_BASE_API;
  private readonly http: AxiosInstance;
  private refreshing: boolean = false;
  private readonly subscribers: PendingTask[] = [];
  private readonly errorCache: Set<string>;

  constructor() {
    this.http = axios.create({
      baseURL: this.baseUrl,
      timeout: 1000 * 60,
    });
    this.errorCache = new Set();

    // 要在constructor里面进行调用 发请求的时候就要开始调用 就要对请求和响应进行拦截
    this.interceptors();
  }

  /**
   * @description 刷新 accessToken
   * @private
   */
  private async refreshAccessToken(): Promise<RefreshResult> {
    const refreshToken = $local.get("refreshToken");
    const {data, code} = await refresh(refreshToken);

    console.log("refresh", code, data);
    $local.set("accessToken", data.accessToken);
    $local.set("refreshToken", data.refreshToken);
    return {data, code};
  }

  // 拦截器
  private interceptors() {
    // 请求拦截器
    this.http.interceptors.request.use(
      this.requestSuccessHandler.bind(this),
      this.requestErrorHandler.bind(this)
    );
    // 响应拦截器
    this.http.interceptors.response.use(
      this.responseSuccessHandler.bind(this),
      this.responseErrorHandler.bind(this)
    );
  }

  /**
   * @description 请求成功处理
   * @param config
   * @private
   */
  private requestSuccessHandler(config: any) {
    // 在发送请求之前做些什么
    const accessToken = $local.get("accessToken");

    if (accessToken) {
      config.headers.Authorization = "Bearer " + $local.get("accessToken"); // 一定要放在请求拦截器里
    }
    return config;
  }

  /**
   * @description 请求错误处理
   * @param error
   * @private
   */
  private requestErrorHandler(error: any) {
    // 对请求错误做些什么
    return Promise.reject(error);
  }

  /**
   * @description 响应成功处理 2xx 范围内的状态码都会触发该函数。
   * @param response
   * @private
   */
  private responseSuccessHandler(response: any) {
    return response.data;
  }

  /**
   * @description 响应错误处理 超出 2xx 范围的状态码都会触发该函数。
   * @param error
   * @private
   */
  private async responseErrorHandler(error: AxiosError) {
    const {response} = error;

    if (!response) {
      notification.error({
        message: t("message.fail"),
        description: t("error.network"),
      });
      return Promise.reject(error);
    }

    const {data, config} = response as AxiosResponse;

    if (["/user/avatar", "/admin/avatar"].includes(config.url!)) {
      // 上传头像接口不做错误处理
      return Promise.reject(error);
    }

    if (
      response.status === 401 &&
      ["/user/refresh", "/admin/refresh"].includes(config.url!)
    ) {
      await this.unAuthorizedHandler(response);
      return Promise.reject(error);
    }

    if (this.refreshing) {
      return new Promise((resolve) => {
        this.subscribers.push({config, resolve});
      });
    }

    if (
      response.status === 401 &&
      !["/user/refresh", "/admin/refresh"].includes(config.url!)
    ) {
      this.refreshing = true;
      // console.log(config.url);
      const {code} = await this.refreshAccessToken();
      this.refreshing = false;

      if (code === 200) {
        this.subscribers.forEach(({config, resolve}) => {
          resolve(this.http(config));
        });

        return this.http(config);
      }
      // console.log("重新登录", data, config);
      await this.unAuthorizedHandler(response);
      return Promise.reject(error);
    }
    console.log("错误", error, data);
    // this.errorCacheHandler(error, data)
    // 生成错误缓存键
    notification.error({
      message: t("message.fail"),
      description: data.message || t("error.server"),
    });
    return Promise.reject(error);
  }

  /**
   * @description 重新登录处理
   * @param _response
   * @private
   */
  private async unAuthorizedHandler(_response: AxiosResponse) {
    // 重新登录
    await router.push("/admin/login");
    this.refreshing = false; // 重置刷新状态
    this.subscribers.length = 0; // 清空请求队列
    await setTimeoutPromise(500); // 等待500ms
    notification.error({
      message: t("message.fail"),
      description: t("message.loginExpired"),
    });
  }

  /**
   * 错误缓存处理
   * @param error
   * @param data
   * @private
   */
  private errorCacheHandler(error: AxiosError, data: AxiosResponse['data']) {
    // 错误缓存处理
    const errorKey = `${error.response?.status}:${error.message}`;
    // 如果之前没有弹出过相同的错误提示，则弹出提示
    if (!this.errorCache.has(errorKey)) {
      this.errorCache.add(errorKey);
      notification.error({
        message: t("message.fail"),
        description: data.message || t("error.server"),
      });
    }
  }

  /**
   * 清除请求缓存
   */
  public clearErrorCache() {
    if (this.errorCache) {
      this.errorCache.clear();
    }
  }

  // 封装一个request方法
  private request(url: string, method: string, data: any = {}, ...args: any[]) {
    return this.http({
      url,
      method,
      params: method == "get" ? data : undefined,
      data: method == "post" ? data : undefined,
      ...args,
    });
  }

  // 封装get方法
  public get(url: string, params?: any) {
    return this.request(url, "get", params);
  }

  // 封装post方法
  public post(url: string, data: any, ...args: any[]) {
    return this.request(url, "post", data, ...args);
  }
}

// 新建对象
const http = new AxiosUtils();
// 把对象暴露出去
export default http;
