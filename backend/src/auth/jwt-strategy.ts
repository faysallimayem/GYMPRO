import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { jwtConstants } from './constants';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from 'src/user/user.entity';
import { Repository } from 'typeorm';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy, 'jwt') {
    constructor(
        @InjectRepository(User)
        private readonly userRepository: Repository<User>, 
    ) {
        super({
            jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(), 
            ignoreExpiration: false,
            secretOrKey: jwtConstants.secret, 
        });
    }

    async validate(payload: any) {
        // Only return the minimal user info needed for authentication/authorization
        return {
            id: payload.sub, // JWT uses 'sub' for user ID
            email: payload.email,
            role: payload.role,
        };
    }
}
