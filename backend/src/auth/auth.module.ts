import { Module, forwardRef } from '@nestjs/common';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { UserModule } from '../user/user.module';
import { JwtModule } from '@nestjs/jwt';
import { jwtConstants } from './constants';
import { JwtStrategy } from './jwt-strategy';
import { WorkoutModule } from '../workout/workout.module';
import { JwtAuthGuard } from './jwt-auth.guard';
import { GymMemberGuard } from './gym-member.guard';
import { SubscriptionModule } from '../subscription/subscription.module';
import { TenderModule } from '../tender/tender.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from 'src/user/user.entity';
import { AccesscodeModule } from '../accesscode/accesscode.module';

@Module({  imports: [
    TypeOrmModule.forFeature([User]),
    forwardRef(() => UserModule),
    forwardRef(() => WorkoutModule), 
    forwardRef(() => SubscriptionModule),
    forwardRef(() => TenderModule),
    forwardRef(() => AccesscodeModule),
    JwtModule.register({
      secret: jwtConstants.secret,
      signOptions: { expiresIn: jwtConstants.expiresIn },
    }),
  ],
  controllers: [AuthController],
  providers: [AuthService, JwtStrategy, JwtAuthGuard, GymMemberGuard],
  exports: [AuthService, JwtStrategy, JwtModule, JwtAuthGuard, GymMemberGuard],
})
export class AuthModule {}
