import { MigrationInterface, QueryRunner } from "typeorm";

export class AddMealEntities1746378081925 implements MigrationInterface {
    name = 'AddMealEntities1746378081925'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "meal_item" ("id" SERIAL NOT NULL, "nutritionId" integer NOT NULL, "quantity" integer NOT NULL DEFAULT '1', "unit" character varying NOT NULL DEFAULT 'serving', "mealId" integer, CONSTRAINT "PK_db36ad979c903d019f3866f823b" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "meal" ("id" SERIAL NOT NULL, "name" character varying NOT NULL, "description" character varying, "totalCalories" integer NOT NULL DEFAULT '0', "totalProtein" integer NOT NULL DEFAULT '0', "totalFat" integer NOT NULL DEFAULT '0', "totalCarbohydrates" integer NOT NULL DEFAULT '0', "createdAt" TIMESTAMP NOT NULL DEFAULT now(), "userId" integer, CONSTRAINT "PK_ada510a5aba19e6bb500f8f7817" PRIMARY KEY ("id"))`);
        await queryRunner.query(`ALTER TABLE "meal_item" ADD CONSTRAINT "FK_1c517a00db91263d8f97830b1b6" FOREIGN KEY ("nutritionId") REFERENCES "nutrition"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "meal_item" ADD CONSTRAINT "FK_8be06ec813d70b26a1564f9f01a" FOREIGN KEY ("mealId") REFERENCES "meal"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "meal_item" DROP CONSTRAINT "FK_8be06ec813d70b26a1564f9f01a"`);
        await queryRunner.query(`ALTER TABLE "meal_item" DROP CONSTRAINT "FK_1c517a00db91263d8f97830b1b6"`);
        await queryRunner.query(`DROP TABLE "meal"`);
        await queryRunner.query(`DROP TABLE "meal_item"`);
    }

}
