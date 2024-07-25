/**
 * 播放媒体文件
 */
import {onBeforeUnmount, onMounted, ref, shallowRef} from 'vue';

export function useMediaPlay(mediaType: 'video' | 'audio' = 'video') {
  const isPlaying = shallowRef<boolean>(false);
  const mediaRef = ref<HTMLAudioElement | HTMLVideoElement | null>(null);
  const error = shallowRef<string | undefined>(undefined)

  const toggleMediaStatus = async (status: 'play' | 'pause') => {
    if (mediaRef.value) {
      try {
        if (status === 'play') {
          await mediaRef.value.play();
          onPlay();
        } else if (status === 'pause') {
          mediaRef.value.pause();
          onPause();
        }
      } catch (err) {
        error.value = `Error while trying to ${status} the media: ${err}`;
        console.error(error.value);
      }
    }
  };

  const onPlay = () => {
    isPlaying.value = true;
  };

  const onPause = () => {
    isPlaying.value = false;
  };

  onMounted(() => {
    if (mediaRef.value) {
      mediaRef.value.addEventListener('play', onPlay);
      mediaRef.value.addEventListener('pause', onPause);
    }
  });

  onBeforeUnmount(() => {
    if (mediaRef.value) {
      mediaRef.value.removeEventListener('play', onPlay);
      mediaRef.value.removeEventListener('pause', onPause);
    }
  });

  return {
    mediaRef,
    isPlaying,
    error,
    toggleMediaStatus,
  };
}
