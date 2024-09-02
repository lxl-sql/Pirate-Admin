import admin_log from './admin_log.json';
import admin_permission from './admin_permission.json';
import admin_role from './admin_role.json';
import defaultValue from './default.json';
import user from './user.json';

export default {
  admin_log,
  admin_permission,
  admin_role,
  ...defaultValue,
  user
};
