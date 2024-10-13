import 'package:finstagram/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double? deviceHeight, deviceWidth;
  FirebaseService? firebaseService;
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
    firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: deviceWidth! * 0.05),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                titleWidget(),
                loginForm(),
                loginButton(),
                registerPageLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget titleWidget() {
    return const Text(
      'Finstagram',
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget loginButton() {
    return MaterialButton(
      onPressed: loginUser,
      minWidth: deviceWidth! * 0.70,
      height: deviceHeight! * 0.06,
      color: Colors.red,
      child: const Text(
        'Login',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget loginForm() {
    return SizedBox(
      height: deviceHeight! * 0.20,
      child: Form(
        key: loginFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            emailTextField(),
            passwordTextField(),
          ],
        ),
      ),
    );
  }

  Widget emailTextField() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '*Email is required';
        }
      },
      decoration: const InputDecoration(
        hintText: 'Email',
      ),
      controller: email,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget passwordTextField() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '*Password is required';
        }
      },
      decoration: const InputDecoration(
        hintText: 'Password',
      ),
      controller: password,
      obscureText: true,
    );
  }

  Widget registerPageLink() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'register');
      },
      child: const Text(
        'Don\'t have an account? Register here!',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }

  void loginUser() async {
    if (loginFormKey.currentState!.validate()) {
      loginFormKey.currentState!.save();
      bool result = await firebaseService!.loginUser(
        email: email.text,
        password: password.text,
      );
      if (result) {
        Navigator.popAndPushNamed(context, 'home');
      }
    }
  }
}
