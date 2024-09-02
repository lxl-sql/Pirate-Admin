import 'vue-router';
import {RouteMeta as CustomRouteMeta} from '@/router/types';

declare module 'vue-router' {
  interface RouteMeta extends CustomRouteMeta {
  }
}
