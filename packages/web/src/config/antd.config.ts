import { notification } from "ant-design-vue";

export default () => {
  // notification 默认配置
  notification.config({
    placement: "topRight",
    duration: 3,
  });
};
