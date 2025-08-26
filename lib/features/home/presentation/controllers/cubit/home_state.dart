abstract class NewsState {}

class IntialNewsSate extends NewsState {}

class NewsBottomNavState extends NewsState{}

class NewsGetBusinessLoadingState extends NewsState{}

class NewsGetBusinessSuccessState extends NewsState{}

class NewsGetBusinessErrorState extends NewsState{
  final String error;
  NewsGetBusinessErrorState(this.error);
}