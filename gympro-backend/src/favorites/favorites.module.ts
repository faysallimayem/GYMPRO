import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { FavoritesController } from './favorites.controller';
import { FavoritesService } from './favorites.service';
import { FavoriteExercise, FavoriteWorkout } from './favorite.entity';
import { User } from '../user/user.entity';
import { Workout } from '../workout/workout.entity';
import { Exercise } from '../exercise/exercise.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([FavoriteExercise, FavoriteWorkout, User, Workout, Exercise]),
  ],
  controllers: [FavoritesController],
  providers: [FavoritesService],
  exports: [FavoritesService],
})
export class FavoritesModule {}