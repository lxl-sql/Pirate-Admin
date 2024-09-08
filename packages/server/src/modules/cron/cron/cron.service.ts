import {Inject, Injectable, OnModuleDestroy, OnModuleInit} from '@nestjs/common';
import {InjectRepository} from "@nestjs/typeorm";
import {Repository} from "typeorm";
import {CronJob} from "cron";
import {WINSTON_LOGGER_TOKEN} from "@/const/winston.const";
import {AppLogger} from "@/common/logger/app-logger.service";
import {Cron} from "./entities/cron.entity";
import {CreateCronDto} from './dto/create-cron.dto';
import {UpdateCronDto} from './dto/update-cron.dto';

@Injectable()
export class CronService implements OnModuleInit, OnModuleDestroy {
  @InjectRepository(Cron)
  private readonly cronRepository: Repository<Cron>

  @Inject(WINSTON_LOGGER_TOKEN)
  private readonly logger: AppLogger;

  private jobs: CronJob[] = []

  async onModuleInit() {
    const crons = await this.cronRepository.find()
    crons.forEach(cron => {
      const cornTime = cron.cron
      const job = new CronJob(cornTime, () => {

      })

      job.start();
      this.jobs.push(job); // 将任务保存到 jobs 数组中
    })
  }

  onModuleDestroy() {
    this.clearJobs()
  }

  private clearJobs() {
    this.jobs.forEach((job) => job.stop());
    this.jobs = [];
    this.logger.log('All scheduled jobs have been stopped and cleared.');
  }

  async create(createCronDto: CreateCronDto) {
    const newCron = this.cronRepository.create(createCronDto)

    await this.cronRepository.save(newCron)

    return '定时任务创建成功'
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
