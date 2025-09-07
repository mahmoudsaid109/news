import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/features/home/presentation/controllers/cubit/home_cubit.dart';
import 'package:news/features/home/presentation/controllers/cubit/home_state.dart';

import '../../../../core/utils/component.dart';
import '../../../modules/search/search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsState>(
      listener: (context, state) {
        if (state is NewsErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        var cubit = NewsCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text('News App'),
            actions: [
              IconButton(
                onPressed: () {
                  navigateTo(context, SearchScreen());
                },
                icon: const Icon(Icons.search_outlined),
              ),
              IconButton(
                onPressed: () {
                  NewsCubit.get(context).changeMode();
                  cubit.getBusiness();
                },
                icon: const Icon(Icons.brightness_4_outlined),
              ),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottomNavBar(index);
              if (index == 0) {
                cubit.getBusiness();
              } else if (index == 1) {
                cubit.getBusiness();
              } else if (index == 2) {
                cubit.getBusiness();
              } else {
                cubit.getBusiness();
              }
            },
            items: cubit.bottomItems,
          ),
        );
      },
    );
  }
}
