import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:somu/database/todo.dart';

late Isar isarDB;

Future<void> isarInit() async {
  final dir = await getApplicationSupportDirectory();
  isarDB = await Isar.open(
    [TodoSchema],
    directory: dir.path,
  );
}
