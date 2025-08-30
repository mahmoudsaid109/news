abstract class NewsState {}

class InitialNewsState extends NewsState {}
class NewsBottomNavState extends NewsState {}
class NewsGetBusinessLoadingState extends NewsState {}
class NewsGetBusinessSuccessState extends NewsState {}
class NewsGetBusinessErrorState extends NewsState {
  final String error;
  NewsGetBusinessErrorState(this.error);
}
// ... other states for sports and science ...
class AppChangeModeState extends NewsState {}
class NewsErrorState extends NewsState {
  final String error;
  NewsErrorState(this.error);
}