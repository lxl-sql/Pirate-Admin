import {IsNotEmpty} from "class-validator";

export class ValueConfigDto {
  @IsNotEmpty({message: "变量分组不能为空！"})
  group: string;
}
