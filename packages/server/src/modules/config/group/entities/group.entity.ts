import {Column, Entity, OneToMany, PrimaryGeneratedColumn} from "typeorm";
import {Config} from "../../config/entities/config.entity";

@Entity({
  name: 'config_group'
})
export class Group {
  @PrimaryGeneratedColumn()
  id: number

  @Column({
    length: 100,
    comment: '分组字段',
    unique: true
  })
  name: string

  @Column({
    length: 100,
    comment: '分组标题',
  })
  title: string;

  @OneToMany(() => Config, (config) => config.group)
  configs: Config[]
}
