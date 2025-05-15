import { Module, forwardRef } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from './user.entity';
import { AuthModule } from 'src/auth/auth.module';
import { UserService } from './user.service';
import { UserController } from './user.controller';

@Module({
  imports: [
    TypeOrmModule.forFeature([User]),
    forwardRef(() =>AuthModule)
     
  ],
  providers: [UserService],
  controllers: [UserController],
  exports: [UserService], 
})
export class UserModule {}
