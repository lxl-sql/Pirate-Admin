import { HttpException, HttpStatus, Inject, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { File } from './entities/files.entity';
import { Repository } from 'typeorm';
import { createHash } from 'crypto';
import { createReadStream, unlinkSync } from 'fs';
import { Request } from 'express';
import * as path from 'path';
import * as fs from 'fs';
import { QueryFileDto } from './dto/query-file.dto';
import { ConfigService } from '@nestjs/config';
import {
  between,
  filterFalsyValues,
  findManyOption,
  like,
  pageFormat,
  requestHost,
} from '@/utils/tools';
import { removePublic } from '@/utils/crud';
import { IdsDto } from '@/common/dtos/remove.dto';

@Injectable()
export class FilesService {
  @InjectRepository(File)
  private readonly fileRepository: Repository<File>;

  @Inject(ConfigService)
  private readonly configService: ConfigService;

  /**
   * 上传文件
   * @param files
   * @param body
   * @returns
   */
  public async upload(files: Array<Express.Multer.File>, request: Request) {
    console.log('files', files);
    if (!files) {
      throw new HttpException('文件上传失败', HttpStatus.BAD_REQUEST);
    }

    return await Promise.all(
      files.map(async (file) => {
        const hash = this.calculateFileHashSync(file.path);
        const found_file = await this.fileRepository.findOneBy({
          hash: hash,
        });

        if (found_file) {
          // 更新上传次数 uploadCount
          this.fileRepository.update(found_file.id, {
            uploadCount: found_file.uploadCount + 1,
          });
          const url = requestHost(request, found_file.path);
          return {
            name: found_file.name,
            path: found_file.path,
            url: url,
            mimetype: found_file.mimetype,
            size: found_file.size,
            hash: hash,
          };
        }

        const [, ...paths] = file.path
          .replace(/\\/g, '/')
          .replace(/[A-Z]:/, '')
          .split('uploads/');
        const path = `/uploads/${paths.join('uploads/')}`;
        const url = requestHost(request, path);

        const result = {
          name: file.filename,
          path: path,
          url: url,
          mimetype: file.mimetype,
          size: file.size,
          hash: hash,
        };
        // console.log('result', result);

        const usertypeEmun = {
          [this.configService.get('JWT_REFRESH_SIGN_ADMIN')]: 1,
          [this.configService.get('JWT_REFRESH_SIGN_USER')]: 2,
        };

        await this.save({
          ...result,
          username: request.user.username,
          usertype: usertypeEmun[request.user.sign],
        });

        return result;
      }),
    );
  }

  /**
   * 保存文件 meta 信息 到数据库 用于文件管理 以及文件权限控制 以及文件的删除 以及文件的下载 以及文件的预览 以及文件的分享 以及文件的加密 以及文件的解密 以及文件的加密分享 以及文件的解密分享
   * @param file
   * @returns
   */
  public async save(file) {
    try {
      const new_file = this.fileRepository.create(file);

      await this.fileRepository.save(new_file);
      return '上传成功';
    } catch (e) {
      throw new HttpException('上传失败', HttpStatus.BAD_REQUEST);
    }
  }

  /**
   * 获取文件列表
   */
  public async list(
    page: number,
    size: number,
    query: Partial<QueryFileDto>,
    protocolHost: string,
  ) {
    const conddition = {
      name: like(query.name),
      username: like(query.username),
      usertype: filterFalsyValues(query.usertype),
      mimetype: like(query.mimetype),
      createTime: between(query.createRange, 'date'),
      updateTime: between(query.updateRange, 'date'),
    };

    const [files, total] = await this.fileRepository.findAndCount(
      findManyOption<File>(page, size, {
        where: conddition,
      }),
    );

    const records = files.map((file: File & { url: string }) => {
      file.url = requestHost(protocolHost, file.path);
      return file;
    });

    return pageFormat(
      page,
      size,
      total,
      records,
      '同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！',
    );
  }

  /**
   * 删除附件 以及对应的文件
   * @param id
   */
  public async remove(body: IdsDto) {
    return await removePublic(this.fileRepository, body);
  }

  /**
   * 获取指定日期的上传目录路径
   * @param date
   * @returns
   */
  private getUploadDir(date: Date): string {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `uploads/${year}/${month}/${day}`;
  }

  /**
   * 生成文件 hash 异步
   * @param filePath 文件路径
   * @returns
   */
  private async calculateFileHash(filePath: string): Promise<string> {
    const hash = createHash('sha256');
    const readStream = createReadStream(filePath);

    return new Promise((resolve, reject) => {
      readStream
        .on('data', (data) => hash.update(data))
        .on('end', () => {
          const hashValue = hash.digest('hex');
          unlinkSync(filePath); // 删除文件
          resolve(hashValue);
        })
        .on('error', (err) => {
          unlinkSync(filePath); // 删除文件
          reject(err);
        });
    });
  }

  /**
   * 计算文件的哈希值 同步
   * @param filePath
   * @returns
   */
  private calculateFileHashSync(filePath: string): string {
    const hash = createHash('sha256');
    const fileData = fs.readFileSync(filePath);
    hash.update(fileData);
    return hash.digest('hex');
  }

  /**
   * 获取指定日期之前的所有上传文件地址及哈希值
   * @param date 目标日期
   * @returns
   */
  private getPreviousUploadFilesWithHash(
    date: Date,
  ): { path: string; hash: string }[] {
    const previousUploadFiles: { path: string; hash: string }[] = [];
    const currentDate = new Date(date); // 复制目标日期对象以避免修改原始对象
    while (true) {
      const uploadDir = this.getUploadDir(currentDate);
      if (!fs.existsSync(uploadDir)) {
        break; // 目录不存在，结束循环
      }
      const files = fs.readdirSync(uploadDir);
      for (const file of files) {
        const filePath = path.join(uploadDir, file);
        if (fs.statSync(filePath).isFile()) {
          const relativePath = path.relative('uploads', filePath);
          const fileHash = this.calculateFileHashSync(filePath);
          previousUploadFiles.push({
            path: 'uploads/' + relativePath,
            hash: fileHash,
          });
        }
      }
      // 将日期向前推一天
      currentDate.setDate(currentDate.getDate() - 1);
    }
    return previousUploadFiles;
  }
}
