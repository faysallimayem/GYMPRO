import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class Nutrition {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column()
  protein: number; 

  @Column('float')
  calories: number;

  @Column('float')
  fat: number;

  @Column('float')
  carbohydrates: number;

  @Column({ nullable: true })
  imageUrl: string;
}
