import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../global_widgets/input_text_feild.dart';
import '../global_widgets/new_button.dart';
import '../providers/user_provider.dart';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: Get.height,
        width: Get.width,
        color: Color(0xffeeeeee),
        padding: EdgeInsets.all(20),
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) => userProvider.isLoading
              ? Center(
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.transparent,
                      color: Color.fromARGB(255, 255, 96, 96),
                      strokeWidth: 3,
                    ),
                  ),
                )
              : Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // SizedBox(height: 210),
                        // InputTextFormField(
                        //   tController: emailController,
                        //   hintText: 'Email',
                        //   obscureText: false,
                        //   validator: (value) {
                        //     if (value!.isEmpty) {
                        //       return 'Please enter your name';
                        //     }
                        //     return null;
                        //   },
                        // ),
                        // InputTextFormField(
                        //   tController: passwordController,
                        //   hintText: 'Password',
                        //   obscureText: true,
                        //   validator: (value) {
                        //     if (value!.isEmpty) {
                        //       return 'Please enter a password';
                        //     } else if (value.length < 8) {
                        //       return 'Password must be at least 8 characters';
                        //     }
                        //     return null;
                        //   },
                        // ),
                        // InputTextFormField(
                        //   hintText: 'Confirm Password',
                        //   obscureText: true,
                        //   validator: (value) {
                        //     if (value! != passwordController.text) {
                        //       return 'Retype same password';
                        //     }
                        //     return null;
                        //   },
                        // ),
                        // SizedBox(height: 20),
                        // NewButton(
                        //   height: 44,
                        //   width: Get.width * 0.9,
                        //   borderRadius: 10,
                        //   color: Colors.amber,
                        //   child: Text(
                        //     'Sign Up',
                        //     style: TextStyle(
                        //       color: Colors.black,
                        //       fontSize: 15,
                        //     ),
                        //   ),
                        //   onPressed: () {
                        //     if (_formKey.currentState!.validate()) {}
                        //     userProvider.userSignUp(
                        //       emailController.text,
                        //       passwordController.text,
                        //     );
                        //   },
                        // ),
                        NewButton(
                          height: 44,
                          width: Get.width * 0.9,
                          borderRadius: 10,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset('assets/icons/google.png'),
                                SizedBox(width: 10),
                                Text(
                                  'Sign in with Google',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onPressed: () async {
                            await userProvider.userSignInWithGoogle();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
