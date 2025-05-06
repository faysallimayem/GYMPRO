import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateNutritionEntity1746295494166 implements MigrationInterface {

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Drop all existing items first since we need to change column type
        await queryRunner.query(`DELETE FROM "nutrition"`);
        
        // Change protein column type to float
        await queryRunner.query(`ALTER TABLE "nutrition" ALTER COLUMN "protein" TYPE float`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Revert back to integer type (note: this may cause data loss if there are decimal values)
        await queryRunner.query(`ALTER TABLE "nutrition" ALTER COLUMN "protein" TYPE integer`);
    }

}
