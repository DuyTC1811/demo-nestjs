import { Injectable, Logger } from '@nestjs/common';

@Injectable()
export class AppService {
  private readonly logger = new Logger(AppService.name);
  getHello(): string {
    this.logger.log('getHello() được gọi'); // Log cấp độ "log"
    this.logger.warn('Cảnh báo trong getHello()'); // Log cấp độ "warn"
    this.logger.error('Lỗi giả định trong getHello()'); // Log cấp độ "error"
    return 'Hello World!';
  }
}
