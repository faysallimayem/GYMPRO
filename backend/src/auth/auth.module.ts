import { Module, forwardRef } from '@nestjs/common';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { UserModule } from 'src/user/user.module';
import { JwtModule } from '@nestjs/jwt';
import { jwtConstants } from './constants';
import { JwtStrategy } from './jwt-strategy';
import { WorkoutModule } from 'src/workout/workout.module';
import { JwtAuthGuard } from './jwt-auth.guard';

@Module({
  imports: [
    forwardRef(() => UserModule),
    forwardRef(() => WorkoutModule), // Use forwardRef to break circular dependency
    JwtModule.register({
      secret:jwtConstants.secret,
      signOptions: {expiresIn: jwtConstants.expiresIn}
    }),
  ],
  controllers: [AuthController],
  providers: [AuthService, JwtStrategy, JwtAuthGuard],
  exports: [AuthService, JwtStrategy, JwtModule, JwtAuthGuard],
})
export class AuthModule {}
