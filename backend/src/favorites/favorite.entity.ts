import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, Unique } from 'typeorm';
import { User } from '../user/user.entity';
import { Exercise } from '../exercise/exercise.entity';
import { Workout } from '../workout/workout.entity';

// Entity for favorite exercises
@Entity('favorite_exercise')
@Unique(['user', 'exercise']) // Prevent duplicate favorites
export class FavoriteExercise {
    @PrimaryGeneratedColumn()
    id: number;

    @ManyToOne(() => User, { onDelete: 'CASCADE' })
    @JoinColumn()
    user: User;

    @ManyToOne(() => Exercise)
    @JoinColumn()
    exercise: Exercise;

    @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
    createdAt: Date;
}

// Entity for favorite workouts
@Entity('favorite_workout')
@Unique(['user', 'workout']) // Prevent duplicate favorites
export class FavoriteWorkout {
    @PrimaryGeneratedColumn()
    id: number;

    @ManyToOne(() => User, { onDelete: 'CASCADE' })
    @JoinColumn()
    user: User;

    @ManyToOne(() => Workout)
    @JoinColumn()
    workout: Workout;

    @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
    createdAt: Date;
}