import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/presentation/controllers/cubit/home_cubit.dart';
import '../../../home/presentation/controllers/cubit/home_state.dart';
import '../../bussiness/widgets/article_item.dart';

class ScienceScreen extends StatelessWidget {
  const ScienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsState>(
      listener: (context, state) {},
      builder: (context, state) {
        var list = NewsCubit.get(context).business;
        if (state is NewsGetBusinessLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is NewsGetBusinessSuccessState) {
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) => buildArticleItem(list[index]),
            itemCount: 20,
          );
        } else {
          return Center(child: Text('Something went wrong'));
        }
      },
    );
  }
}
