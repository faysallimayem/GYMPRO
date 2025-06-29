import { Body, Controller, Get, NotFoundException, Post, Req, UnauthorizedException, UseGuards, ConflictException } from '@nestjs/common';
import { AuthService } from './auth.service';
import { CreateUserDto } from 'src/user/dto/create-user.dto';
import { LoginDto } from './dto/login.dto';
import { UserService } from 'src/user/user.service';
import { ApiBearerAuth, ApiBody, ApiOperation, ApiTags } from '@nestjs/swagger';
import { ForgotPasswordDto } from './dto/forgot-password.dto';
import { ResetPasswordDto } from './dto/reset-password.dto';
import { SignupDto } from './dto/signup.dto';
import { AuthGuard } from '@nestjs/passport';
import { WorkoutService } from 'src/workout/workout.service';
import { AccesscodeService } from 'src/accesscode/accesscode.service';
import { RolesGuard } from './roles.guard';
import { Roles } from './roles.decorator';
import { Role } from 'src/user/role.enum';

@ApiTags('auth') 
@Controller('auth')
export class AuthController {
    constructor(
        private authService: AuthService,
        private userService: UserService,
        private workoutService: WorkoutService,
        private accesscodeService: AccesscodeService
    ) {}

    @Post('signup')
    @ApiOperation({ summary: 'Sign up a new user' })
    @ApiBody({ type: SignupDto })
    async signUp(@Body() createUserDto: CreateUserDto) {
        const result = await this.authService.signUp(createUserDto);
        
        // Get user and create default workouts
        const user = await this.userService.getByEmail(createUserDto.email);
        if (user) {
            console.log(`Creating default workouts for new user: ${user.email}`);
            await this.workoutService.createDefaultWorkouts(user);
        }
        
        return result;
    }

    @Post('login')
    @ApiOperation({ summary: 'Log in a user' })
    @ApiBody({ type: LoginDto })
    async logIn(@Body() loginDto: LoginDto) {
        try {
            console.log('Login attempt with:', { email: loginDto.email });
            const result = await this.authService.logIn(loginDto.email, loginDto.password);
            
            // Get user and ensure they have default workouts
            const user = await this.userService.getByEmail(loginDto.email);
            if (user) {
                console.log(`Checking default workouts for user: ${user.email}`);
                // This will only create workouts if the user doesn't have any
                await this.workoutService.createDefaultWorkouts(user);
            }
            
            return result;
        } catch (error) {
            console.error('Login error:', error);
            throw error;
        }
    }

    @Post('forgot-password')
    @ApiOperation({ summary: 'Request a password reset' })
    @ApiBody({ type: ForgotPasswordDto })
    async forgotPassword(@Body() forgotPasswordDto: ForgotPasswordDto) {
        const user = await this.userService.getByEmail(forgotPasswordDto.email);
        if (!user) {
            return { message: 'If an account exists, a reset link has been sent' };
        }

        const token = await this.authService.generateResetToken(user.id);
        await this.authService.sendResetEmail(user.email, token);
        return { message: 'Reset link sent! Check your email' };
    }

    @Post('reset-password')
    @ApiOperation({ summary: 'Reset user password' })
    @ApiBody({ type: ResetPasswordDto })
    async resetPassword(@Body() resetPasswordDto: ResetPasswordDto) {
        const { token, newPassword } = resetPasswordDto;
        const userId = this.authService.verifyResetToken(token);
        if (!userId) {
            throw new UnauthorizedException('Invalid or expired token');
        }
        
        await this.authService.updateUserPassword(await userId, newPassword);
        return { message: 'Password updated successfully' };
    }
    @ApiBearerAuth()
    @UseGuards(AuthGuard('jwt'))
    @Get('me')
    async getProfile(@Req() req) {
        // Always include managedGymId and managedGym in the response for consistency with /user/me
        const user = await this.userService.getProfile(req.user.id);
        if (!user) throw new NotFoundException('User not found');
        return {
            ...user,
            managedGymId: user.managedGym ? user.managedGym.id : null,
            managedGym: user.managedGym || null,
            gymId: user.gym ? user.gym.id : null,
            gym: user.gym || null,
        };
    }

    @ApiBearerAuth()
    @UseGuards(AuthGuard('jwt'), RolesGuard)
    @Roles(Role.ADMIN)
    @Post('generate-access-code')
    @ApiOperation({ summary: 'Generate access code for admin\'s managed gym' })
    async generateAccessCode(@Req() req: any) {
        // Get the admin user with managed gym
        const admin = await this.userService.getProfile(req.user.id);
        if (!admin) throw new NotFoundException('Admin not found');
        if (!admin.managedGym) throw new ConflictException('Admin is not assigned to manage any gym');
        
        // Generate access code for the admin's managed gym
        // Setting userId to 0 means it can be claimed by any user (first come, first served)
        const result = await this.accesscodeService.generateCode(
            { userId: 0, gymId: admin.managedGym.id, validityDays: 30 },
            req.user.id,
            req.ip
        );
        
        return { code: result.code };
    }
}
