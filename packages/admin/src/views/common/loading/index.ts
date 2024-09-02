import { createVNode, render } from "vue";
import loading from "./default/index.vue";

// 将vue组件转为VNode，然后渲染到页面上
const VNode = createVNode(loading);
render(VNode, document.body);

export default {
  show: VNode.component?.exposed?.show,
  hide: VNode.component?.exposed?.hide,
};
