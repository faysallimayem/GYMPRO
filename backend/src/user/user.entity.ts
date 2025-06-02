import { Entity, PrimaryGeneratedColumn, Column, TableInheritance, OneToMany, ManyToOne, JoinColumn } from 'typeorm';
import { Role } from './role.enum';
import { Subscription } from '../subscription/subscription.entity';
import { Gym } from '../gym/gym.entity';
import { Tender } from '../tender/tender.entity';
import { Offer } from '../tender/offer.entity';

@Entity('user') 
 
export class User {
    @PrimaryGeneratedColumn()
    id: number;

    @Column({ name: 'nom' })
    lastName: string;

    @Column({ name: 'prenom' })
    firstName: string;

    @Column({ unique: true })
    email: string;

    @Column({ name: 'mot_de_passe' })
    password: string;

    @Column({nullable: true})
    age: number;

    @Column({ name: 'hauteur', nullable: true })
    height: number;

    @Column({ name: 'poids', nullable: true })
    weight: number;

    @Column({ name: 'sexe' })
    gender: string;

    @Column({ name: 'photo_url', nullable: true })
    photoUrl: string;

    @OneToMany(() => Subscription, (subscription) => subscription.user, {
        cascade: true,
        onDelete: 'CASCADE'
    })
    subscriptions: Subscription[];

    @Column({
        type: 'enum',
        enum: Role,
        default: Role.CLIENT, 
        nullable: false,
    })
    role: Role;
    
    @Column({ default: false })
    isGymMember: boolean;    @Column({ type: 'timestamp', nullable: true })
    membershipExpiresAt: Date;
    
    @ManyToOne(() => Gym, (gym) => gym.coaches, { nullable: true })
    @JoinColumn({ name: 'managedGymId' }) 
    managedGym: Gym; // For admins/coaches: which gym they manage
    
    @ManyToOne(() => Gym, (gym) => gym.clients, { nullable: true })
    @JoinColumn({ name: 'gym_id' }) // Added JoinColumn
    gym: Gym; // For clients: which gym they belong to
    
    @OneToMany(() => Tender, (tender) => tender.admin, {
        cascade: true
    })
    tenders: Tender[];

    @OneToMany(() => Offer, (offer) => offer.user, {
        cascade: true
    })
    offers: Offer[];
}
