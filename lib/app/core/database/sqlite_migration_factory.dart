
import 'package:todo_list_provider/app/core/database/migrations/migration.dart';
import 'package:todo_list_provider/app/core/database/migrations/migration_v1.dart';
import 'package:todo_list_provider/app/core/database/migrations/migrations_v2.dart';
import 'package:todo_list_provider/app/core/database/migrations/migrations_v3.dart';

class SqliteMigrationFactory {
  
  List<Migration> getCreateMigration() => [
    MigrationV1(),
    MigrationsV2(),
    MigrationsV3(),
  ];

  List<Migration> getUpgradeMigration(int version) {
    final migrations = <Migration>[];

    //  atual version -> 3
    // version 1 
    if (version == 1) {
      migrations.add(MigrationsV2());
      migrations.add(MigrationsV3());

    }

    if (version == 2) {
      migrations.add(MigrationsV3());
    }

    return migrations;

  }


}