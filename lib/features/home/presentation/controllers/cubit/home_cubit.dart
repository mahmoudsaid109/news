// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/features/home/data/cach_helper.dart';
import 'package:news/features/home/data/remote_helper.dart';
import 'package:news/features/home/presentation/controllers/cubit/home_state.dart';
import 'package:news/features/modules/sciences/views/science_screen.dart';
import 'package:news/features/modules/sports/views/sports_screen.dart';
import '../../../../modules/bussiness/views/business_screen.dart'
    show BusinessScreen;
import 'package:dio/dio.dart'; // Added for DioException

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(InitialNewsState());
  static NewsCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Business'),
    BottomNavigationBarItem(icon: Icon(Icons.sports_football), label: 'Sports'),
    BottomNavigationBarItem(icon: Icon(Icons.science), label: 'Science'),
  ];

  List<Widget> screens = [BusinessScreen(), SportsScreen(), ScienceScreen()];

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

  bool isDark = false;
  void changeMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(AppChangeModeState());
    } else {
      isDark = !isDark;
      CacheHelper.putBoolean(key: 'isDark', value: isDark)
          .then((_) {
            emit(AppChangeModeState());
          })
          .catchError((error) {
            emit(NewsErrorState('Failed to save theme preference: $error'));
          });
    }
  }

  List<Map<String, dynamic>> search = []; // Changed to typed list
  void getSearch({required String value}) async {
    // Input validation
    if (value.trim().isEmpty) {
      emit(NewsGetSearchErrorState('Search query cannot be empty'));
      return;
    }

    emit(NewsGetSearchLoadingState());
    final sanitizedValue = Uri.encodeQueryComponent(value.trim());

    try {
      final response = await DioHelper.getData(
        url:
            'https://newsapi.org/v2/everything?q=$sanitizedValue&apiKey=68b1db703dc44c468771fe9ebf3ba7bc',
      );
      final data = response.data as Map<String, dynamic>?;

      if (data == null) {
        debugPrint('API Error: Response data is null');
        emit(NewsGetSearchErrorState('Invalid response from server'));
        return;
      }

      if (data['status'] == 'ok' && data['articles'] != null) {
        search = List<Map<String, dynamic>>.from(data['articles']);
        debugPrint(search.isNotEmpty ? 'First article title: ${search[0]['title']}' : 'No articles found');
        emit(NewsGetSearchSuccessState(search)); // Pass search results to state
      } else {
        final errorMessage = data['message'] as String? ?? 'Unknown API error';
        debugPrint('API Error: $errorMessage');
        emit(NewsGetSearchErrorState(errorMessage));
      }
    } catch (error) {
      final errorMessage = error is DioException
          ? 'Network error: ${error.message ?? error.toString()}'
          : 'Error fetching search results: $error';
      debugPrint(errorMessage);
      emit(NewsGetSearchErrorState(errorMessage));
    }
  }
}