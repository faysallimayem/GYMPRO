import { Module } from '@nestjs/common';
import { SupplementService } from './supplement.service';
import { SupplementController } from './supplement.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Supplement } from './supplement.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Supplement])],
  providers: [SupplementService],
  controllers: [SupplementController]
})
export class SupplementModule {}
