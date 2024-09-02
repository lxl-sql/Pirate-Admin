import {ModalProps} from "ant-design-vue";

export interface IDragRect {
  left: number;
  right: number;
  top: number;
  bottom: number;
}

export interface IModalProps extends ModalProps {
  // 是否允许拖拽 modal 框
  draggable?: boolean;
  // 取消按钮 loading
  cancelLoading?: boolean;
  // modal 加载loading 包括 body 和 确定按钮
  loading?: boolean;
  // 初始化
  init?: (...args: any) => void;
}
