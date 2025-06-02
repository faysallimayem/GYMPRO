import { Injectable, UnauthorizedException } from '@nestjs/common';
import { UserService } from 'src/user/user.service';
import * as bcrypt from 'bcrypt';
import { JwtService } from '@nestjs/jwt';
import { CreateUserDto } from 'src/user/dto/create-user.dto';
import * as nodemailer from 'nodemailer';
import { jwtConstants } from './constants';
import emailConfig from 'src/config/email.config';


@Injectable()
export class AuthService {
    
    constructor(
        private userService: UserService,
        private jwtService: JwtService
    ) {}

    async logIn(email: string, password: string): Promise<{access_token: string}>{
        try {
            const user = await this.userService.getByEmail(email);
            if (!user) {
                throw new UnauthorizedException('Email not found');
            }

            // Log what we're comparing
            console.log('Auth attempt - Email:', email);

            if (!password) {
                console.error('Password is missing in login request');
                throw new UnauthorizedException('Password is required');
            }
            
            // Use the password field (which maps to mot_de_passe column)
            if (!user.password) {
                console.error('User has no password hash stored');
                throw new UnauthorizedException('Invalid login credentials');
            }

            try {
                const auth_password = await bcrypt.compare(password, user.password);
                if (!auth_password) {
                    throw new UnauthorizedException('Incorrect password');
                }
            } catch (bcryptError) {
                console.error('bcrypt comparison error:', bcryptError.message);
                throw new UnauthorizedException('Authentication failed');
            }
              // Password destructuring
            const { password: pwd, ...userData } = user;
            
            // Ensure the ID is a valid number
            const userId = typeof userData.id === 'number' ? userData.id : parseInt(String(userData.id), 10);
            if (isNaN(userId)) {
                console.error('Invalid user ID during login:', userData.id);
                throw new UnauthorizedException('Authentication failed due to invalid user ID');
            }
            
            console.log('Creating JWT with user ID:', userId);
            
            const payload = {
              sub: userId,
              email: userData.email,
              role: userData.role,
              ...(userData.role === 'admin' && userData.managedGym ? { managedGym: userData.managedGym } : {})
            };
            const access_token = this.jwtService.sign(payload);
            console.log('Authentication successful for user:', email);
            return { access_token };
        } catch (error) {
            console.error('Login error:', error.message);
            if (error instanceof UnauthorizedException) {
                throw error;
            }
            throw new UnauthorizedException('Authentication failed');
        }
    }

    async signUp(createUserDto: CreateUserDto): Promise<{access_token: string, user: any}>  {
       const {email, password} = createUserDto;

       //checking email 
       const existingUser = await this.userService.getByEmail(email);
       if(existingUser){
           throw new UnauthorizedException('Email already exists');
       }

       //hashing password
       const hashedPassword = await bcrypt.hash(password, 10);

       //create new user
       const newUser = await this.userService.create({
        ...createUserDto,
        password: hashedPassword,
       });

       // Remove password from user data before returning
       const {password: pwd, ...userDataWithoutPassword} = newUser;

       //JWT
       const payload = {email: newUser.email, sub: newUser.id, role: newUser.role};
       const access_token = this.jwtService.sign(payload);
       return {access_token, user: userDataWithoutPassword};
    } 

    async generateResetToken(id: number): Promise<string> {
       return this.jwtService.sign({id}, { secret: process.env.JWT_SECRET, expiresIn: '1h' });
    }

    async sendResetEmail(email: string, token: string) {
        // Create a universal link that will work on both platforms
        const universalResetLink = `http://localhost:3000/redirect-reset?token=${token}`;
      
        const transporter = nodemailer.createTransport({
          host: emailConfig.host,
          port: emailConfig.port,
          secure: emailConfig.secure,
          auth: {
            user: emailConfig.auth.user,
            pass: emailConfig.auth.pass,
          },
        });
      
        const mailOptions = {
          from: emailConfig.from, 
          to: email,
          subject: "Reset Your Password - GYM PRO",
          html: `
            <div style="font-family: Arial, sans-serif; padding: 20px; max-width: 600px; margin: 0 auto; border: 1px solid #eaeaea; border-radius: 5px;">
              <div style="text-align: center; margin-bottom: 20px;">
                <img src="https://via.placeholder.com/150x60?text=GYMPRO" alt="GYM PRO Logo" style="max-width: 150px;">
              </div>
              <h2 style="color: #FF6B00; text-align: center;">Password Reset</h2>
              <p style="color: #333; font-size: 16px; line-height: 1.5; margin-bottom: 20px;">You requested a password reset for your GYM PRO account. Click the button below to set a new password:</p>
              
              <div style="text-align: center; margin: 30px 0;">
                <a href="${universalResetLink}" style="background-color: #FF6B00; color: white; padding: 12px 30px; text-decoration: none; border-radius: 4px; font-weight: bold; display: inline-block; font-size: 16px;">Reset Your Password</a>
              </div> 
              
              <p style="color: #666; font-size: 14px; margin-top: 30px;">If you didn't request a password reset, please ignore this email or contact support if you have concerns.</p>
              
              <div style="margin-top: 40px; padding-top: 20px; border-top: 1px solid #eaeaea; text-align: center; color: #666; font-size: 12px;">
                <p>© 2025 GYM PRO. All rights reserved.</p>
              </div>
            </div>
          `,
        };
      
        try {
          await transporter.sendMail(mailOptions);
          console.log(`Password reset email sent to ${email}`);
        } catch (error) {
          console.error("Error sending email:", error);
          throw new Error("Could not send password reset email");
        }
      }
      

    async verifyResetToken(token: string){
        try {
            const decoded = this.jwtService.verify(token, { secret: jwtConstants.secret });
            return decoded.id;
        } catch (error) {
            return null;
        }
    }

    async updateUserPassword(userId: number, newpassword: string) {
        const hashedPassword = await bcrypt.hash(newpassword, 10);
        await this.userService.updateUser(userId, { password: hashedPassword });
    }
}