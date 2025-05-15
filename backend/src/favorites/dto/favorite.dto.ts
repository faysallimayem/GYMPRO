import { IsNumber } from 'class-validator';

export class AddFavoriteExerciseDto {
  @IsNumber()
  exerciseId: number;
}

export class AddFavoriteWorkoutDto {
  @IsNumber()
  workoutId: number;
}