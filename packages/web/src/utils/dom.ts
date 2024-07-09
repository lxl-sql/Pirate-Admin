// 全屏
export const fullScreen = () => {
  const de = document.documentElement as any;
  de.requestFullscreen() ||
    de.mozRequestFullScreen() ||
    de.webkitRequestFullScreen() ||
    de.msRequestFullScreen();
};
// 退出全屏
export const exitFullScreen = () => {
  const d = document as any;
  d.exitFullscreen() ||
    d.mozCancelFullScreen() ||
    d.webkitExitFullscreen() ||
    d.msExitFullscreen();
};
