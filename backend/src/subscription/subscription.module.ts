import { Module, forwardRef } from '@nestjs/common';
import { SubscriptionService } from './subscription.service';
import { SubscriptionController } from './subscription.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Subscription } from './subscription.entity';
import { UserModule } from '../user/user.module';
import { AuthModule } from '../auth/auth.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Subscription]), 
    forwardRef(() => UserModule),
    forwardRef(() => AuthModule)
  ],
  providers: [SubscriptionService],
  controllers: [SubscriptionController],
  exports: [SubscriptionService] 
})
export class SubscriptionModule {}
