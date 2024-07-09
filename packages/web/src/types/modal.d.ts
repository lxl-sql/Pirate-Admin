export interface DefaultModalProps<Options = any> {
  /**
   * 显示与隐藏
   */
  open: boolean;
  /**
   * 父级传入数据
   */
  options?: Options;
}
