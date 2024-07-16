import {IsNotEmpty,} from 'class-validator';
import {CaptchaTypeEnum} from "@/types/enum";
import {CaptchaType} from "@/types";
import {CustomType, IsCustomType} from "@/validators/is-custom-type.validator";

export class VerifyCaptchaDto {
  @IsNotEmpty({message: '注册类型不能为空'})
  type: CaptchaType;

  @IsCustomType(
    dto => [
      'not-empty',
      'string',
      dto.type === CaptchaTypeEnum.EMAIL && 'email',
      dto.type === CaptchaTypeEnum.PHONE && 'phone',
    ] as CustomType[]
  )
  address: string;

  @IsNotEmpty({message: '验证码不能为空'})
  captcha: string;
}
