import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izahs/features/auth/presentation/components/my_button.dart';
import 'package:izahs/features/auth/presentation/components/my_text_fields.dart';
import 'package:izahs/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:izahs/responsive/constrained_scaffold.dart';

import '../cubits/auth_states.dart';

class LoginPage extends StatefulWidget {
  final void Function()? togglePages;
  const LoginPage({super.key, required this.togglePages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final pwController = TextEditingController();

  void login() {
    final String email = emailController.text;
    final String pw = pwController.text;

    final authCubit = context.read<AuthCubit>();

    if (email.isNotEmpty && pw.isNotEmpty) {
      authCubit.login(email, pw);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter both email and password")));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (context, state) {
        // Show loading indicator only during AuthLoading state
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // For all other states, show the normal login UI
        return ConstrainedScaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_open_rounded,
                      size: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Welcome back, you've been missed!",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    MyTextFields(
                        controller: emailController,
                        hintText: 'Email',
                        obsureText: false),
                    SizedBox(
                      height: 10,
                    ),
                    MyTextFields(
                        controller: pwController,
                        hintText: 'Password',
                        obsureText: true),
                    SizedBox(
                      height: 10,
                    ),
                    MyButton(onTap: login, text: 'Login'),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Not a member? ",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        GestureDetector(
                          onTap: widget.togglePages,
                          child: Text(
                            "Register now",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
//   @override
//   Widget build(BuildContext context) {
//     return ConstrainedScaffold(
//       body: SafeArea(
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.lock_open_rounded,
//                   size: 80,
//                   color: Theme.of(context).colorScheme.primary,
//                 ),
//                 SizedBox(
//                   height: 50,
//                 ),
//                 Text(
//                   "Welcome back, you've been missed!",
//                   style: TextStyle(
//                     color: Theme.of(context).colorScheme.primary,
//                     fontSize: 16,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 25,
//                 ),
//                 MyTextFields(
//                     controller: emailController,
//                     hintText: 'Email',
//                     obsureText: false),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 MyTextFields(
//                     controller: pwController,
//                     hintText: 'Password',
//                     obsureText: true),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 MyButton(onTap: login, text: 'Login'),
//                 SizedBox(
//                   height: 50,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Not a member? ",
//                       style: TextStyle(
//                           color: Theme.of(context).colorScheme.primary),
//                     ),
//                     GestureDetector(
//                       onTap: widget.togglePages,
//                       child: Text(
//                         "Register now",
//                         style: TextStyle(
//                             color:
//                                 Theme.of(context).colorScheme.inversePrimary),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
