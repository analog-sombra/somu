import 'package:isar/isar.dart';

import '../utils/enums.dart';

part 'todo.g.dart';

@collection
class Todo {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String title;

  late String description;
  @Index()
  late DateTime dateTime;
  @enumerated
  late DailyTasks status;
}
