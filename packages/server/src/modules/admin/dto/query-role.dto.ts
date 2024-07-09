import { PickType } from '@nestjs/mapped-types';
import { UpsertRoleDto } from './upsert-role.dto';
import { IsInt, IsOptional } from 'class-validator';

export class QueryRoleDto {
  name: string;
  slug: string;
  status: number; // 1 启用 2 禁用
}
