import { Body, Controller, Get, Post, Request, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { WorkoutService } from './workout.service';
import { CreateWorkoutDto } from './dto/create-workout.dto';
import { ApiBearerAuth, ApiBody, ApiOperation, ApiTags, ApiUnauthorizedResponse } from '@nestjs/swagger';
import { UserService } from 'src/user/user.service';

@ApiTags('workouts')
@ApiBearerAuth()
@UseGuards(AuthGuard('jwt'))
@Controller('workouts')
export class WorkoutController {
    constructor(
        private readonly workoutService: WorkoutService,
        private readonly userService: UserService, 
    ) {}

    @Post()
    @ApiOperation({ summary: 'Create a new workout' })
    @ApiBody({ type: CreateWorkoutDto })
    @ApiUnauthorizedResponse({ description: 'Unauthorized' })
    async create(
        @Body() createWorkoutDto: CreateWorkoutDto,
        @Request() req:{user: {id: number}}){
        const user = await this.userService.getUserById(req.user.id);
        return this.workoutService.createWorkout(createWorkoutDto, user);
    }

    @Get()
    @ApiOperation({ summary: 'Get all workouts' })
    @ApiUnauthorizedResponse({ description: 'Unauthorized' })
    async findAll(@Request() req:{user: {id: number}}) {
        return this.workoutService.findAll(req.user.id);
  }
}

