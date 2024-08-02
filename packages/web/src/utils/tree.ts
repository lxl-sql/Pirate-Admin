import {deepArguments, DefaultTreeRecordType, Key} from "@/types";
import {isArray} from "lodash-es";

/**
 * tree forEach 循环
 * @param args
 */
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
 * 获取列表中的所有 key
 * @param tree
 * @param key
 */
export function getTreeKeys<RecordType extends DefaultTreeRecordType<RecordType>>(tree: RecordType[], key: string = "id") {
  const keys: Key[] = []
  treeForEach<RecordType>(tree, item => {
    keys.push(item[key])
  })
  return keys
}
