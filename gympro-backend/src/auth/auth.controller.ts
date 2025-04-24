import { Body, Controller, Get, Post, Req, UnauthorizedException, UseGuards } from '@nestjs/common';
import { AuthService } from './auth.service';
import { CreateUserDto } from 'src/user/dto/create-user.dto';
import { LoginDto } from './dto/login.dto';
import { UserService } from 'src/user/user.service';
import { ApiBearerAuth, ApiBody, ApiOperation, ApiTags } from '@nestjs/swagger';
import { ForgotPasswordDto } from './dto/forgot-password.dto';
import { ResetPasswordDto } from './dto/reset-password.dto';

import { SignupDto } from './dto/signup.dto';
import { AuthGuard } from '@nestjs/passport';

@ApiTags('auth') 
@Controller('auth')
export class AuthController {
    constructor(
        private authService: AuthService,
        private userService: UserService
    ) {}

    @Post('signup')
    @ApiOperation({ summary: 'Sign up a new user' })
    @ApiBody({ type: SignupDto })
    async signUp(@Body() createUserDto: CreateUserDto) {
        return this.authService.signUp(createUserDto);
    }

    @Post('login')
    @ApiOperation({ summary: 'Log in a user' })
    @ApiBody({ type: LoginDto })
    async logIn(@Body() loginDto: LoginDto) {
        return this.authService.logIn(loginDto.email, loginDto.mot_de_passe);
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
        console.log(req.user);
        return this.userService.getProfile(req.user.id);
    }
}
