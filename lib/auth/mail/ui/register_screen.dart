import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:games_app/auth/mail/login/model/user_model.dart';
import 'package:games_app/auth/mail/login/provider/auth_provider.dart';
import 'package:games_app/auth/shared/app_colors.dart';
import 'package:games_app/auth/shared/app_text.dart';
import 'package:games_app/auth/shared/app_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  final fromKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Consumer<AuthProvider>(
          builder: (context, authProvider, widget) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Form(
                      key: fromKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            register,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            userName,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          AppTextField(
                            controller: nameController,
                            hintText: nameFieldHint,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            email,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          AppTextField(
                            controller: emailController,
                            hintText: emailFieldHint,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            password,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          AppTextField(
                            controller: passwordController,
                            obscureText: authProvider.isVisible ? false : true,
                            hintText: passwordFieldHint,
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.remove_red_eye),
                              onPressed: () {
                                authProvider.setPasswordFieldStatus();
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            confirmPassword,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          AppTextField(
                            controller: confirmPasswordController,
                            obscureText: authProvider.isVisible ? false : true,
                            hintText: confirmPassword,
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.remove_red_eye),
                              onPressed: () {
                                authProvider.setPasswordFieldStatus();
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          InkWell(
                            onTap: () {
                              if(fromKey.currentState!.validate()) {
                                registerUser();
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                  color: buttonBackground,
                                  borderRadius: BorderRadius.circular(24)),
                              child: const Text(
                                register,
                                style: TextStyle(color: buttonTextColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    authProvider.isLoading
                        ? const CircularProgressIndicator()
                        : const SizedBox()
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future registerUser() async {
    UserModel user = UserModel(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
    );

    AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);

    await provider.registerUser(user);

    if (mounted && provider.error == null) {
      Navigator.pop(context);
    }
  }
}