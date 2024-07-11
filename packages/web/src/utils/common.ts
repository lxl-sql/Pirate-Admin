// 获取时间状态
import {deepArguments, deepCallback, DefaultTreeRecordType, IOptions, IPages} from "@/types";
import {TagProps} from "ant-design-vue";
import {cloneDeep, isArray, round} from "lodash-es";
import dayjs, {Dayjs} from "dayjs";
import {DateRangeTuple} from "@/types/form";

export const getTimeState = () => {
  // 获取当前时间
  const timeNow = new Date();
  // 获取当前小时
  const hours = timeNow.getHours();
  // 设置默认文字
  let text = ``;
  // 判断当前时间段
  if (hours >= 0 && hours <= 10) {
    text = `早上好`;
  } else if (hours > 10 && hours <= 14) {
    text = `中午好`;
  } else if (hours > 14 && hours <= 18) {
    text = `下午好`;
  } else if (hours > 18 && hours <= 24) {
    text = `晚上好`;
  }
  // 返回当前时间段对应的状态
  return text;
};

// 定义一个节流函数
export function throttled(fn: Function, delay: number) {
  let timer: NodeJS.Timeout | number | null = null;
  let startTime = Date.now();
  return function () {
    let curTime = Date.now(); // 当前时间
    let remaining = delay - (curTime - startTime); // 从上一次到现在，还剩下多少多余时间
    let context = this;
    let args = arguments;
    timer && clearTimeout(timer);
    if (remaining <= 0) {
      fn.apply(context, args);
      startTime = Date.now();
    } else {
      timer = setTimeout(fn, remaining);
    }
  };
}

/**
 * @description 节流函数
 * @param func 回调
 * @param wait 等到时间
 * @param immediate 是否第一次就触发一次
 * @returns
 */
export function debounce(func: Function, wait: number, immediate?: boolean) {
  let timeout: any;

  return function () {
    let context = this;
    let args = arguments;

    if (timeout) clearTimeout(timeout); // timeout 不为null
    if (immediate) {
      let callNow = !timeout; // 第一次会立即执行，以后只有事件执行后才会再次触发
      timeout = setTimeout(function () {
        timeout = null;
      }, wait);
      if (callNow) {
        func.apply(context, args);
      }
    } else {
      timeout = setTimeout(function () {
        func.apply(context, args);
      }, wait);
    }
  };
}

/**
 * @description 获取访问终端
 * @example getTerminal()
 * @returns {mobile pc} 返回终端类型 mobile pc
 */
export function getTerminal(): "mobile" | "pc" {
  const terminal = navigator.userAgent.toLowerCase();

  const ipad = terminal.match(/ipad/i);
  const iphone_os = terminal.match(/iphone os/i);
  const midp = terminal.match(/midp/i);
  const uc7 = terminal.match(/rv:1.2.3.4/i);
  const ucweb = terminal.match(/ucweb/i);
  const android = terminal.match(/android/i);
  const windows_ce = terminal.match(/windows ce/i);
  const windows_mobile = terminal.match(/windows mobile/i);

  if (
    (ipad && ipad[0] === "ipad") ||
    (iphone_os && iphone_os[0] === "iphone os") ||
    (midp && midp[0] === "midp") ||
    (uc7 && uc7[0] === "rv:1.2.3.4") ||
    (ucweb && ucweb[0] === "ucweb") ||
    (android && android[0] === "android") ||
    (windows_ce && windows_ce[0] === "windows ce") ||
    (windows_mobile && windows_mobile[0] === "windows mobile")
  ) {
    // 移动端浏览器
    return "mobile";
  } else {
    // PC端浏览器
    return "pc";
  }
}

/**
 * @description setTimeoutPromise 封装setTimeout为Promise 用法：await setTimeoutPromise(1000) 1秒后执行 resolve 然后执行后面的代码
 * @param time
 * @returns
 */
export function setTimeoutPromise(time: number) {
  return new Promise<void>((resolve) => {
    let timer = setTimeout(() => {
      resolve();
      clearTimeout(timer);
    }, time);
  });
}

/**
 *
 * @param args 入参
 * @return 返回指定参数
 */
