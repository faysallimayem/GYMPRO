import { NestFactory } from '@nestjs/core';
import * as dotenv from 'dotenv';
dotenv.config();
import { AppModule } from './app.module';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

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
