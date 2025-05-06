import { Controller, Get, Query, Res } from '@nestjs/common';
import { AppService } from './app.service';
import { Response } from 'express';
import { join } from 'path';
import { ApiExcludeController } from '@nestjs/swagger';

@ApiExcludeController()
@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('redirect-reset')
  redirectReset(@Query('token') token: string, @Res() res: Response) {
    // Serve the redirect-reset.html page
    return res.sendFile(join(__dirname, '..', 'public', 'redirect-reset.html'));
  }

  @Get('reset-password')
  resetPassword(@Query('token') token: string, @Res() res: Response) {
    // Serve our HTML page for password reset
    return res.sendFile(join(__dirname, '..', 'public', 'reset-password.html'));
  }
}
