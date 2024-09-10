import admin_log from './admin_log.json';
import admin_permission from './admin_permission.json';
import admin_role from './admin_role.json';
import auth from './auth';
import defaultValue from './default.json';
import layout from './layout';
import routine from './routine';
import rule from './rule.json';
import user from './user.json';

export default {
  admin_log,
  admin_permission,
  admin_role,
  auth,
  ...defaultValue,
  layout,
  routine,
  rule,
  user
};
