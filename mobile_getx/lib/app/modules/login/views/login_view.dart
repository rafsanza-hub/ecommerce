import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(children: [
          Form(
            key: controller.formKey,
            child: Column(children: [
              TextFormField(
                controller: controller.usernameOrEmailC,
                decoration: InputDecoration(labelText: 'Username or Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username or email';
                  }
                  if (value.length < 3) {
                    return 'Username or email must be at least 3 characters';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: controller.passwordC,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    if (!controller.formKey.currentState!.validate()) return;
                    controller.login();
                  },
                  child: Text('Login')),
            ]),
          )
        ]),
      ),
    );
  }
}
