import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../database/database.dart';
import '../database/todo.dart';
import '../utils/alets.dart';
import '../utils/enums.dart';

final dailyState =
    ChangeNotifierProvider.autoDispose<DailyState>((ref) => DailyState());

class DailyState extends ChangeNotifier {
  DailyTasks dailyTask = DailyTasks.all;
  int allTodoCount = 0;
  int pandingTodoCount = 0;
  int completedTodoCount = 0;

  List<dynamic> todos = [];

  void changeDailyTask(DailyTasks taskType) async {
    dailyTask = taskType;
    await getTodo();
    notifyListeners();
  }

  Future<void> addTodo(
      String title, String description, BuildContext context) async {
    final existTodo = await isarDB.todos.where().titleEqualTo(title).findAll();
    if (existTodo.isNotEmpty) {
      erroralert(context, "Error", "Title alredy exist enter a diffrent title");
    } else {
      final todo = Todo()
        ..title = title
        ..description = description
        ..dateTime = DateTime.now()
        ..status = DailyTasks.pending;

      final res1 = await isarDB.writeTxn(() async {
        final res = await isarDB.todos.put(todo);
        if (res == 1) {
          erroralert(context, "Error", "Unable to add new todo");
        } else {
          susalert(context, "Done", "New todo is added");
        }
      });
    }
    notifyListeners();
  }

  Future<void> getallTodoCount() async {
    final allTodo = await isarDB.todos.where().findAll();
    allTodoCount = allTodo.length;
    notifyListeners();
  }

  Future<void> getCompletedCount() async {
    final allTodo = await isarDB.todos.where().findAll();
    int count = 0;
    for (int i = 0; i < allTodo.length; i++) {
      if (allTodo[i].status == DailyTasks.completed) {
        count++;
      }
    }
    completedTodoCount = count;
    notifyListeners();
  }

  Future<void> getPandingCount() async {
    final allTodo = await isarDB.todos.where().findAll();
    int count = 0;
    for (int i = 0; i < allTodo.length; i++) {
      if (allTodo[i].status == DailyTasks.pending) {
        count++;
      }
    }
    pandingTodoCount = count;
    notifyListeners();
  }

  Future<void> getTodo() async {
    log("getting");
    final allTodo = await isarDB.todos.where().findAll();
    todos = [];
    if (dailyTask == DailyTasks.all) {
      todos = allTodo;
    } else if (dailyTask == DailyTasks.pending) {
      for (int i = 0; i < allTodo.length; i++) {
        if (allTodo[i].status == DailyTasks.pending) {
          todos.add(allTodo[i]);
        }
      }
    } else {
      for (int i = 0; i < allTodo.length; i++) {
        if (allTodo[i].status == DailyTasks.completed) {
          todos.add(allTodo[i]);
        }
      }
    }
    notifyListeners();
  }

  Future<void> deleteTodo(int id, BuildContext context) async {
    await isarDB.writeTxn(() async {
      final success = await isarDB.todos.delete(id);
      Navigator.pop(context);
      if (success) {
        susalert(context, "Done", "Todo has been deleted.");
      } else {
        erroralert(context, "Error", "Somethign want wrong unable to delete.");
      }
    });
    notifyListeners();
  }

  Future<void> completeTodo(int id, BuildContext context) async {
    await isarDB.writeTxn(() async {
      final todo = await isarDB.todos.get(id);
      if (todo == null) {
        Navigator.pop(context);
        notifyListeners();
        return erroralert(context, "Error", "Unble to find todo.");
      }

      todo.status = DailyTasks.completed;
      final res = await isarDB.todos.put(todo);

      Navigator.pop(context);
      notifyListeners();

      if (res == 1) {
        erroralert(context, "Error", "Somethign want wrong unable to update.");
      } else {
        susalert(context, "Done", "Todo has been updated.");
      }
    });

    await getTodo();
    notifyListeners();
  }
}
