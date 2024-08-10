import {Injectable} from "@nestjs/common";
import {Repository} from "typeorm";
import {Config} from "./entities/config.entity";

@Injectable()
export class ConfigRepository extends Repository<Config> {

}
