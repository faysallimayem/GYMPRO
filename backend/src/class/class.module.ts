import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ClassController } from './class.controller';
import { ClassService } from './class.service';
import { GymClass } from './class.entity';
import { User } from '../user/user.entity';
import { Gym } from '../gym/gym.entity';
import { AuthModule } from '../auth/auth.module';
import { SubscriptionModule } from '../subscription/subscription.module';
import { UserModule } from '../user/user.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([GymClass, User, Gym]),
    AuthModule,
    SubscriptionModule,
    UserModule,
  ],
  controllers: [ClassController],
  providers: [ClassService],
  exports: [ClassService],
})
export class ClassModule {}