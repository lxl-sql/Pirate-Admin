/**
 * @name 'useTheme'
 */
import {defineStore} from "pinia";
import {useState} from "./useState";
import {useActions} from "./useActions";
import {useGetters} from "@/store/hooks/useTheme/useGetters";

export const useTheme = defineStore(
  'theme',
  () => {
    const state = useState()
    const getters = useGetters(state)
    const actions = useActions(state)

    return {
      ...state,
      ...actions,
      ...getters,
    }
  }
);
