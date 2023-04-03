import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../states/navigationstate.dart';
import '../themes/colors.dart';
import '../utils/enums.dart';

class BoottomNavBar extends HookConsumerWidget {
  final Widget childElement;

  const BoottomNavBar({super.key, required this.childElement});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navbarStateW = ref.watch(navbarState);
    return Scaffold(
      backgroundColor: const Color(0xff212037),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 15,
          ),
          Container(
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: const BoxDecoration(
                color: Color(0xff212037),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                ),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {},
                    child: const Icon(
                      Icons.sort,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "analog-sombra",
                        textScaleFactor: 1,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Icon(
                      Icons.settings,
                      size: 30,
                      color: whiteColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                child: childElement),
          ),
          Container(
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: const BoxDecoration(
                color: Color(0xff212037),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BottomNavTab(
                    isActive: navbarStateW.bottomNav == BottomNavigation.daily,
                    icon: Icons.task,
                    color: indigoColor,
                    function: () {
                      navbarStateW.changePage(BottomNavigation.daily);
                      context.go("/daily");
                    },
                  ),
                  BottomNavTab(
                    isActive: navbarStateW.bottomNav == BottomNavigation.years,
                    icon: Icons.watch_later_outlined,
                    color: cyanColor,
                    function: () {
                      navbarStateW.changePage(BottomNavigation.years);
                      context.go("/years");
                    },
                  ),
                  BottomNavTab(
                    isActive: navbarStateW.bottomNav == BottomNavigation.study,
                    icon: Icons.bolt,
                    color: yellowColor,
                    function: () {
                      navbarStateW.changePage(BottomNavigation.study);
                      context.go("/study");
                    },
                  ),
                  BottomNavTab(
                    isActive: navbarStateW.bottomNav == BottomNavigation.notes,
                    icon: Icons.notes,
                    color: roseColor,
                    function: () {
                      navbarStateW.changePage(BottomNavigation.notes);
                      context.go("/notes");
                    },
                  ),
                  BottomNavTab(
                    isActive: navbarStateW.bottomNav == BottomNavigation.books,
                    icon: Icons.book,
                    color: emeraldColor,
                    function: () {
                      navbarStateW.changePage(BottomNavigation.books);
                      context.go("/books");
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BottomNavTab extends HookConsumerWidget {
  final bool isActive;
  final Color color;
  final IconData icon;
  final Function function;

  const BottomNavTab({
    super.key,
    required this.icon,
    required this.color,
    required this.isActive,
    required this.function,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => function(),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 6),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: isActive ? color : Colors.transparent,
                borderRadius: BorderRadius.circular(10)),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(
                icon,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
