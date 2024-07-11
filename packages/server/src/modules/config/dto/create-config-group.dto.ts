import {IsNotEmpty} from "class-validator";

export class CreateConfigGroupDto {
  @IsNotEmpty({message: '分组字段不能为空！'})
  name: string

  @IsNotEmpty({message: '分组标题不能为空！'})
  title: string
}
