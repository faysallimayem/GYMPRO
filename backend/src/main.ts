import { NestFactory } from '@nestjs/core';
import * as dotenv from 'dotenv';
dotenv.config();
import { AppModule } from './app.module';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { join } from 'path';
import { NestExpressApplication } from '@nestjs/platform-express';
import { ValidationPipe } from '@nestjs/common';
import * as cors from 'cors';
import * as express from 'express';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule);

  // Enable validation pipe globally
  app.useGlobalPipes(new ValidationPipe({
    transform: true, // Enable automatic transformation
    transformOptions: {
      enableImplicitConversion: true
    }
  }));

  // CORS configuration
  app.use(cors({
    origin: true, // Reflect the request origin
    credentials: true, // Allow cookies and auth headers
  }));

  // Configure serving static files from the 'public' directory
  app.useStaticAssets(join(__dirname, '..', 'public'));

  // Serve static files (like images)
  app.use('/uploads', express.static('uploads'));

  const config = new DocumentBuilder()
      .setTitle('GYMPRO_API')
      .setDescription('API FOR GYMPRO')
      .setVersion('1.0')
      .addBearerAuth()
      .build();

  const document = SwaggerModule.createDocument(app,config);
  SwaggerModule.setup('', app, document);    
  const port = process.env.PORT || 3000;
  await app.listen(port);
  console.log(`Application is running on: http://localhost:${port}`);
}
bootstrap();
