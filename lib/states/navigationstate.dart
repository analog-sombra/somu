import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../utils/enums.dart';

final navbarState =
    ChangeNotifierProvider.autoDispose<NavbarState>((ref) => NavbarState());

class NavbarState extends ChangeNotifier {
  BottomNavigation bottomNav = BottomNavigation.daily;

  void changePage(BottomNavigation bottomNavigation) {
    bottomNav = bottomNavigation;
    notifyListeners();
  }
}
