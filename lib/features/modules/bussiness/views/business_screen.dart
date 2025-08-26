import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/features/home/presentation/controllers/cubit/home_cubit.dart';
import 'package:news/features/home/presentation/controllers/cubit/home_state.dart';
import 'package:news/features/modules/bussiness/widgets/article_item.dart';

class BusinessScreen extends StatelessWidget {
  const BusinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsState>(
      listener: (context, state) {},
      builder: (context, state) {
        var list =NewsCubit.get(context).business;
        if (state is NewsGetBusinessLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is NewsGetBusinessSuccessState) {
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) => buildArticleItem(list[index]),
            itemCount: list.length,
          );
        } else {
          return Center(child: Text('Something went wrong'));
        }
      },
    );
  }
}
