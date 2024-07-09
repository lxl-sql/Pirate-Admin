// store/index.ts
import {defineStore} from "pinia";
import {$local} from "@/utils/storage";
import {UserInfo} from './types'

export const useUserStore = defineStore('userStore', {
  state: () => {
    return {};
  },
  getters: {
    userInfo: (): UserInfo => $local.get('userInfo')
  },
  actions: {},
});
