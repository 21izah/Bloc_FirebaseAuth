import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izahs/features/auth/data/firebase_auth_repo.dart';
import 'package:izahs/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:izahs/features/auth/presentation/cubits/auth_states.dart';
import 'package:izahs/features/auth/presentation/pages/auth_page.dart';
import 'package:izahs/features/home/presentation/pages/home_page.dart';
import 'package:izahs/features/post/data/firebase_post_repo.dart';
import 'package:izahs/features/post/presentation/cubits/post_cubit.dart';
import 'package:izahs/features/profile/data/firebase_profile_repo.dart';
import 'package:izahs/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:izahs/features/search/data/firebase_search_repo.dart';
import 'package:izahs/features/search/presentation/cubits/search_cubit.dart';
import 'package:izahs/features/storage/data/firebase_storage_repo.dart';
import 'package:izahs/themes/theme_cubit.dart';

/* 
APP - Root Level 

-------------------------------------------------------------------------------

Repositories: for the database
  - firebase

Bloc Providers: for state management
  - auth
  - profile
  - post
  - search
  - theme

Check Auth State
  - unauthenticated -> auth page (login/register)
  - authenticated -> hone page 

*/
class MyApp extends StatelessWidget {
  // Repositories
  final firebaseAuthRepo = FirebaseAuthRepo();
  final firebaseProfileRepo = FirebaseProfileRepo();
  final firebaseStorageRepo = FirebaseStorageRepo();
  final firebasePostRepo = FirebasePostRepo();
  final firebaseSearchRepo = FirebaseSearchRepo();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Auth Cubit
        BlocProvider<AuthCubit>(
          create: (context) =>
              AuthCubit(authRepo: firebaseAuthRepo)..checkAuth(),
        ),

        // Profile Cubit
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
            profileRepo: firebaseProfileRepo,
            storageRepo: firebaseStorageRepo,
          ),
        ),

        // Post Cubit
        BlocProvider<PostCubit>(
          create: (context) => PostCubit(
            postRepo: firebasePostRepo,
            storageRepo: firebaseStorageRepo,
          ),
        ),

        // Search Cubit
        BlocProvider<SearchCubit>(
          create: (context) => SearchCubit(searchRepo: firebaseSearchRepo),
        ),

        // Theme Cubit
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, currentTheme) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: currentTheme,
            home: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Unauthenticated) {
                  return const AuthPage();
                }
                if (authState is Authenticated) {
                  return const HomePage();
                }
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
