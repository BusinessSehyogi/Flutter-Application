import 'dart:convert';

import 'package:business_sehyogi/Common/sign_up.dart';
import 'package:business_sehyogi/Founder/bottom_navigation_bar.dart';
import 'package:business_sehyogi/SharePreferences/saveSharePreferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../ipAddress.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = true;

  // New field to track if the email exists
  bool isEmailValid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF3A4183),
              Color(0xFF10132B),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  "assets/Logo/logo-no-background.png",
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF10132B).withOpacity(0.4),
                        const Color(0xFF3A4183).withOpacity(0.4),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2E376E).withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Login",
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      Form(
                        key: _emailFormKey,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            inputDecorationTheme: const InputDecorationTheme(
                              errorStyle: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter email';
                              }
                              if (!isEmailValid) {
                                return 'User does not exist';
                              }
                              return null;
                            },
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                            ),
                            onChanged: (value) {
                              // Reset email validity on each input change
                              setState(() {
                                isEmailValid = true;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Form(
                        key: _passwordFormKey,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            inputDecorationTheme: const InputDecorationTheme(
                              errorStyle: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          child: TextFormField(
                            controller: passwordController,
                            onTap: () async {
                              // Validate email field when password field is tapped
                              bool emailExists =
                                  await checkEmail(emailController.text);
                              if (!emailExists) {
                                // If email does not exist, show error
                                setState(() {
                                  isEmailValid = false;
                                });
                                // Revalidate email form to show error message
                                _emailFormKey.currentState!.validate();
                              }
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter password';
                              }
                              return null;
                            },
                            obscureText: isPasswordVisible,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: const Color(0xff2a446b),
                                ),
                                onPressed: () {
                                  _togglePasswordVisibility(context);
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (_emailFormKey.currentState!.validate()) {
                            if (_passwordFormKey.currentState!.validate()) {
                              _performLogin(emailController.text,
                                  passwordController.text, context);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3A4183),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 100, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'LOG IN',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.17),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Haven't we met yet? ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'REGISTER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _togglePasswordVisibility(BuildContext context) {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  Future<bool> checkEmail(String email) async {
    var url = "http://$IP/checkEmail/$email";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var status = jsonDecode(response.body);
        return status;
      } else {
        if (kDebugMode) {
          print('Failed to load users: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
    return false;
  }

  void _performLogin(
      String email, String password, BuildContext context) async {
    var url = "http://$IP/login?email=$email&password=$password";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.body == "true") {
        var getUserURL = "http://$IP/getUser/$email";
        final getUserResponse = await http.get(Uri.parse(getUserURL));
        if (getUserResponse.statusCode == 200) {
          var getUserResponseBody = await jsonDecode(getUserResponse.body);
          if (getUserResponseBody["category"] == "Founder") {
            await saveKey(getUserResponseBody["userId"]);
            await saveData("Category",getUserResponseBody["category"]);
            await saveData("Email",getUserResponseBody["email"]);
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FounderBottomNavigationBar(),
              ),
            );
          }
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Problem in Login"),
                  content: const Text(
                      "There is some issue with the login please try again."),
                  actions: [
                    GestureDetector(
                      onTap: () {
                        print("object");
                      },
                      child: const Text("Ok"),
                    )
                  ],
                );
              });
        }
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: const Text("Invalid email or password"),
              content: const Text(
                  "Entered email id or password is incorrect. Please try again."),
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Ok"),
                )
              ],
            );
          },
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }
}
