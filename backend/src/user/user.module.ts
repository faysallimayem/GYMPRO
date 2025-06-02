import { Module, forwardRef } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from './user.entity';
import { AuthModule } from '../auth/auth.module';
import { UserService } from './user.service';
import { UserController } from './user.controller';
import { ProfileController } from './profile.controller';
import { TenderModule } from '../tender/tender.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([User]),
    forwardRef(() => AuthModule),
    forwardRef(() => TenderModule)
  ],
  providers: [UserService],
  controllers: [UserController, ProfileController],
  exports: [UserService], 
})
export class UserModule {}
