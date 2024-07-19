import {IsNotEmpty,} from 'class-validator';
import {CaptchaType, CaptchaTypeEnum} from "@/types/enum";
import {CustomType, IsCustomType} from "@/validators/is-custom-type.validator";
import {ApiProperty} from "@nestjs/swagger";

export class VerifyCaptchaDto {
  @ApiProperty({
    description: '注册类型',
    enum: CaptchaTypeEnum,
    example: CaptchaTypeEnum.EMAIL
  })
  @IsNotEmpty({message: '注册类型不能为空'})
  type: CaptchaType;

  @ApiProperty({
    description: '地址（根据注册类型，可能是邮箱或手机号）',
    example: 'example@example.com'
  })
  @IsCustomType(
    dto => [
      'not-empty',
      'string',
      dto.type === CaptchaTypeEnum.EMAIL && 'email',
      dto.type === CaptchaTypeEnum.PHONE && 'phone',
    ] as CustomType[]
  )
  address: string;

  @ApiProperty({
    description: '验证码',
    example: '123456'
  })
  @IsNotEmpty({message: '验证码不能为空'})
  captcha: string;
}
