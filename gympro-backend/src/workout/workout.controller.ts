import { Body, Controller, Delete, Get, Param, ParseIntPipe, Patch, Post, Request, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { WorkoutService } from './workout.service';
import { CreateWorkoutDto } from './dto/create-workout.dto';
import { ApiBearerAuth, ApiBody, ApiOperation, ApiParam, ApiResponse, ApiTags, ApiUnauthorizedResponse } from '@nestjs/swagger';
import { UserService } from 'src/user/user.service';
import { UpdateWorkoutDto } from './dto/update-workout.dto';

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

    @Post('default')
    @ApiOperation({ summary: 'Create default workouts for the user' })
    @ApiUnauthorizedResponse({ description: 'Unauthorized' })
    async createDefaultWorkouts(@Request() req: { user: { id: number } }) {
        const user = await this.userService.getUserById(req.user.id);
        return this.workoutService.createDefaultWorkouts(user);
    }

    @Post('sample')
    @ApiOperation({ summary: 'Create sample workouts for testing' })
    @ApiUnauthorizedResponse({ description: 'Unauthorized' })
    async createSampleWorkouts() {
        return this.workoutService.createSampleWorkoutsForTesting();
    }

    @Get()
    @ApiOperation({ summary: 'Get all workouts' })
    @ApiUnauthorizedResponse({ description: 'Unauthorized' })
    async findAll() {
        return this.workoutService.findAll();
    }

    @Get(':id')
    @ApiOperation({ summary: 'Get workout by ID' })
    @ApiParam({ name: 'id', description: 'Workout ID' })
    @ApiResponse({ status: 404, description: 'Workout not found' })
    @ApiUnauthorizedResponse({ description: 'Unauthorized' })
    async findById(
        @Param('id', ParseIntPipe) id: number
    ) {
        return this.workoutService.findById(id);
    }

    @Get('muscle-group/:group')
    @ApiOperation({ summary: 'Get workouts by muscle group' })
    @ApiParam({ name: 'group', description: 'Muscle group name' })
    @ApiUnauthorizedResponse({ description: 'Unauthorized' })
    async findByMuscleGroup(
        @Param('group') group: string,
    ) {
        return this.workoutService.findByMuscleGroup(group);
    }

    @Patch(':id')
    @ApiOperation({ summary: 'Update a workout' })
    @ApiParam({ name: 'id', description: 'Workout ID' })
    @ApiBody({ type: UpdateWorkoutDto })
    @ApiResponse({ status: 404, description: 'Workout not found' })
    @ApiUnauthorizedResponse({ description: 'Unauthorized' })
    async update(
        @Param('id', ParseIntPipe) id: number,
        @Body() updateWorkoutDto: UpdateWorkoutDto,
        @Request() req: {user: {id: number}}
    ) {
        const user = await this.userService.getUserById(req.user.id);
        return this.workoutService.updateWorkout(id, updateWorkoutDto, user);
    }

    @Delete(':id')
    @ApiOperation({ summary: 'Delete a workout' })
    @ApiParam({ name: 'id', description: 'Workout ID' })
    @ApiResponse({ status: 204, description: 'Workout successfully deleted' })
    @ApiResponse({ status: 404, description: 'Workout not found' })
    @ApiUnauthorizedResponse({ description: 'Unauthorized' })
    async remove(
        @Param('id', ParseIntPipe) id: number,
        @Request() req: {user: {id: number}}
    ) {
        const user = await this.userService.getUserById(req.user.id);
        await this.workoutService.deleteWorkout(id, user);
        return { message: 'Workout deleted successfully' };
    }
}

