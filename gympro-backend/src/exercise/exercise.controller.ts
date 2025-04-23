import { Controller, Get, Post, Body, Param, Delete, ParseIntPipe, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBody, ApiBearerAuth} from '@nestjs/swagger';
import { ExerciseService } from './exercise.service';
import { Exercise } from './exercise.entity';
import { CreateExerciseDto } from './dto/create-exercise.dto';
import { AuthGuard } from '@nestjs/passport/dist/auth.guard';

@ApiTags('exercises')
@ApiBearerAuth()
@UseGuards(AuthGuard('jwt'))
@Controller('exercises')
export class ExerciseController {
  constructor(private readonly exerciseService: ExerciseService) {}

  @Post()
  @ApiOperation({ summary: 'Create a new exercise' })
  @ApiBody({ type: CreateExerciseDto })
  @ApiResponse({ status: 400, description: 'Bad request' })
  async createExercise(
    @Body() createExerciseDto: CreateExerciseDto
  ): Promise<Exercise> {
    return this.exerciseService.createExercise(createExerciseDto);
  }

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

  @Delete(':id')
  @ApiOperation({ summary: 'Delete an exercise' })
  
  @ApiResponse({ status: 204, description: 'Exercise successfully deleted' })
  @ApiResponse({ status: 404, description: 'Exercise not found' })
  async deleteExercise(
    @Param('id', ParseIntPipe) id: number
  ): Promise<void> {
    await this.exerciseService.deleteExercise(id);
  }
}