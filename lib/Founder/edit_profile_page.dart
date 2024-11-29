// ignore_for_file: depend_on_referenced_packages, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:business_sehyogi/SharePreferences/saveSharePreferences.dart';
import 'package:business_sehyogi/ipAddress.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class FounderEditProfilePage extends StatefulWidget {
  final String email;

  const FounderEditProfilePage(this.email, {super.key});

  @override
  State<FounderEditProfilePage> createState() => _FounderEditProfilePageState();
}

class _FounderEditProfilePageState extends State<FounderEditProfilePage> {
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  var responseData;
  late var icon;
  bool isWaiting = false;
  var selectedGender;
  bool isEmailValid = true;
  String? emailError; // To store error message from API
  bool isEmailChanged = false;
  File? _image; // Make _image nullable
  late String fileName;
  bool isImageChanged = false;
  var imagePath = "";

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        fileName = "${responseData["userId"]}.jpg";
      }
      isImageChanged = true;
    });
  }

  Future<void> getUserDetails(String email) async {
    var userEmail = email;
    var userURL = "http://$IP/getUser/$userEmail";
    var response = await http.get(Uri.parse(userURL));
    responseData = jsonDecode(response.body);
    firstNameController.text = responseData["firstName"];
    lastNameController.text = responseData["lastName"];
    if (emailController.text == "") {
      emailController.text = responseData["email"];
    }
    if (responseData["contactNo"] != 0) {
      contactController.text = responseData["contactNo"].toString();
    }
    if (responseData["emailVerified"]) {
      icon = Icons.edit;
    } else {
      icon = Icons.pending;
    }
    if (responseData["gender"] != "U") {
      selectedGender ??= responseData["gender"];
    }
  }

  Future uploadImage() async {
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child("userProfileImages/$fileName");
    firebaseStorageRef.putFile(_image!);
  }

  Future<bool> checkEmail(String email) async {
    var emailCheckURL = 'http://$IP/checkEmail/$email';
    final response = await http.get(Uri.parse(emailCheckURL));
    if (response.body == "false") {
      setState(() {
        emailController.text = newEmailController.text;
        isEmailChanged = true;
      });
      Navigator.pop(context as BuildContext);
      newEmailController.clear();
      return true;
    } else {
      isEmailValid = false;
      _emailFormKey.currentState!.activate();
      newEmailController.clear();
      return false;
    }
  }

  void validateEmail(String email) async {
    if (email.isEmpty) return;

    bool result = await checkEmail(email);
    setState(() {
      isEmailValid = result;
      emailError = result ? null : 'This email is already registered.';
    });

    // Revalidate the form
    _emailFormKey.currentState?.validate();
  }

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController changeEmailOtpController = TextEditingController();
  TextEditingController newEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    getUserDetails(widget.email);
    ToastContext().init(context);
    if(isImageChanges && responseData['photo'] != null){
      imagePath = "https://firebasestorage.googleapis.com/v0/b/business-sehyogi.appspot.com/o/userProfileImages%2F${responseData["photo"]}?alt=media";
    } else {
      imagePath = 'https://firebasestorage.googleapis.com/v0/b/arogyasair-157e8.appspot.com/o/UserImage%2FDefaultProfileImage.png?alt=media';
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit Profile'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                FutureBuilder(
                  future: getUserDetails(widget.email),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      if (responseData != null) {
                        if (responseData["photo"] == null) {
                          imagePath =
                              'https://firebasestorage.googleapis.com/v0/b/arogyasair-157e8.appspot.com/o/UserImage%2FDefaultProfileImage.png?alt=media';
                        } else {
                          imagePath =
                              "https://firebasestorage.googleapis.com/v0/b/business-sehyogi.appspot.com/o/userProfileImages%2F${responseData["photo"]}?alt=media";
                        }
                        return Center(
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: _image != null
                                        ? Image.file(_image!,
                                            alignment: Alignment.center,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15,
                                            fit: BoxFit.cover)
                                        : Image.network(
                                            imagePath,
                                            fit: BoxFit.cover,
                                            alignment: Alignment.center,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15,
                                          ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        getImage();
                                      },
                                      child: const CircleAvatar(
                                        backgroundColor: Color(0xFF211C40),
                                        radius: 18,
                                        child: Icon(
                                          Icons.edit,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.44,
                                    child: TextField(
                                      controller: firstNameController,
                                      decoration: const InputDecoration(
                                        labelText: 'First Name',
                                        hintText: 'Enter your first name',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.44,
                                    child: TextField(
                                      controller: lastNameController,
                                      decoration: const InputDecoration(
                                        labelText: 'Last Name',
                                        hintText: 'Enter your last name',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    isWaiting = true;
                                  });
                                  var emailVerifyOTPURL =
                                      "http://$IP/sendMail/${responseData["userId"]}";
                                  final response = await http
                                      .get(Uri.parse(emailVerifyOTPURL));
                                  setState(() {
                                    isWaiting = false;
                                  });
                                  if (icon == Icons.pending) {
                                    var enteredOtp;
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title:
                                              const Text("Email verification"),
                                          content: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.19,
                                            child: Column(
                                              children: [
                                                const Text(
                                                    "We have sent the OTP on your registered email."
                                                    "\nPlease enter OTP here to verify your email."),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.02,
                                                ),
                                                TextField(
                                                  controller: otpController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: "OTP",
                                                    hintText: "OTP",
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                if (response.body ==
                                                    enteredOtp) {
                                                  setState(() {
                                                    isWaiting = true;
                                                  });
                                                  var emailVerificationURL =
                                                      "http://$IP/verifyEmail/${responseData["userId"]}";
                                                  await http.get(Uri.parse(
                                                      emailVerificationURL));
                                                  setState(() {
                                                    isWaiting = false;
                                                    getUserDetails(
                                                        widget.email);
                                                  });
                                                }
                                                otpController.clear();
                                              },
                                              child: const Text("Verify"),
                                            )
                                          ],
                                        );
                                      },
                                      barrierDismissible: false,
                                    );
                                  }
                                  if (icon == Icons.edit) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Email change"),
                                          content: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.19,
                                            child: Column(
                                              children: [
                                                const Text(
                                                    "We have sent the OTP on your registered email."
                                                    "\nPlease enter OTP here to verify your email."),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.02,
                                                ),
                                                TextField(
                                                  controller:
                                                      changeEmailOtpController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: "OTP",
                                                    hintText: "OTP",
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () {
                                                var enteredOTP =
                                                    changeEmailOtpController
                                                        .text;
                                                setState(() {
                                                  isWaiting = true;
                                                });
                                                if (response.body ==
                                                    enteredOTP) {
                                                  setState(() {
                                                    changeEmailOtpController
                                                        .clear();
                                                    Navigator.pop(context);
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              "Enter new email"),
                                                          content: Form(
                                                            key: _emailFormKey,
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  newEmailController,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .emailAddress,
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    "New email",
                                                                hintText:
                                                                    "New Email",
                                                                border:
                                                                    const OutlineInputBorder(),
                                                                errorText:
                                                                    emailError, // Show error from API
                                                              ),
                                                              validator:
                                                                  (value) {
                                                                if (value!
                                                                    .isEmpty) {
                                                                  return 'Please enter email';
                                                                }
                                                                if (!isEmailValid) {
                                                                  return 'This email is already registered with us. Please try another email.';
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                          ),
                                                          actions: [
                                                            ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                validateEmail(
                                                                    newEmailController
                                                                        .text);
                                                                if (emailError ==
                                                                    null) {
                                                                  setState(() {
                                                                    emailController
                                                                            .text =
                                                                        newEmailController
                                                                            .text;
                                                                  });
                                                                }
                                                              },
                                                              child: const Text(
                                                                  "Add new email"),
                                                            )
                                                          ],
                                                        );
                                                      },
                                                      barrierDismissible: false,
                                                    );
                                                  });
                                                }
                                                setState(() {
                                                  changeEmailOtpController
                                                      .clear();
                                                  isWaiting = false;
                                                });
                                              },
                                              child: const Text("Verify"),
                                            )
                                          ],
                                        );
                                      },
                                      barrierDismissible: false,
                                    );
                                  }
                                },
                                child: AbsorbPointer(
                                  absorbing: true,
                                  // Disables text field interaction
                                  child: TextFormField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      hintText: "Email",
                                      suffixIcon: Icon(icon),
                                      // Use any icon you need
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: contactController,
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                decoration: const InputDecoration(
                                  labelText: 'Contact',
                                  hintText: 'Enter your contact number',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.all(0),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Gender:',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Radio(
                                      value: "M",
                                      groupValue: selectedGender,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedGender = value;
                                        });
                                      },
                                    ),
                                    const Text(
                                      'Male',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Radio(
                                      value: "F",
                                      groupValue: selectedGender,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedGender = value;
                                        });
                                      },
                                    ),
                                    const Text(
                                      'Female',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () async {
                                  if (isImageChanged) {
                                    uploadImage();
                                  }
                                  if (isEmailChanged) {
                                    var emailUpdateURL =
                                        "http://$IP/updateEmail/${responseData["userId"]}";
                                    await http.post(Uri.parse(emailUpdateURL),
                                        body: emailController.text);
                                  }

                                  saveData("Email", emailController.text);
                                  var profileUpdateURL =
                                      "http://$IP/updateUser/${responseData["userId"]}";
                                  await http.post(Uri.parse(profileUpdateURL),
                                      headers: {
                                        "Content-Type": "application/json"
                                      },
                                      body: jsonEncode({
                                        "userId": "0",
                                        "firstName": firstNameController.text,
                                        "lastName": lastNameController.text,
                                        "email": emailController.text,
                                        "password": "",
                                        "gender": "M",
                                        "contactNo": contactController.text,
                                        "category": "Investor",
                                        "photo": "",
                                        "visible": "true",
                                        "emailVerified": "true",
                                        "contactNoVerified": "true",
                                        "dateTimeOfRegistration": "",
                                        "dateOfBirth": ""
                                      }));
                                  getUserDetails(emailController.text);
                                  Toast.show("Profile Updated successfully..!!", duration: 2, gravity: Toast.bottom, backgroundRadius: 10);
                                  isImageChanges = true;
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF211C40),
                                ),
                                child: const Text(
                                  'SAVE',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    } else {
                      return const Center(
                        child: Text("Something went wrong...!!"),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          if (isWaiting)
            Container(
              color: Colors.black.withOpacity(0.5), // semi-transparent black
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
