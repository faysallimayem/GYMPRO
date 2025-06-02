import { Module } from '@nestjs/common';
import { SupplementService } from './supplement.service';
import { SupplementController } from './supplement.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Supplement } from './supplement.entity';
import { User } from '../user/user.entity';
import { AuthModule } from '../auth/auth.module';
import { SubscriptionModule } from '../subscription/subscription.module';
import { UserModule } from '../user/user.module';
import { Gym } from '../gym/gym.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([Supplement, User, Gym]),
    AuthModule,
    SubscriptionModule,
    UserModule
  ],
  providers: [SupplementService],
  controllers: [SupplementController]
})
export class SupplementModule {}
