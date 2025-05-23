import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izahs/features/profile/presentation/component/user_tile.dart';
import 'package:izahs/features/search/presentation/cubits/search_cubit.dart';
import 'package:izahs/responsive/constrained_scaffold.dart';

import '../cubits/search_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  late final searchCubit = context.read<SearchCubit>();

  void onSearchChanged() {
    final query = searchController.text;
    searchCubit.searchUsers(query);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: "Search users..",
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          // loaded
          if (state is SearchLoaded) {
            // no users..
            if (state.users.isEmpty) {
              return const Center(
                child: Text("No users found"),
              );
            }

            // users
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return UserTile(user: user!);
              },
            );
          }

          // loading
          else if (state is SearchLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // error ...
          else if (state is SearchError) {
            return Center(
              child: Text(state.message),
            );
          }

          // default
          return Center(
            child: Text("Start searching for users"),
          );
        },
      ),
    );
  }
}
