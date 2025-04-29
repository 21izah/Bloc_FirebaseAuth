import 'package:izahs/features/profile/domain/entities/profile_user.dart';

abstract class SearchState {}

// initial state

class SearchInitial extends SearchState {}

// loading state
class SearchLoading extends SearchState {}

// loaded state

class SearchLoaded extends SearchState {
  final List<ProfileUser?> users;
  SearchLoaded(this.users);
}

// error state
class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}
