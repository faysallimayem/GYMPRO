import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateMealColumnsToFloat1746388279030 implements MigrationInterface {

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Alter column types from integer to float to allow decimal values
        await queryRunner.query(`ALTER TABLE "meal" ALTER COLUMN "totalCalories" TYPE float USING "totalCalories"::float`);
        await queryRunner.query(`ALTER TABLE "meal" ALTER COLUMN "totalProtein" TYPE float USING "totalProtein"::float`);
        await queryRunner.query(`ALTER TABLE "meal" ALTER COLUMN "totalFat" TYPE float USING "totalFat"::float`);
        await queryRunner.query(`ALTER TABLE "meal" ALTER COLUMN "totalCarbohydrates" TYPE float USING "totalCarbohydrates"::float`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Revert column types back to integer if rollback is needed
        await queryRunner.query(`ALTER TABLE "meal" ALTER COLUMN "totalCalories" TYPE integer USING "totalCalories"::integer`);
        await queryRunner.query(`ALTER TABLE "meal" ALTER COLUMN "totalProtein" TYPE integer USING "totalProtein"::integer`);
        await queryRunner.query(`ALTER TABLE "meal" ALTER COLUMN "totalFat" TYPE integer USING "totalFat"::integer`);
        await queryRunner.query(`ALTER TABLE "meal" ALTER COLUMN "totalCarbohydrates" TYPE integer USING "totalCarbohydrates"::integer`);
    }

}
