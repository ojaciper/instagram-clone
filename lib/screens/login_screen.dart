import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/resources/auth_method.dart';
import 'package:instagram_clone/screens/sign_up_screen.dart';
import 'package:instagram_clone/utils/color.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthMethods _authMethods = AuthMethods();

  bool isLoading = false;

  loginUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await _authMethods.loginUser(
      context: context,
      email: emailController.text,
      password: passwordController.text,
    );

    if (res == 'success') {
    } else {
      snackBar(context, res);
    }
    setState(() {
      isLoading = false;
    });
  }

  void navigateToSignUp() {
    Navigator.pushReplacementNamed(context, SignUpScreen.routeName);
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(flex: 1, child: Container()),
              // svg image
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
                height: 64,
              ),
              const SizedBox(height: 64),

              // Email address input
              TextFieldInput(
                textEditingController: emailController,
                isPass: false,
                hintText: "Email",
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              // TextField input for password
              TextFieldInput(
                textEditingController: passwordController,
                isPass: true,
                hintText: "Password",
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 24),
              // login button
              InkWell(
                onTap: loginUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    color: blueColor,
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: primaryColor,
                        )
                      : const Text('Log In'),
                ),
              ),
              const SizedBox(height: 12),

              Flexible(flex: 2, child: Container()),
              // Transitioning to signing up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      "Don't have an account ",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  GestureDetector(
                    onTap: navigateToSignUp,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        "Register here ",
                        style: TextStyle(
                            color: blueColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
