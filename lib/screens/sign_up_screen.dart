import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_method.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/color.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/signup';
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  Uint8List? _img;
  bool isLoading = false;

  final AuthMethods _authMethods = AuthMethods();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

// Image picker function
  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _img = image;
    });
  }

// signup user function
  void signUpUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await _authMethods.signUpUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _img!,
    );
    if (res == 'success') {
      snackBar(context, 'account created login with your email and password');
    }
    setState(() {
      isLoading = false;
    });
  }

  void navigateToLogin() {
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(flex: 2, child: Container()),
              // Svg image
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
                height: 64,
              ),
              const SizedBox(height: 40),

              // profile image
              Stack(
                children: [
                  _img != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_img!),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(65),
                          child: Image.asset(
                            'assets/placeholder.jpg',
                            width: 120,
                          ),
                        ),
                  Positioned(
                    right: 10,
                    bottom: 0,
                    child: InkWell(
                      onTap: selectImage,
                      child: const Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 40),
              // Email Text Field,

              TextFieldInput(
                textEditingController: _emailController,
                isPass: false,
                hintText: 'Enter your email',
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 24),
              // password Text Field
              TextFieldInput(
                textEditingController: _passwordController,
                isPass: true,
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 24),
              // user name
              TextFieldInput(
                textEditingController: _usernameController,
                isPass: false,
                hintText: 'Enter username',
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 24),
              // bio TextField
              TextFieldInput(
                textEditingController: _bioController,
                isPass: false,
                hintText: 'Enter bio',
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 24,
              ),
              // Sign up button
              InkWell(
                onTap: signUpUser,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.center,
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
                      : const Text("Sign up"),
                ),
              ),

              Flexible(flex: 2, child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      "Already have an account ",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        "login ",
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
