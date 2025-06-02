import { Body, Controller, Delete, Get, Param, ParseIntPipe, Patch, Post, Request, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { WorkoutService } from './workout.service';
import { CreateWorkoutDto } from './dto/create-workout.dto';
import { ApiBearerAuth, ApiBody, ApiOperation, ApiParam, ApiResponse, ApiTags, ApiUnauthorizedResponse } from '@nestjs/swagger';
import { UserService } from 'src/user/user.service';
import { UpdateWorkoutDto } from './dto/update-workout.dto';
import { GymMemberGuard } from 'src/auth/gym-member.guard';
import { RequiresGymMembership } from 'src/auth/requires-membership.decorator';

@ApiTags('workouts')
@Controller('workouts')
export class WorkoutController {
    constructor(
        private readonly workoutService: WorkoutService,
        private readonly userService: UserService, 
    ) {}

    // Public endpoints - available to all users

    @Get('public')
    @ApiOperation({ summary: 'Get basic workouts (public)' })
    @ApiResponse({ status: 200, description: 'List of basic workouts' })
    async getPublicWorkouts() {
        return this.workoutService.getBasicWorkouts();
    }

    @Get('public/muscle-group/:group')
    @ApiOperation({ summary: 'Get basic workouts by muscle group (public)' })
    @ApiParam({ name: 'group', description: 'Muscle group name' })
    async getPublicWorkoutsByMuscleGroup(
        @Param('group') group: string,
    ) {
        return this.workoutService.getBasicWorkoutsByMuscleGroup(group);
    }

    // Premium endpoints - requires gym membership@Post()
    @UseGuards(AuthGuard('jwt'), GymMemberGuard)
    @RequiresGymMembership()
    @ApiBearerAuth()
    @ApiOperation({ summary: 'Create a new workout (premium)' })
    @ApiBody({ type: CreateWorkoutDto })
    @ApiResponse({ status: 401, description: 'This feature requires an active gym membership' })
    async create(
        @Body() createWorkoutDto: CreateWorkoutDto,
        @Request() req:{user: {id: number}}){
        const user = await this.userService.getUserById(req.user.id);
        return this.workoutService.createWorkout(createWorkoutDto, user);
    }    @Post('default')
    @UseGuards(AuthGuard('jwt'), GymMemberGuard)
    @RequiresGymMembership()
    @ApiBearerAuth()
    @ApiOperation({ summary: 'Create default workouts for the user (premium)' })
    @ApiResponse({ status: 401, description: 'This feature requires an active gym membership' })
    @ApiUnauthorizedResponse({ description: 'Unauthorized' })
    async createDefaultWorkouts(@Request() req: { user: { id: number } }) {
        const user = await this.userService.getUserById(req.user.id);
        return this.workoutService.createDefaultWorkouts(user);
    }    @Post('sample')
    @UseGuards(AuthGuard('jwt'))
    @ApiBearerAuth()
    @ApiOperation({ summary: 'Create sample workouts for testing' })
    @ApiUnauthorizedResponse({ description: 'Unauthorized' })
    async createSampleWorkouts() {
        return this.workoutService.createSampleWorkoutsForTesting();
    }

    @Get()
    @UseGuards(AuthGuard('jwt'), GymMemberGuard)
    @RequiresGymMembership()
    @ApiBearerAuth()
    @ApiOperation({ summary: 'Get all workouts (premium)' })
    @ApiResponse({ status: 401, description: 'This feature requires an active gym membership' })
    async findAll() {
        return this.workoutService.findAll();
    }    @Get(':id')
    @UseGuards(AuthGuard('jwt'), GymMemberGuard)
    @RequiresGymMembership()
    @ApiBearerAuth()
    @ApiOperation({ summary: 'Get workout by ID (premium)' })
    @ApiParam({ name: 'id', description: 'Workout ID' })
    @ApiResponse({ status: 404, description: 'Workout not found' })
    @ApiResponse({ status: 401, description: 'This feature requires an active gym membership' })
    async findById(
        @Param('id', ParseIntPipe) id: number
    ) {
        return this.workoutService.findById(id);
    }

    @Get('muscle-group/:group')
    @UseGuards(AuthGuard('jwt'), GymMemberGuard)
    @RequiresGymMembership()
    @ApiBearerAuth()
    @ApiOperation({ summary: 'Get workouts by muscle group (premium)' })
    @ApiParam({ name: 'group', description: 'Muscle group name' })
    @ApiResponse({ status: 401, description: 'This feature requires an active gym membership' })
    async findByMuscleGroup(
        @Param('group') group: string,
    ) {
        return this.workoutService.findByMuscleGroup(group);
    }    @Patch(':id')
    @UseGuards(AuthGuard('jwt'), GymMemberGuard)
    @RequiresGymMembership()
    @ApiBearerAuth()
    @ApiOperation({ summary: 'Update a workout (premium)' })
    @ApiParam({ name: 'id', description: 'Workout ID' })
    @ApiBody({ type: UpdateWorkoutDto })
    @ApiResponse({ status: 404, description: 'Workout not found' })
    @ApiResponse({ status: 401, description: 'This feature requires an active gym membership' })
    async update(
        @Param('id', ParseIntPipe) id: number,
        @Body() updateWorkoutDto: UpdateWorkoutDto,
        @Request() req: {user: {id: number}}
    ) {
        const user = await this.userService.getUserById(req.user.id);
        return this.workoutService.updateWorkout(id, updateWorkoutDto, user);
    }    @Delete(':id')
    @UseGuards(AuthGuard('jwt'), GymMemberGuard)
    @RequiresGymMembership()
    @ApiBearerAuth()
    @ApiOperation({ summary: 'Delete a workout (premium)' })
    @ApiParam({ name: 'id', description: 'Workout ID' })
    @ApiResponse({ status: 204, description: 'Workout successfully deleted' })
    @ApiResponse({ status: 404, description: 'Workout not found' })
    @ApiResponse({ status: 401, description: 'This feature requires an active gym membership' })
    async remove(
        @Param('id', ParseIntPipe) id: number,
        @Request() req: {user: {id: number}}
    ) {
        const user = await this.userService.getUserById(req.user.id);
        await this.workoutService.deleteWorkout(id, user);
        return { message: 'Workout deleted successfully' };
    }
}

