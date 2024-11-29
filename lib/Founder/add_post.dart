// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';

import 'package:business_sehyogi/SharePreferences/saveSharePreferences.dart';
import 'package:business_sehyogi/ipAddress.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

class FounderAddPost extends StatefulWidget {
  const FounderAddPost({super.key});

  @override
  State<FounderAddPost> createState() => _FounderAddPostState();
}

class _FounderAddPostState extends State<FounderAddPost> {
  TextEditingController abstractIdeaController = TextEditingController();
  TextEditingController fullIdeaController = TextEditingController();
  TextEditingController linkController = TextEditingController();

  File? _image; // Make _image nullable
  late String fileName;
  bool isWaiting = false;
  var imagePath =
      "https://firebasestorage.googleapis.com/v0/b/business-sehyogi.appspot.com/o/postImages%2Fadd_image-3.png?alt=media";

  final picker = ImagePicker();
  var userKey;
  String? selectedArea;
  List<Map<String, dynamic>> displayAreaMap = []; // Initialize empty list
  bool isLoading = true; // Initially set loading state to true

  @override
  void initState() {
    super.initState();
    getUserKey();
    fetchAreaData(); // Fetch area data on initialization
  }

  // Fetch area data from the API
  Future<void> fetchAreaData() async {
    var areaURL = "http://$IP/getArea"; // API endpoint
    try {
      final response = await http.get(Uri.parse(areaURL));

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        setState(() {
          displayAreaMap = List<Map<String, dynamic>>.from(responseData);
          isLoading = false; // Data fetched successfully, stop loading
        });
      } else {
        setState(() {
          isLoading = false; // Stop loading if there's an error
        });
        if (kDebugMode) {
          print("Error fetching area data: ${response.statusCode}");
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Stop loading in case of an error
      });
      if (kDebugMode) {
        print("Error fetching area data: $e");
      }
    }
  }

  Future<void> getUserKey() async {
    userKey = (await getKey())!; // Assuming this function gets userKey
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF211C40),
        title: const Text(
          "Add new post",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _image != null
                              ? Image.file(
                                  _image!,
                                  alignment: Alignment.center,
                                  height:
                                      MediaQuery.of(context).size.height * 0.33,
                                  width:
                                      MediaQuery.of(context).size.height * 0.33,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  imagePath,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                  height:
                                      MediaQuery.of(context).size.height * 0.33,
                                  width:
                                      MediaQuery.of(context).size.height * 0.33,
                                ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            getImage();
                          },
                          child: const Text("Add image"),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  TextField(
                    controller: abstractIdeaController,
                    maxLength: 150,
                    decoration: const InputDecoration(
                        label: Text("Enter abstract of your idea"),
                        hintText: "Enter abstract of your idea",
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  TextField(
                    controller: fullIdeaController,
                    maxLength: 500,
                    maxLines: 4,
                    decoration: const InputDecoration(
                        label: Text("Enter your full idea"),
                        hintText: "Enter your full idea",
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  TextField(
                    controller: linkController,
                    decoration: const InputDecoration(
                      label: Text("Enter Links related (optional)"),
                      hintText: "Enter Links related (optional)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  // FutureBuilder is no longer required, just wait for the area data
                  isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : DropdownButton<String>(
                          value: selectedArea,
                          hint: const Text("Select Area"),
                          // Show a hint when value is null
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          style: const TextStyle(color: Colors.black),
                          items: [
                            const DropdownMenuItem<String>(
                              value: null,
                              // Set to null to show "Select Area" as the default
                              child: Text("Select Area"),
                            ),
                            ...displayAreaMap.map<DropdownMenuItem<String>>(
                              (Map<String, dynamic> area) {
                                return DropdownMenuItem<String>(
                                  value: area["areaId"].toString(),
                                  // Ensure this matches selectedArea type
                                  child: Text(area["areaName"] ?? "",
                                      style:
                                          const TextStyle(color: Colors.black)),
                                );
                              },
                            ),
                          ],
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedArea =
                                  newValue; // Update the selected area value
                            });
                          },
                          isExpanded: true,
                          underline: Container(
                            height: 1,
                            color: Colors.grey,
                          ),
                          itemHeight: MediaQuery.of(context).size.width * 0.15,
                        ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isWaiting = true;
                      });
                      var addPostURL = "http://$IP/addPost";
                      final response = await http.post(
                        Uri.parse(addPostURL),
                        headers: {"Content-Type": "application/json"},
                        body: jsonEncode({
                          "dateAndTime": "",
                          "abstractContent": abstractIdeaController.text,
                          "content": fullIdeaController.text,
                          "noOfLikes": 0,
                          "noOfInterested": 0,
                          "visible": true,
                          "views": 0,
                          "boostedPost": false,
                          "userId": userKey,
                          "areaId": selectedArea,
                          // Default to areaId 3 if null
                        }),
                      );
                      var postId = jsonDecode(response.body);
                      fileName = "${userKey}_${postId["postId"]}.jpg";
                      if (linkController.text.isNotEmpty) {
                        var addLinkURL = "http://$IP/addLink";
                        await http.post(
                          Uri.parse(addLinkURL),
                          headers: {"Content-Type": "application/json"},
                          body: jsonEncode(
                            {
                              "linkId": 0,
                              "link": linkController.text,
                              "postId": postId,
                            },
                          ),
                        );
                      }
                      if (_image != null) {
                        var addPostImage = "http://$IP/addImage";
                        await http.post(
                          Uri.parse(addPostImage),
                          headers: {"Content-Type": "application/json"},
                          body: jsonEncode(
                            {
                              "imageId": 0,
                              "imageName": fileName,
                              "postId": postId,
                            },
                          ),
                        );
                        Reference firebaseStorageRef = FirebaseStorage.instance
                            .ref()
                            .child("postImages/$fileName");
                        await firebaseStorageRef.putFile(_image!);
                      }
                      Toast.show("Posted..!!",
                          duration: 2,
                          gravity: Toast.bottom,
                          backgroundRadius: 10);
                      setState(() {
                        isWaiting = false;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Upload",
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  )
                ],
              ),
              if (isWaiting)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  // semi-transparent black
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        fileName = "${userKey}_postId";
      }
    });
  }
}
