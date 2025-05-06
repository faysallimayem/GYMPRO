import { MigrationInterface, QueryRunner } from "typeorm";

export class RenameColumnsToEnglish1746384489286 implements MigrationInterface {

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Rename columns in user table
        await queryRunner.query(`ALTER TABLE \`user\` CHANGE \`nom\` \`lastName\` varchar(255) NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`user\` CHANGE \`prenom\` \`firstName\` varchar(255) NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`user\` CHANGE \`mot_de_passe\` \`password\` varchar(255) NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`user\` CHANGE \`hauteur\` \`height\` int NULL`);
        await queryRunner.query(`ALTER TABLE \`user\` CHANGE \`poids\` \`weight\` int NULL`);
        await queryRunner.query(`ALTER TABLE \`user\` CHANGE \`sexe\` \`gender\` varchar(255) NULL`);

        // Rename columns in client table
        await queryRunner.query(`ALTER TABLE \`client\` CHANGE \`nom\` \`lastName\` varchar(255) NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`client\` CHANGE \`prenom\` \`firstName\` varchar(255) NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`client\` CHANGE \`mot_de_passe\` \`password\` varchar(255) NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`client\` CHANGE \`hauteur\` \`height\` int NULL`);
        await queryRunner.query(`ALTER TABLE \`client\` CHANGE \`poids\` \`weight\` int NULL`);
        await queryRunner.query(`ALTER TABLE \`client\` CHANGE \`sexe\` \`gender\` varchar(255) NULL`);

        // Rename columns in coach table
        await queryRunner.query(`ALTER TABLE \`coach\` CHANGE \`nom\` \`lastName\` varchar(255) NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`coach\` CHANGE \`prenom\` \`firstName\` varchar(255) NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`coach\` CHANGE \`mot_de_passe\` \`password\` varchar(255) NOT NULL`);

        // Rename columns in admin table
        await queryRunner.query(`ALTER TABLE \`admin\` CHANGE \`nom\` \`lastName\` varchar(255) NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`admin\` CHANGE \`prenom\` \`firstName\` varchar(255) NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`admin\` CHANGE \`mot_de_passe\` \`password\` varchar(255) NOT NULL`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Revert column changes in admin table
        await queryRunner.query(`ALTER TABLE \`admin\` CHANGE \`lastName\` \`nom\` varchar(255) NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`admin\` CHANGE \`firstName\` \`prenom\` varchar(255) NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`admin\` CHANGE \`password\` \`mot_de_passe\` varchar(255) NOT NULL`);

        // Revert column changes in coach table
        await queryRunner.query(`ALTER TABLE \`coach\` CHANGE \`lastName\` \`nom\` varchar(255) NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`coach\` CHANGE \`firstName\` \`prenom\` varchar(255) NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`coach\` CHANGE \`password\` \`mot_de_passe\` varchar(255) NOT NULL`);

        // Revert column changes in client table
        await queryRunner.query(`ALTER TABLE \`client\` CHANGE \`lastName\` \`nom\` varchar(255) NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`client\` CHANGE \`firstName\` \`prenom\` varchar(255) NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`client\` CHANGE \`password\` \`mot_de_passe\` varchar(255) NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`client\` CHANGE \`height\` \`hauteur\` int NULL`);
        await queryRunner.query(`ALTER TABLE \`client\` CHANGE \`weight\` \`poids\` int NULL`);
        await queryRunner.query(`ALTER TABLE \`client\` CHANGE \`gender\` \`sexe\` varchar(255) NULL`);

        // Revert column changes in user table
        await queryRunner.query(`ALTER TABLE \`user\` CHANGE \`lastName\` \`nom\` varchar(255) NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`user\` CHANGE \`firstName\` \`prenom\` varchar(255) NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`user\` CHANGE \`password\` \`mot_de_passe\` varchar(255) NOT NULL`);
        await queryRunner.query(`ALTER TABLE \`user\` CHANGE \`height\` \`hauteur\` int NULL`);
        await queryRunner.query(`ALTER TABLE \`user\` CHANGE \`weight\` \`poids\` int NULL`);
        await queryRunner.query(`ALTER TABLE \`user\` CHANGE \`gender\` \`sexe\` varchar(255) NULL`);
    }
}
