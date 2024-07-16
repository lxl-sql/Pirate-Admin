import {ref, Ref} from 'vue';

interface Countdown {
  timeLeft: Ref<number>;
  isRunning: Ref<boolean>;
  start: (duration: number) => void;
  reset: () => void;
}

function useCountdown(): Countdown {
  const timeLeft = ref<number>(0)
  const isRunning = ref<boolean>(false)

  let timer: NodeJS.Timeout | null = null;

  const updateCountdown = () => {
    if (timeLeft.value > 0) {
      timeLeft.value--;
    } else {
      isRunning.value = false;
      if (timer) {
        clearInterval(timer);
      }
    }
    console.log('timeLeft.value', timeLeft.value)
  }

  const start = (duration: number) => {
    if (isRunning.value) return;
    timeLeft.value = duration;
    isRunning.value = true;
    timer = setInterval(updateCountdown, 1000);
  };

  const reset = () => {
    timeLeft.value = 0;
    isRunning.value = false;
    if (timer) {
      clearInterval(timer);
    }
  };

  return {
    timeLeft,
    isRunning,
    start,
    reset,
  };
}

export default useCountdown;
