import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/features/home/data/remote_helper.dart';
import 'package:news/features/home/presentation/controllers/cubit/home_state.dart';

import 'package:news/features/modules/sciences/views/science_screen.dart';
import 'package:news/features/modules/sports/views/sports_screen.dart';
import 'package:news/features/modules/settings/views/settings_screen.dart';

import '../../../../modules/bussiness/views/business_screen.dart'
    show BusinessScreen;

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

  List<Widget> screens = [
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),
    SettingsScreen(),
  ];

  void changeBottomNavBar(int index) {
    currentIndex = index;
    emit(NewsBottomNavState());
  }

  List<dynamic> business = [];
  void getBusiness() {
    emit(NewsGetBusinessLoadingState());
    DioHelper.getData(
          url:
              'https://newsapi.org/v2/everything?q=keyword&apiKey=68b1db703dc44c468771fe9ebf3ba7bc',
          // query: {
          //   'country': 'eg',
          //   'category': 'business',
          //   'apiKey': '68b1db703dc44c468771fe9ebf3ba7bc',
          // },
        )
        .then((value) {
          print('API Response: ${value.data}');
          if (value.data['status'] == 'ok' && value.data['articles'] != null) {
            business = value.data['articles'];
            if (business.isNotEmpty) {
              print('First article title: ${business[0]['title']}');
            } else {
              print('No articles found');
            }
            emit(NewsGetBusinessSuccessState());
          } else {
            final errorMessage = value.data['message'] ?? 'Unknown API error';
            print('API Error: $errorMessage');
            emit(NewsGetBusinessErrorState(errorMessage));
          }
        })
        .catchError((error) {
          print('Error fetching business news: $error');
          emit(NewsGetBusinessErrorState(error.toString()));
        });
  }
}
