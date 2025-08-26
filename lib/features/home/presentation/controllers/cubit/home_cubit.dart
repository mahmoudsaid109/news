import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/features/home/presentation/controllers/cubit/home_state.dart';
import 'package:news/features/modules/bussiness/views/business_screen.dart';
import 'package:news/features/modules/sciences/views/science_screen.dart';
import 'package:news/features/modules/sports/views/sports_screen.dart';

import '../../../../modules/settings/views/settings_screen.dart' show SettingsScreen;

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(IntialNewsSate());
  static NewsCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Business'),
    BottomNavigationBarItem(icon: Icon(Icons.sports_football), label: 'Sports'),
    BottomNavigationBarItem(icon: Icon(Icons.science), label: 'Science'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
  ];

  List<Widget> screens = [BusinessScreen(), SportsScreen(), ScienceScreen(), SettingsScreen()];
  void changeBottomNavBar(int index) {
    currentIndex = index;
    emit(NewsBottomNavState());
  }
}
