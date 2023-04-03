import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:somu/database/todo.dart';
import 'package:somu/states/dailystate.dart';
import 'package:somu/themes/colors.dart';
import 'package:somu/utils/enums.dart';

import '../../database/database.dart';
import '../../utils/alets.dart';
import '../../utils/string.dart';

class DailyPage extends HookConsumerWidget {
  const DailyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyTaskStateW = ref.watch(dailyState);
    final title = useTextEditingController();
    final description = useTextEditingController();
    ValueNotifier<int> allTodoCount = useState<int>(0);
    ValueNotifier<int> pandingTodoCount = useState<int>(0);
    ValueNotifier<int> completedTodoCount = useState<int>(0);

    Stream<void> todoChanged = isarDB.todos.watchLazy();
    void init() async {
      await dailyTaskStateW.getallTodoCount();
      allTodoCount.value = dailyTaskStateW.allTodoCount;

      await dailyTaskStateW.getPandingCount();
      pandingTodoCount.value = dailyTaskStateW.pandingTodoCount;

      await dailyTaskStateW.getCompletedCount();
      completedTodoCount.value = dailyTaskStateW.completedTodoCount;

      await dailyTaskStateW.getTodo();
    }

    todoChanged.listen((data) async {
      init();
    });

    useEffect(() {
      init();
    }, []);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: roseColor,
        onPressed: () {
          addTodo(context, ref, title, description);
        },
        child: const Icon(
          Icons.add,
          color: whiteColor,
          size: 30,
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              children: [
                DailyTab(
                  isActive: dailyTaskStateW.dailyTask == DailyTasks.all,
                  color: blueColor,
                  title: "ALL",
                  count: allTodoCount.value,
                  icon: Icons.task,
                  function: () async {
                    dailyTaskStateW.changeDailyTask(DailyTasks.all);
                  },
                ),
                DailyTab(
                  isActive: dailyTaskStateW.dailyTask == DailyTasks.completed,
                  color: greenColor,
                  title: "COMPLETED",
                  count: completedTodoCount.value,
                  icon: Icons.task_alt,
                  function: () {
                    dailyTaskStateW.changeDailyTask(DailyTasks.completed);
                  },
                ),
                DailyTab(
                  isActive: dailyTaskStateW.dailyTask == DailyTasks.pending,
                  color: roseColor,
                  title: "PANDING",
                  count: pandingTodoCount.value,
                  icon: Icons.ac_unit,
                  function: () {
                    dailyTaskStateW.changeDailyTask(DailyTasks.pending);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 15, bottom: 15),
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.horizontal(right: Radius.circular(20)),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (dailyTaskStateW.todos.isEmpty) ...[
                        const SizedBox(
                          height: 40,
                        ),
                        const Icon(
                          Icons.error,
                          size: 60,
                          color: roseColor,
                        ),
                        const Center(
                          child: Text(
                            "Nothing to show.",
                            textScaleFactor: 1,
                            style: TextStyle(
                              color: roseColor,
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                      for (int i = 0;
                          i < dailyTaskStateW.todos.length;
                          i++) ...[
                        TaskItem(
                          id: dailyTaskStateW.todos[i].id,
                          title: dailyTaskStateW.todos[i].title,
                          index: i + 1,
                          description: dailyTaskStateW.todos[i].description,
                          taskType: dailyTaskStateW.todos[i].status,
                          date: DateFormat.yMMMMEEEEd()
                              .format(dailyTaskStateW.todos[i].dateTime),
                        ),
                      ],
                      SizedBox(
                        height: 60,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DailyTab extends HookConsumerWidget {
  final bool isActive;
  final Color color;
  final String title;
  final IconData icon;
  final int count;
  final Function function;

  const DailyTab({
    super.key,
    required this.color,
    required this.isActive,
    required this.title,
    required this.count,
    required this.icon,
    required this.function,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    {
      return Expanded(
        child: InkWell(
          onTap: () => function(),
          child: Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
            decoration: BoxDecoration(
              color: isActive ? color : whiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: isActive ? Colors.white : Colors.grey.shade400,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "$title [$count]",
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: isActive ? whiteColor : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

class TaskItem extends HookConsumerWidget {
  final String title;
  final String description;
  final DailyTasks taskType;
  final int index;
  final String date;
  final int id;

  const TaskItem({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.taskType,
    required this.index,
    required this.date,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final dailyTodosStateW = ref.watch(dailyState);

    ValueNotifier<bool> isOpen = useState(false);

    ValueNotifier<Color> color = useState<Color>(blueColor);
    useEffect(() {
      if (taskType == DailyTasks.pending) {
        color.value = yellowColor;
      } else {
        color.value = greenColor;
      }
    });

    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          if (taskType == DailyTasks.completed) ...[
            SlidableAction(
              onPressed: (context) async {
                deleteTodo(context, ref, id);
              },
              backgroundColor: color.value.withOpacity(0.15),
              foregroundColor: roseColor,
              icon: Icons.delete,
              label: "Delete",
            ),
          ] else ...[
            SlidableAction(
              onPressed: (context) async {
                completeTodo(context, ref, id);

                await ref.watch(dailyState).getTodo();
              },
              backgroundColor: color.value.withOpacity(0.15),
              foregroundColor: greenColor,
              icon: Icons.done_all,
              label: "Done",
            ),
          ],
          SlidableAction(
            onPressed: (context) {},
            backgroundColor: color.value.withOpacity(0.15),
            foregroundColor: Colors.cyan,
            icon: Icons.close,
            label: "close",
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          color: color.value.withOpacity(0.15),
          border: Border(
            left: BorderSide(
              color: color.value,
              width: 4,
            ),
          ),
        ),
        width: width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              index.toString(),
              textScaleFactor: 1,
              style: TextStyle(
                color: color.value,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isOpen.value ? title : modidyString(title, num: 30),
                    textScaleFactor: 1,
                    style: TextStyle(
                      color: color.value,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (isOpen.value)
                    Text(
                      date,
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: color.value,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  else
                    const SizedBox(),
                  Text(
                    isOpen.value
                        ? description
                        : modidyString(description, num: 50),
                    textScaleFactor: 1,
                    style: TextStyle(
                      color: color.value,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                isOpen.value = !isOpen.value;
              },
              child: Icon(
                isOpen.value
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down_outlined,
                color: color.value,
                size: 30,
              ),
            )
          ],
        ),
      ),
    );
  }
}
