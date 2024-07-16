import {
  isEmail,
  isMobilePhone,
  isNotEmpty,
  isString,
  registerDecorator,
  ValidationArguments,
  ValidationOptions,
  ValidatorConstraint,
  ValidatorConstraintInterface,
} from 'class-validator';

export type CustomType = 'email' | 'phone' | 'string' | 'not-empty';

interface CustomTypeOptions {
  phoneRegion?: string; // 可选的手机号地区代码
}

@ValidatorConstraint({name: 'isCustomType', async: false})
export class IsCustomTypeConstraint implements ValidatorConstraintInterface {

  validate(value: any, args: ValidationArguments) {
    const [defaultTypes, validationOptions, customOptions = {}] = args.constraints || [];
    const types = (typeof defaultTypes === 'function' ? defaultTypes(args.object) : defaultTypes)?.filter(Boolean);

    for (const type of types) {
      args.constraints.splice(3, 1, type)
      switch (type) {
        case 'email':
          if (isEmail(value)) break
          return false
        case 'phone':
          const {phoneRegion = 'zh-CN'} = customOptions; // 提供默认值为 'zh-CN'
          if (isMobilePhone(value, phoneRegion)) break
          return false
        case 'string':
          if (isString(value)) break
          return false
        case 'not-empty':
          if (isNotEmpty(value)) break
          return false
        default:
          return false
      }
    }
    args.constraints.splice(3, 1)
    return true
  }

  defaultMessage(args: ValidationArguments) {
    const typeMessages: Record<CustomType, string> = {
      email: '邮箱格式不正确',
      phone: '手机号格式不正确',
      string: '字符串格式不正确',
      'not-empty': `${args.property} 不能为空`
    };
    const validationOptions = args.constraints.at(1)
    const type = args.constraints.at(3)
    const message = validationOptions?.[type]
      ? typeof validationOptions[type].message === 'function'
        ? validationOptions[type].message(args)
        : validationOptions[type].message
      : typeMessages[type]
    return message || '无效的验证类型';
  }
}

/**
 * 自定义校验规则装饰器
 * @param types 允许的类型数组或一个生成类型数组的函数
 * @param validationOptions 校验选项
 * @param customOptions 自定义选项，支持动态传入手机号地区代码
 */
export function IsCustomType(
  types: CustomType[] | ((dto: any) => CustomType[]),
  validationOptions?: Record<string, ValidationOptions>,
  customOptions?: CustomTypeOptions
) {
  return function (object: Object, propertyName: string) {
    registerDecorator({
      target: object.constructor,
      propertyName: propertyName,
      constraints: [types, validationOptions, customOptions],
      validator: IsCustomTypeConstraint,
    });
  };
}
