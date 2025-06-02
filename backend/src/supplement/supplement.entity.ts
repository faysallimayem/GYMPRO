import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn, ManyToOne } from 'typeorm';
import { Gym } from '../gym/gym.entity';

@Entity('supplement')
export class Supplement {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column('text')
  description: string;

  @Column('decimal', { precision: 10, scale: 2 })
  price: number;

  @Column()
  stock: number;
  
  @Column({ nullable: true })
  imageUrl: string;
  
  @Column({ nullable: true })
  category: string;
  
  @Column({ nullable: true })
  serving: string;

  @ManyToOne(() => Gym, { eager: true })
  gym: Gym;
}