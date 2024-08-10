type TreeCallback<T> = (item: T, index: number, list: T[], parent?: T, level?: number) => boolean | void

interface LevelTree<T> {
  level: number
}

/**
 * 遍历树结构并支持中断
 * @param list 数据
 * @param callback 回调函数
 * @param children 子级字段 默认 children
 * @param parent 父级 默认 null
 * @param level 层级 默认 0
 * @returns 返回布尔值，表示是否应该继续遍历
 */
export function forEachTree<T>(
  list: T[],
  callback?: TreeCallback<T>,
  children = 'children',
  parent: T | null = null,
  level: number = 0
): boolean {
  if (!Array.isArray(list)) return true;

  for (let index = 0; index < list.length; index++) {
    const item = list[index];
    const shouldContinue: boolean | void = callback?.(item, index, list, parent, level);

    // 如果回调返回 false，终止遍历
    if (shouldContinue === false) {
      return false;
    }

    if (item[children] && item[children].length) {
      const childContinue = forEachTree<T>(item[children], callback, children, item, level + 1);

      // 如果子树遍历返回 false，终止当前树的遍历
      if (childContinue === false) {
        return false;
      }
    }
  }

  return true; // 如果遍历完整个树，返回 true 表示继续
}


/**
 *
 * @param list 数据
 * @param callback
 * @param children 子级字段 默认children
 * @param parent 父级 默认null
 * @returns
 */
export function mapTree<T>(
  list: T[],
  callback: TreeCallback<T>,
  children = 'children',
  parent: T | null = null,
) {
  if (!Array.isArray(list)) {
    return list;
  }
  return list.map((item, index) => {
    callback?.(item, index, list, parent);
    if (item[children] && item[children].length) {
      item[children] = mapTree(item[children], callback, children, item);
    } else {
      item[children] = null;
    }
    return item;
  });
}

/**
 * sort tree 排序
 * @param list
 * @param callback
 * @param children
 * @returns
 */
export function sortTree<T>(
  list: T[],
  callback: (a: T, b: T) => number,
  children = 'children',
) {
  // 首先对当前层级的节点进行排序
  list.sort(callback);

  // 递归地对每个子节点进行排序
  list.forEach((node) => {
    if (node[children]?.length) {
      node[children] = sortTree(node[children], callback, children);
    }
  });

  return list;
}
