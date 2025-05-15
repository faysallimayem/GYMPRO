import { Controller, Get, Param, ParseIntPipe, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { ExerciseService } from './exercise.service';
import { Exercise } from './exercise.entity';
import { AuthGuard } from '@nestjs/passport/dist/auth.guard';
import { RolesGuard } from 'src/auth/roles.guard';

@ApiTags('exercises')
@ApiBearerAuth()
@UseGuards(AuthGuard('jwt'), RolesGuard)
@Controller('exercises')
export class ExerciseController {
  constructor(private readonly exerciseService: ExerciseService) {}

  @Get()
  @ApiOperation({ summary: 'Get all exercises' })
  async getAllExercises(): Promise<Exercise[]> {
    return this.exerciseService.getAllExercises();
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get exercise by ID' })
  @ApiResponse({ status: 404, description: 'Exercise not found' })
  async getExerciseById(
    @Param('id', ParseIntPipe) id: number
  ): Promise<Exercise | null> {
    return this.exerciseService.getExerciseById(id);
  }

  @Get('muscle-group/:muscleGroup')
  @ApiOperation({ summary: 'Get exercises by muscle group' })
  @ApiResponse({ status: 200, description: 'Return all exercises for a specific muscle group' })
  async getExercisesByMuscleGroup(
    @Param('muscleGroup') muscleGroup: string
  ): Promise<Exercise[]> {
    return this.exerciseService.getExercisesByMuscleGroup(muscleGroup);
  }
}