export function recursive<RecordType extends DefaultTreeRecordType<RecordType>>(...args: deepArguments<RecordType>) {
  const [
    list,
    cb,
    children = 'children',
    parent,
    level = 1
  ] = args;
  if (!isArray(list)) return list;
  return list.map((item, index) => {
    item.level = level
    if (item[children] && item[children].length) {
      item[children] = recursive(item[children], cb, children, item);
    } else {
      item[children] = null;
    }
    return cb && cb(item, index, list, parent, level + 1);
  });
}

/**
 * @param args 入参
 * @returns
 */
export function recursiveTreeMap<RecordType extends DefaultTreeRecordType<RecordType>>(...args: deepArguments<RecordType>) {
  const [
    list,
    cb,
    children = 'children',
    parent,
    level = 1
  ] = args;
  if (!isArray(list)) return list;
  return list.map((item, index) => {
    item.level = level
    cb && cb(item, index, list, parent, level + 1);
    if (item[children] && item[children].length) {
      item[children] = recursiveTreeMap(item[children], cb, children, item);
    } else {
      item[children] = null;
    }
    return item;
  });
}

export function treeForEach<RecordType extends DefaultTreeRecordType<RecordType>>(...args: deepArguments<RecordType>) {
  const [list, cb, children = 'children', parent] = args;
  if (!isArray(list)) return list;
  for (let i = 0, len = list.length; i < len; i++) {
    const item = list[i];
    cb && cb(item, i, list, parent);
    if (item[children] && item[children].length) {
      treeForEach(item[children], cb, children, item);
    }
  }
}

/**
 * @param args 入参
 * @returns
 */
export function deepFilter<RecordType extends DefaultTreeRecordType<RecordType>>(...args: deepArguments<RecordType>) {
  const [
    list,
    cb,
    children = 'children',
    parent
  ] = args;
  if (!isArray(list)) return list;
  return cloneDeep(list).filter((item, index) => {
    if (item[children] && item[children].length) {
      item[children] = recursiveTreeMap(item[children], cb, children, item);
    } else {
      item[children] = null;
    }
    return cb && cb(item, index, list, parent!);
  });
}

/**
 * @description 获取当前页码 用于序号排序
 * @param index
 * @param pages
 */

export function sortNumber(index: number, pages?: IPages) {
  if (!pages) return index + 1
  return index + 1 + (pages.page - 1) * pages.size
}


/**
 * @description 格式化文件大小
 * @param size 文件大小
 * @param fixed 保留小数位数 默认2
 */
