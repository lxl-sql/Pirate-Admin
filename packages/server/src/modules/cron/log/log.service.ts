import {Injectable} from '@nestjs/common';
import {CreateLogDto} from './dto/create-log.dto';
import {UpdateLogDto} from './dto/update-log.dto';
import {InjectRepository} from "@nestjs/typeorm";
import {Log} from "@/modules/cron/log/entities/log.entity";
import {Repository} from "typeorm";

@Injectable()
export class LogService {
  @InjectRepository(Log)
  private readonly logRepository: Repository<Log>

  public async create(createLogDto: CreateLogDto) {
    const newLog = this.logRepository.create(createLogDto);
    return await this.logRepository.save(newLog);
  }

  findAll() {
    return `This action returns all log`;
  }

  findOne(id: number) {
    return `This action returns a #${id} log`;
  }

  update(id: number, updateLogDto: UpdateLogDto) {
    return `This action updates a #${id} log`;
  }

  remove(id: number) {
    return `This action removes a #${id} log`;
  }
}
