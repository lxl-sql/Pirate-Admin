//定义本地存储的接口类
export interface LocalInterFace {
  // 获取
  get<T>(key: string): T;

  // 设置
  set<T>(key: string, value: T): void;

  // 移除
  remove(key: string): void;

  // 判断是否存在
  isKey(key: string): boolean;

  // 清除
  clear(): void;
}

// 定义localStorage封装
class LocalUtil implements LocalInterFace {
  // 获取
  get<T>(key: string): T | any {
    // ts类型推断时不能将null赋值给JSON.parse()的参数
    let str = window.localStorage.getItem(key) || "";
    if (str) {
      return JSON.parse(str);
    }
    return str;
  }

  // 设置
  set<T>(key: string, value: T): void {
    window.localStorage.setItem(key, JSON.stringify(value));
  }

  // 移除
  remove(key: string): void {
    window.localStorage.removeItem(key);
  }

  // 判断是否存在
  isKey(key: string): boolean {
    let str = window.localStorage.getItem(key);
    return !!str;
  }

  // 清除
  clear(): void {
    window.localStorage.clear();
  }
}

// 定义sessionStorage封装
class SessionUtil implements LocalInterFace {
  // 获取
  get<T>(key: string): T | any {
    // ts类型推断时不能将null赋值给JSON.parse()的参数
    let str = window.sessionStorage.getItem(key) || "";
    if (str) {
      return JSON.parse(str);
    }
    return str;
  }

  // 设置
  set<T>(key: string, value: T): void {
    window.sessionStorage.setItem(key, JSON.stringify(value));
  }

  // 移除
  remove(key: string): void {
    window.sessionStorage.removeItem(key);
  }

  // 判断是否存在
  isKey(key: string): boolean {
    let str = window.sessionStorage.getItem(key);
    return !!str;
  }

  // 清除
  clear(): void {
    window.sessionStorage.clear();
  }
}

// 创建需要导出的对象`
const $local = new LocalUtil();
const $session = new SessionUtil();
// 以对象的形式导出
export {$local, $session};
