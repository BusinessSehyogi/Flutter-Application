import 'dart:convert';

import 'package:business_sehyogi/Common/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../ipAddress.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 80),
              // "Sign up" Text rotated
              const Row(
                children: [
                  RotatedBox(
                    quarterTurns: -1,
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "A platform where\nyour idea gets\nin reality",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Name input field
              // SizedBox(
              //   width: MediaQuery.of(context).size.width * 0.9,
              //   child: Row(
              //     children: [
              //       const TextField(
              //         decoration: InputDecoration(
              //           labelText: "Name",
              //           labelStyle: TextStyle(color: Colors.white),
              //           enabledBorder: UnderlineInputBorder(
              //             borderSide: BorderSide(color: Colors.white),
              //           ),
              //           focusedBorder: UnderlineInputBorder(
              //             borderSide: BorderSide(color: Colors.white),
              //           ),
              //         ),
              //         style: TextStyle(color: Colors.white),
              //       ),
              //       // const TextField(
              //       //   decoration: InputDecoration(
              //       //     labelText: "Name",
              //       //     labelStyle: TextStyle(color: Colors.white),
              //       //     enabledBorder: UnderlineInputBorder(
              //       //       borderSide: BorderSide(color: Colors.white),
              //       //     ),
              //       //     focusedBorder: UnderlineInputBorder(
              //       //       borderSide: BorderSide(color: Colors.white),
              //       //     ),
              //       //   ),
              //       //   style: TextStyle(color: Colors.white),
              //       // ),
              //     ],
              //   ),
              // ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        labelText: "First name",
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.1,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        labelText: "Last name",
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Email input field
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
                      return 'User already exist';
                    }
                    return null;
                  },
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    // Reset email validity on each input change
                    setState(() {
                      isEmailValid = true;
                    });
                  },
                ),
              ),
            ),
              const SizedBox(height: 20),
              // Password input field
              TextField(
                onTap: () async {
                  // Validate email field when password field is tapped
                  bool emailExists = await checkEmail(emailController.text);
                  if (emailExists) {
                    // If email does not exist, show error
                    setState(() {
                      isEmailValid = false;
                    });
                    // Revalidate email form to show error message
                    _emailFormKey.currentState!.validate();
                  }
                },
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: const TextStyle(color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _togglePasswordVisibility(context);
                    },
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                obscureText: isPasswordVisible,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: "Confirm passwords",
                  labelStyle: const TextStyle(color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isConfirmPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _toggleConfirmPasswordVisibility(context);
                    },
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                obscureText: isConfirmPasswordVisible,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 40),
              // OK Button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () async {
                    {
                      print("API call started");
                      var registrationURL = "http://$IP/registerUser";
                      await http.post(Uri.parse(registrationURL),
                          headers: {"Content-Type": "application/json"},
                          body: jsonEncode({
                            "userId": 0,
                            "firstName": firstNameController.text,
                            "lastName": lastNameController.text,
                            "email": emailController.text,
                            "password": passwordController.text,
                            "contactNo": 0,
                            "category": "Founder",
                            "visible": true,
                            "gender" : "U",
                            "emailVerified" : false,
                            "contactnoVerified" : false,
                            "noOfIndeas": 0,
                            "noOfConnections": 0
                          }));
                      print("API call finished");
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Sign up",
                        style: TextStyle(color: Colors.blue),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              // Bottom text for Sign in
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Have we met before? ",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Sign in",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
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
  void _toggleConfirmPasswordVisibility(BuildContext context) {
    setState(() {
      isConfirmPasswordVisible = !isConfirmPasswordVisible;
    });
  }

  Future<bool> checkEmail(String email) async {
    print("email check called");
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

}
