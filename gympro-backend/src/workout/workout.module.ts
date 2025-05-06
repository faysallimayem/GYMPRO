import { Module, forwardRef } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { WorkoutService } from './workout.service';
import { WorkoutController } from './workout.controller';
import { Workout } from './workout.entity';
import { UserModule } from '../user/user.module';
import { Exercise } from '../exercise/exercise.entity';
import { WorkoutInitializationService } from './workout-initialization.service';
import { User } from '../user/user.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([Workout, Exercise, User]), 
    forwardRef(() => UserModule)  // Use forwardRef to break circular dependency
  ],
  controllers: [WorkoutController],
  providers: [WorkoutService, WorkoutInitializationService],
  exports: [WorkoutService],
})
export class WorkoutModule {}
