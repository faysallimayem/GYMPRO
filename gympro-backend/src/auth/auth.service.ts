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

    async logIn(email: string, mot_de_passe: string): Promise<{access_token: string}>{
        const user = await this.userService.getByEmail(email);
        if (!user) {
            throw new UnauthorizedException('Email not found');
        }

        const auth_password = await bcrypt.compare(mot_de_passe, user.mot_de_passe);
        if (!auth_password) {
            throw new UnauthorizedException('Incorrect password');
        }
        
        //mot de passe destructuring
        const { mot_de_passe: password, ...userData } = user;
        
        
        //const payload = { sub: user.id, email: user.email, Role:user.role }; };
        const payload = { sub: userData.id, email: userData.email, Role:userData.role };
        const access_token = this.jwtService.sign(payload);
        return { access_token };

    }

    async signUp(CreateUserDto: CreateUserDto): Promise<{access_token: string}>  {
       const {email, mot_de_passe} = CreateUserDto;

       //checking email 
       const existingUser = await this.userService.getByEmail(email);
       if(existingUser){
           throw new UnauthorizedException('Email already exists');
       }

       //hashing password
       const hashedPassword = await bcrypt.hash(mot_de_passe, 10);

       //create new user
       const newUser = await this.userService.create({
        ...CreateUserDto,
        mot_de_passe: hashedPassword,
       })

       //JWT
       const payload ={email: newUser.email, sub: newUser.id, Role: newUser.role};
       const access_token= this.jwtService.sign(payload);
       return {access_token};
    } 

    async generateResetToken(id: number): Promise<string> {
       return this.jwtService.sign({id}, { secret: process.env.JWT_SECRET, expiresIn: '1h' });
    }

    async sendResetEmail(email: string, token: string) {
        const resetLink = `http://localhost:3000/reset-password?token=${token}`;
      
        const transporter = nodemailer.createTransport({
          host: emailConfig.host,
          port: emailConfig.port,
          secure: emailConfig.secure, // Use `true` if using port 465
          auth: {
            user: emailConfig.auth.user,
            pass: emailConfig.auth.pass,
          },
        });
      
        const mailOptions = {
          from: emailConfig.from, 
          to: email,
          subject: "Reset Password",
          html: `
            <p>You requested a password reset.</p>
            <p>Click the link below to reset your password:</p>
            <a href="${resetLink}">${resetLink}</a> 
            <p>If you didn't request this, please ignore this email.</p>
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
        await this.userService.updateUser(userId, { mot_de_passe: hashedPassword });
    }
}   