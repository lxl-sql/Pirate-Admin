import {Repository} from "typeorm";
import {Log} from "./entities/log.entity";

export class LogRepository extends Repository<Log> {
  findAndCounts() {

  }
}
