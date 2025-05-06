import { NestFactory } from '@nestjs/core';
import * as dotenv from 'dotenv';
dotenv.config();
import { AppModule } from './app.module';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { join } from 'path';
import { NestExpressApplication } from '@nestjs/platform-express';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule);
  app.enableCors();
  
  // Configure serving static files from the 'public' directory
  app.useStaticAssets(join(__dirname, '..', 'public'));

  const config = new DocumentBuilder()
      .setTitle('GYMPRO_API')
      .setDescription('API FOR GYMPRO')
      .setVersion('1.0')
      .addBearerAuth()
      .build();

  const document = SwaggerModule.createDocument(app,config);
  SwaggerModule.setup('api', app, document);    
  await app.listen(process.env.PORT ?? 3000);
}
bootstrap();
