import { MigrationInterface, QueryRunner } from "typeorm";

export class RemoveExerciseDifficulty1714673945123 implements MigrationInterface {
    name = 'RemoveExerciseDifficulty1714673945123';

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Drop the difficulty column from the exercise table
        await queryRunner.query(`ALTER TABLE "exercise" DROP COLUMN "difficulty"`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Add the difficulty column back if needed to rollback
        await queryRunner.query(`ALTER TABLE "exercise" ADD "difficulty" varchar DEFAULT 'beginner'`);
    }
}