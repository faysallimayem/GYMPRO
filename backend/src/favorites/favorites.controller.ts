import { Controller, Get, Post, Delete, Param, Body, UseGuards, Req, ParseIntPipe } from '@nestjs/common';
import { FavoritesService } from './favorites.service';
import { AuthGuard } from '@nestjs/passport';
import { AddFavoriteExerciseDto, AddFavoriteWorkoutDto } from './dto/favorite.dto';

@Controller('favorites')
@UseGuards(AuthGuard('jwt'))
export class FavoritesController {
  constructor(private readonly favoritesService: FavoritesService) {}

  // Get all favorite exercises for the authenticated user
  @Get('exercises')
  async getFavoriteExercises(@Req() req) {
    return this.favoritesService.getUserFavoriteExercises(req.user.id);
  }

  // Add an exercise to favorites
  @Post('exercises')
  async addFavoriteExercise(@Req() req, @Body() dto: AddFavoriteExerciseDto) {
    return this.favoritesService.addFavoriteExercise(req.user.id, dto.exerciseId);
  }

  // Remove an exercise from favorites
  @Delete('exercises/:id')
  async removeFavoriteExercise(@Req() req, @Param('id', ParseIntPipe) exerciseId: number) {
    return this.favoritesService.removeFavoriteExercise(req.user.id, exerciseId);
  }

  // Get all favorite workouts for the authenticated user
  @Get('workouts')
  async getFavoriteWorkouts(@Req() req) {
    return this.favoritesService.getUserFavoriteWorkouts(req.user.id);
  }

  // Add a workout to favorites
  @Post('workouts')
  async addFavoriteWorkout(@Req() req, @Body() dto: AddFavoriteWorkoutDto) {
    return this.favoritesService.addFavoriteWorkout(req.user.id, dto.workoutId);
  }

  // Remove a workout from favorites
  @Delete('workouts/:id')
  async removeFavoriteWorkout(@Req() req, @Param('id', ParseIntPipe) workoutId: number) {
    return this.favoritesService.removeFavoriteWorkout(req.user.id, workoutId);
  }
}