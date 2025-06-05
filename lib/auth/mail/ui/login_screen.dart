import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:games_app/auth/google/google_login_screen.dart';
import 'package:games_app/auth/google/google_service.dart';
import 'package:games_app/auth/mail/login/model/user_model.dart';
import 'package:games_app/auth/shared/app_colors.dart';
import 'package:games_app/auth/shared/app_text.dart';
import 'package:games_app/auth/shared/app_textfield.dart';
import 'package:games_app/home_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:games_app/auth/mail/login/provider/auth_provider.dart' as local_auth_provider;
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final fromKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();


  @override
  void initState() {
    super.initState();
    _checkIfUserIsSignedIn();
  }

  Future<void> _checkIfUserIsSignedIn() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      Future.delayed(Duration.zero, () {
        if (mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }));
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<local_auth_provider.AuthProvider>(
        builder: (context, authProvider, widget) {
          return Center(
            child: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Spacer(),
                            const Text(
                              login,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              loginText,
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              email,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            AppTextField(
                              controller: emailController,
                              hintText: emailFieldHint,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              password,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            AppTextField(
                              controller: passwordController,
                              obscureText: !authProvider.isVisible,
                              hintText: passwordFieldHint,
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.remove_red_eye),
                                onPressed: () {
                                  authProvider.setPasswordFieldStatus();
                                },
                              ),
                            ),
                            const SizedBox(height: 24),
                            InkWell(
                              onTap: () {
                                loginUser();
                              },
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: buttonBackground,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: const Text(
                                  login,
                                  style: TextStyle(color: buttonTextColor),
                                ),
                              ),
                            ),
                            // const SizedBox(height: 16),
                            // InkWell(
                            //
                            //  // onTap: () async {
                            //     // await FirebaseService().signInWithGoogle();
                            //     // Navigator.push(context, MaterialPageRoute(builder: (context) {
                            //     //   return HomeScreen();
                            //     // }));
                            //   //},
                            //
                            //   onTap: () async {
                            //     final stopwatch = Stopwatch()..start();
                            //     bool isSignedIn = await FirebaseService().signInWithGoogle();
                            //     print("Google Sign-In Duration: ${stopwatch.elapsedMilliseconds} ms");
                            //
                            //     if (isSignedIn && mounted) {
                            //       Future.delayed(Duration.zero, () {
                            //         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                            //           return HomeScreen();
                            //         }));
                            //       });
                            //     }
                            //   },
                            //
                            //   child: Container(
                            //     width: double.infinity,
                            //     alignment: Alignment.center,
                            //     padding: const EdgeInsets.symmetric(vertical: 12),
                            //     decoration: BoxDecoration(
                            //       color: buttonBackground,
                            //       borderRadius: BorderRadius.circular(24),
                            //     ),
                            //     child: const Text(
                            //       'Login with Google',
                            //       style: TextStyle(color: buttonTextColor),
                            //     ),
                            //   ),
                            // ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(noAccount),
                                const SizedBox(width: 4),
                                TextButton(
                                  onPressed: openRegisterUserScreen,
                                  child: const Text(
                                    register,
                                    style: TextStyle(color: textButtonColor),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Positioned(
                          child: authProvider.isLoading
                              ? const CircularProgressIndicator()
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void openRegisterUserScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const RegisterScreen();
    }));
  }

  Future loginUser() async {
    UserModel user = UserModel(
      email: emailController.text,
      password: passwordController.text,
    );

    local_auth_provider.AuthProvider authProvider =
    Provider.of<local_auth_provider.AuthProvider>(context, listen: false);
    bool isExist = await authProvider.isUserExists(user);

    if (isExist && mounted) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return  HomeScreen();
      }));
    }
  }
}
