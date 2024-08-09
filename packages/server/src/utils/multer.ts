import {HttpException, HttpStatus} from '@nestjs/common';
import {existsSync, mkdirSync} from 'fs';
import {diskStorage} from 'multer';
import {join} from 'path';

const zero = (time: number) => (time < 10 ? '0' + time : time);

// 获取时间文件路径
const getTimeDir = () => {
  const date = new Date();
  const year = date.getFullYear();
  const month = date.getMonth() + 1;
  const day = date.getDate();
  return year + '/' + zero(month) + '/' + zero(day);
};

const storage = diskStorage({
  destination: function (req, file, cb) {
    const dir = 'uploads/' + getTimeDir();
    const uploadDir = join(process.cwd(), dir);
    // console.log('uploadDir -->', uploadDir, dir, file);
    try {
      const exista = existsSync(uploadDir);
      if (!exista) {
        mkdirSync(uploadDir, {recursive: true /** 递归创建 */});
      }
    } catch (e) {
      throw new HttpException(
        '创建文件夹失败',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
    // cb(null, dir)
    cb(null, uploadDir); // 保存的路径，备注：需要自己创建
  },
  filename: function (req, file, cb) {
    file.originalname = Buffer.from(file.originalname, 'latin1').toString(
      'utf8',
    );
    cb(null, file.originalname);
  },
});

export {storage};
