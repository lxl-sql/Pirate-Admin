/**
 * Requests the browser to enter full-screen mode.
 */
export const fullScreen = (): void => {
  const de = document.documentElement as any;
  if (de.requestFullscreen) {
    de.requestFullscreen();
  } else if (de.mozRequestFullScreen) {
    de.mozRequestFullScreen();
  } else if (de.webkitRequestFullScreen) {
    de.webkitRequestFullScreen();
  } else if (de.msRequestFullScreen) {
    de.msRequestFullScreen();
  } else {
    console.warn('Full-screen mode is not supported in this browser.');
  }
};

/**
 * Exits the browser's full-screen mode.
 */
export const exitFullScreen = (): void => {
  const d = document as any;
  if (d.exitFullscreen) {
    d.exitFullscreen();
  } else if (d.mozCancelFullScreen) {
    d.mozCancelFullScreen();
  } else if (d.webkitExitFullscreen) {
    d.webkitExitFullscreen();
  } else if (d.msExitFullscreen) {
    d.msExitFullscreen();
  } else {
    console.warn('Exiting full-screen mode is not supported in this browser.');
  }
};

/**
 * Opens a new browser window or tab with the specified URL.
 * Tries to use the modern `window.open` method and falls back to more compatible methods if necessary.
 *
 * @param {string} url - The URL to open.
 * @param {string} [windowName=_blank] - The name of the new window or tab. Defaults to `_blank`.
 * @param {string} [windowFeatures=''] - A comma-separated list of window features (e.g., `width=800,height=600`).
 * @returns {Window | null} The window object of the new window or tab, or `null` if the window could not be opened.
 */
export const openWindow = (url: string, windowName: string = '_blank', windowFeatures: string = ''): Window | null => {
  // Try using the modern window.open method
  let newWindow: Window | null = window.open(url, windowName, windowFeatures);

  // If window.open failed, try using a more compatible method
  if (!newWindow) {
    try {
      const anchor = document.createElement('a');
      anchor.href = url;
      anchor.target = windowName;
      document.body.appendChild(anchor);
      anchor.click();
      document.body.removeChild(anchor);
      newWindow = null; // As we used anchor, reset it to null
    } catch (e) {
      // Fallback to using a popup window with document.write
      newWindow = window.open('', windowName, windowFeatures);
      if (newWindow) {
        newWindow.document.write(`<html><head><script type="text/javascript">window.location.href='${url}';</script></head><body></body></html>`);
        newWindow.document.close();
      }
    }
  }

  return newWindow;
}
