import { Entity, PrimaryGeneratedColumn, Column, TableInheritance } from 'typeorm';
import { Role } from './role.enum';

@Entity('user') 
 
export class User {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    nom: string;

    @Column()
    prenom: string;

    @Column({ unique: true })
    email: string;

    @Column()
    mot_de_passe: string;

<<<<<<< HEAD
    @Column()
    age: number;
=======
    @Column({type: 'date', nullable: true})
    dateNaissance: Date;
>>>>>>> 9d1304d90bc080f06820fa32cca9c346fa19f594

    @Column({nullable: true })
    hauteur: number;

    @Column({nullable: true })
    poids: number;

    @Column({})
    sexe: string;

    @Column({
        type: 'enum',
        enum: Role,
        default: Role.CLIENT, 
        nullable: false,
    })
    role: Role;
}
