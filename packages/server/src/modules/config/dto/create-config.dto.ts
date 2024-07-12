import {IsArray, IsInt, IsNotEmpty, IsOptional, IsString} from "class-validator";

export class CreateConfigDto {
  @IsInt({message: "请传递正确的分组类型"})
  @IsNotEmpty({message: '变量分组不能为空！'})
  groupId?: number

  @IsString()
  @IsNotEmpty({message: '变量名不能为空！'})
  name?: string

  @IsString()
  @IsNotEmpty({message: '变量标题不能为空！'})
  title?: string

  @IsString()
  @IsNotEmpty({message: '变量类型不能为空！'})
  type?: string

  @IsOptional()
  tip?: string

  @IsArray({message: '传递的验证规则类型错误'})
  @IsOptional()
  rule?: string[]

  @IsOptional()
  content?: string

  @IsOptional()
  value?: string

  @IsOptional()
  extend?: string

  @IsOptional()
  inputExtend?: string

  @IsInt({message: '传递的权重类型不正确！'})
  @IsOptional()
  weight?: number
}
