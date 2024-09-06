import {Injectable} from '@nestjs/common';
import {CreateCronDto} from './dto/create-cron.dto';
import {UpdateCronDto} from './dto/update-cron.dto';
import {InjectRepository} from "@nestjs/typeorm";
import {Cron} from "@/modules/cron/cron/entities/cron.entity";
import {Repository} from "typeorm";

@Injectable()
export class CronService {
  @InjectRepository(Cron)
  private readonly cronRepository: Repository<Cron>

  async create(createCronDto: CreateCronDto) {
    const newCron = this.cronRepository.create(createCronDto)

    return await this.cronRepository.save(newCron)
  }

  findAll() {
    return `This action returns all cron`;
  }

  findOne(id: number) {
    return `This action returns a #${id} cron`;
  }

  update(id: number, updateCronDto: UpdateCronDto) {
    return `This action updates a #${id} cron`;
  }

  remove(id: number) {
    return `This action removes a #${id} cron`;
  }
}
