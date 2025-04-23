import { Module } from '@nestjs/common';
import { WorkoutService } from './workout.service';
import { WorkoutController } from './workout.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Workout } from './workout.entity';
import { ExerciseModule } from 'src/exercise/exercise.module';
import { UserModule } from 'src/user/user.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Workout]),
    ExerciseModule,
    UserModule,
],
  providers: [WorkoutService],
  controllers: [WorkoutController]
})
export class WorkoutModule {}
