import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  double? deviceHeight, deviceWidth;
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  File? image;

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
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                titleWidget(),
                profileImageWidget(),
                registrationForm(),
                registerButton(),
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

  Widget registrationForm() {
    return SizedBox(
      height: deviceHeight! * 0.30,
      child: Form(
        key: registerFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            nameTextField(),
            emailTextField(),
            passwordTextField(),
          ],
        ),
      ),
    );
  }

  Widget profileImageWidget() {
    var imageProvider = image != null
        ? FileImage(image!)
        : const NetworkImage("https://i.pravatar.cc/300");
    return GestureDetector(
      onTap: () {
        FilePicker.platform.pickFiles(type: FileType.image).then(
          (result) {
            setState(() {
              image = File(result!.files.first.path!);
            });
          },
        );
      },
      child: Container(
        height: deviceHeight! * 0.15,
        width: deviceHeight! * 0.15,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: imageProvider as ImageProvider,
          ),
        ),
      ),
    );
  }

  Widget nameTextField() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '*Name is required';
        }
      },
      controller: name,
      decoration: const InputDecoration(
        hintText: 'Name',
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

  Widget registerButton() {
    return MaterialButton(
      onPressed: registerUser,
      color: Colors.red,
      minWidth: deviceWidth! * 0.70,
      height: deviceHeight! * 0.06,
      child: const Text(
        'Register',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void registerUser() {
    if (registerFormKey.currentState!.validate() && image != null) {
      registerFormKey.currentState!.save();
    }
  }
}
