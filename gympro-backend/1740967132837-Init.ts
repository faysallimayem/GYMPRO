import { MigrationInterface, QueryRunner } from "typeorm";

export class Init1740967132837 implements MigrationInterface {
    name = 'Init1740967132837'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE \`user\` (\`id\` int NOT NULL AUTO_INCREMENT, \`nom\` varchar(255) NOT NULL, \`prenom\` varchar(255) NOT NULL, \`email\` varchar(255) NOT NULL, \`mot_de_passe\` varchar(255) NOT NULL, \`dateNaissance\` datetime NOT NULL, \`role\` enum ('client', 'coach', 'admin') NOT NULL DEFAULT 'client', \`hauteur\` int NULL, \`poids\` int NULL, \`sexe\` varchar(255) NULL, UNIQUE INDEX \`IDX_e12875dfb3b1d92d7d7c5377e2\` (\`email\`), INDEX \`IDX_6620cd026ee2b231beac7cfe57\` (\`role\`), PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
        await queryRunner.query(`CREATE TABLE \`client\` (\`id\` int NOT NULL AUTO_INCREMENT, \`nom\` varchar(255) NOT NULL, \`prenom\` varchar(255) NOT NULL, \`email\` varchar(255) NOT NULL, \`mot_de_passe\` varchar(255) NOT NULL, \`dateNaissance\` datetime NOT NULL, \`role\` enum ('client', 'coach', 'admin') NOT NULL DEFAULT 'client', \`hauteur\` int NULL, \`poids\` int NULL, \`sexe\` varchar(255) NULL, UNIQUE INDEX \`IDX_6436cc6b79593760b9ef921ef1\` (\`email\`), PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
        await queryRunner.query(`CREATE TABLE \`coach\` (\`id\` int NOT NULL AUTO_INCREMENT, \`nom\` varchar(255) NOT NULL, \`prenom\` varchar(255) NOT NULL, \`email\` varchar(255) NOT NULL, \`mot_de_passe\` varchar(255) NOT NULL, \`dateNaissance\` datetime NOT NULL, \`role\` enum ('client', 'coach', 'admin') NOT NULL DEFAULT 'client', UNIQUE INDEX \`IDX_a1583a1abd23efb2f821c09678\` (\`email\`), PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
        await queryRunner.query(`CREATE TABLE \`admin\` (\`id\` int NOT NULL AUTO_INCREMENT, \`nom\` varchar(255) NOT NULL, \`prenom\` varchar(255) NOT NULL, \`email\` varchar(255) NOT NULL, \`mot_de_passe\` varchar(255) NOT NULL, \`dateNaissance\` datetime NOT NULL, \`role\` enum ('client', 'coach', 'admin') NOT NULL DEFAULT 'client', UNIQUE INDEX \`IDX_de87485f6489f5d0995f584195\` (\`email\`), PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP INDEX \`IDX_de87485f6489f5d0995f584195\` ON \`admin\``);
        await queryRunner.query(`DROP TABLE \`admin\``);
        await queryRunner.query(`DROP INDEX \`IDX_a1583a1abd23efb2f821c09678\` ON \`coach\``);
        await queryRunner.query(`DROP TABLE \`coach\``);
        await queryRunner.query(`DROP INDEX \`IDX_6436cc6b79593760b9ef921ef1\` ON \`client\``);
        await queryRunner.query(`DROP TABLE \`client\``);
        await queryRunner.query(`DROP INDEX \`IDX_6620cd026ee2b231beac7cfe57\` ON \`user\``);
        await queryRunner.query(`DROP INDEX \`IDX_e12875dfb3b1d92d7d7c5377e2\` ON \`user\``);
        await queryRunner.query(`DROP TABLE \`user\``);
    }

}