export function formatFileSize(size?: number, fixed = 2) {
  if (!size) return "";

  const units = ['byte', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB'];
  let index = 0;

  while (size >= 1024 && index < units.length - 1) {
    size /= 1024;
    index++;
  }

  return `${round(size, fixed)} ${units[index]}`;
}

/**
 * @description 根据请求方法展示对应颜色
 * @param value
 */
export function methodTagColor(value: string) {
  if (!value) return
  value = value.toLocaleUpperCase()
  const color: Record<string, TagProps['color']> = {
    'GET': 'success',
    'POST': 'warning',
    'DELETE': 'danger',
    'OPTIONS': 'success',
    'PATCH': 'warning',
    'PUT': 'warning'
  }
  return color[value]
}

/**
 * @description: 状态码及其描述
 * @param value {string}
 */
export function statusCode(value?: number | string) {
  if (!value) return
  const code: Record<string, string> = {
    200: '200 Ok',
    201: '201 Created',
    301: '301 Moved Permanently',
    302: '302 Found',
    400: '400 Bad Request',
    401: '401 Unauthorized',
    403: '403 Forbidden',
    404: '404 Not Found',
    500: '500 Internal Server Error',
    502: '502 Bad Gateway',
    504: '504 Gateway Timeout'
  }
  return code[value] || value;
}

/**
 * 格式化时间，将毫秒转换为合适的时间单位表示。
 *
 * @param {number} [time] - 以毫秒为单位的时间。
 * @returns {string} 格式化后的时间字符串。
 */
export function formatTime(time?: number): string {
  if (typeof time !== 'number' || isNaN(time) || time < 0) return "";

  const units = [
    {name: "ms", factor: 1},
    {name: "s", factor: 1000},
    {name: "min", factor: 60},
    {name: "h", factor: 60},
    {name: "d", factor: 24},
  ];

  let unitIndex = 0;
  let value = time;

  while (unitIndex < units.length - 1 && value >= units[unitIndex + 1].factor) {
    value /= units[unitIndex + 1].factor;
    unitIndex++;
  }

  // 保留小数位数，根据不同的单位设置不同的精度
  const precision = unitIndex === 0 ? 0 : 2;
  return value.toFixed(precision) + " " + units[unitIndex].name;
}

/**
 * @description: 日期格式化函数
 * @param values
 */
export function formatDateRange(values: DateRangeTuple) {
  if (values && isArray(values)) {
    return values.filter(Boolean).map((date?: Dayjs) => dayjs(date).format("YYYY-MM-DD")).join(',')
  }
  return undefined
}

/**
 * @description 根据total 计算 当前最大页 得出下一页
 * @param pages
 */
export function calculateNextPage(pages: IPages | undefined) {
  if (!pages) return 1
  const {
    page: currentPage,
    size: pageSize,
    total: totalItems,
  } = pages;

  if (currentPage <= 0 || totalItems <= 0) {
    return 1
  }

  const totalPages = Math.ceil(totalItems / pageSize);

  return Math.ceil(currentPage <= totalPages ? currentPage : totalPages)
}

/**
 * 格式化输入的单位，如果没有单位则添加 'px'。
 *
 * @param {number|string} value - 输入的值，可以是数字或字符串。
 * @returns {string|undefined} 格式化后的字符串，带有适当的单位。
 */
export function formatUnit(value?: number | string): string | undefined {
  if (typeof value === 'number') {
    return value + 'px';
  } else if (typeof value === 'string') {
    // 正则表达式检查字符串是否包含单位
    const units = ['px', 'em', 'rem', '%', 'vh', 'vw'];
    for (const unit of units) {
      if (value.endsWith(unit)) {
        return value;
      }
    }
    // 如果字符串是数字形式的字符串，没有单位，则加上 'px'
    if (!isNaN(Number(value))) {
      return value + 'px';
    }
  }
  return value;
}

// 铺平 tree 树
export function flatTree<RecordType extends DefaultTreeRecordType<RecordType>>(list: RecordType[], cb?: deepCallback<RecordType>, children = 'children') {
  const newArr: RecordType[] = []
  recursiveTreeMap<RecordType>(
    list,
    (item, index, arr, parent, level) => {
      cb?.(item, index, arr, parent, level)
      newArr.push(item)
    },
    children
  )
  return newArr
}

export function findTree<RecordType extends DefaultTreeRecordType<RecordType>>(...args: deepArguments<RecordType>) {
  const [
    list,
    cb,
    children = 'children',
    parent,
    level = 1
  ] = args;
  for (const key in list) {
    const item = list[key]
    if (cb?.(item, key as any, list, parent, level)) {
      item.level = level
      return item
    }
    if (item.children?.length) {
      const newItem = findTree<RecordType>(item.children, cb, children, item, level + 1)
      if (newItem) {
        return newItem
      }
    }
  }
}

/**
 * 根据 下班获取数据
 * @param list
 * @param findIdx
 * @param keyIndex
 */
export function findIndex<RecordType extends DefaultTreeRecordType<RecordType>>(list: RecordType[], findIdx: number, keyIndex: number | any = -1): number | RecordType {
  for (const key in list) {
    if (typeof keyIndex == 'number') {
      keyIndex++
    }

    if (keyIndex == findIdx) {
      return list[key]
    }

    if (list[key].children) {
      keyIndex = findIndex(list[key].children!, findIdx, keyIndex)
      if (typeof keyIndex != 'number') {
        return keyIndex
      }
    }
  }
  return keyIndex
}

/**
 * @description 将 enum 转换为 options，适用于表单控件如 select 组件
 * @param enumObj
 * @param type {key | value} label 展示 key 值 还是 value 值 default: value
 */
export function enumToOptions<T extends object>(enumObj: T, type: 'key' | 'value' = 'value'): IOptions[] {
  return Object.keys(enumObj)
    .filter(key => isNaN(Number(key))) // 过滤掉数字键
    .map(key => ({
      label: type === 'value' ? String(enumObj[key as keyof typeof enumObj]) : key,
      value: key
    }));
}
