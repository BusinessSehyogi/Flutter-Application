// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:business_sehyogi/Founder/edit_profile_page.dart';
import 'package:business_sehyogi/Founder/settings_page.dart';
import 'package:business_sehyogi/SharePreferences/saveSharePreferences.dart';
import 'package:business_sehyogi/ipAddress.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FounderProfilePage extends StatefulWidget {
  const FounderProfilePage({super.key});

  @override
  State<FounderProfilePage> createState() => _FounderProfilePageState();
}

class _FounderProfilePageState extends State<FounderProfilePage> {
  var responseData;
  var responsePostData;
  late Future<void> getUsersData;

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  Future<void> getUsersPosts(int userId) async {
    var postURL = "http://$IP/getPostsForFounder/$userId";
    final response = await http.get(Uri.parse(postURL));
    responsePostData = jsonDecode(response.body);
    // print(responsePostData);
  }

  Future<void> getUserDetails() async {
    var userEmail = await getData("Email");
    var userURL = "http://$IP/getUser/$userEmail";
    var response = await http.get(Uri.parse(userURL));
    responseData = jsonDecode(response.body);
    await getUsersPosts(responseData["userId"]);
    // print(responseData);
  }

  @override
  Widget build(BuildContext context) {
    getUsersData = getUserDetails();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3A4183),
        automaticallyImplyLeading: false,
        title: FutureBuilder<void>(
          future: getUsersData, // Use the future initialized in initState
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return Text(
                "${responseData["firstName"]} ${responseData["lastName"]}",
                style: const TextStyle(color: Colors.white),
              );
            } else {
              return const Text(
                "Error",
                style: TextStyle(color: Colors.white),
              );
            }
          },
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FounderSettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: getUsersData, // Use the future initialized in initState
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (responseData.isEmpty) {
              return const Center(child: Text("No posts available"));
            } else {
              var imagePath = "";
              if (responseData["photo"] == null) {
                imagePath =
                    'https://firebasestorage.googleapis.com/v0/b/arogyasair-157e8.appspot.com/o/UserImage%2FDefaultProfileImage.png?alt=media';
              } else {
                imagePath =
                    "https://firebasestorage.googleapis.com/v0/b/business-sehyogi.appspot.com/o/userProfileImages%2F${responseData["photo"]}?alt=media";
              }
              return Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 0.405,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.009,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            imagePath,
                            height: MediaQuery.of(context).size.height * 0.17,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.005,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 22),
                          child: Text(
                            "${responseData["firstName"]} ${responseData["lastName"]}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.005,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.09,
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        responseData["noOfIdeas"].toString(),
                                      ),
                                      const Text("Ideas"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.09,
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        responseData["noOfConnections"]
                                            .toString(),
                                      ),
                                      const Text("Connections"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height *
                              0.0925, // Adjust height as needed
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        Colors.grey.withOpacity(0.5),
                                    // Background color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20), // Rounded corners
                                    ),
                                    padding:
                                        const EdgeInsets.all(10), // Padding
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FounderEditProfilePage(responseData["email"]),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.edit,
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                        ),
                                        const Text(
                                          "Edit Profile",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // second half part
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 0.4077,
                    child: Container(
                      color: Colors.transparent,
                      child: ListView.builder(
                        itemCount: responsePostData.length,
                        itemBuilder: (context, index) {
                          final post = responsePostData[index];
                          var imagePath = "";
                          if (post["image"] != null) {
                            var imageName = post["images"]['photo'] == null
                                ? null
                                : "userProfileImages%2F${post["user"]['photo']}";
                            imagePath = post["user"]['photo'] == null
                                ? 'https://firebasestorage.googleapis.com/v0/b/arogyasair-157e8.appspot.com/o/UserImage%2FDefaultProfileImage.png?alt=media'
                                : "https://firebasestorage.googleapis.com/v0/b/business-sehyogi.appspot.com/o/$imageName?alt=media";
                          }

                          var userImageName = post["user"]['photo'] == null
                              ? null
                              : "userProfileImages%2F${post["user"]['photo']}";
                          var userImagePath = post["user"]['photo'] == null
                              ? 'https://firebasestorage.googleapis.com/v0/b/arogyasair-157e8.appspot.com/o/UserImage%2FDefaultProfileImage.png?alt=media'
                              : "https://firebasestorage.googleapis.com/v0/b/business-sehyogi.appspot.com/o/$userImageName?alt=media";
                          var comments = 0;
                          if (post['noOfComments'] != null) {
                            comments = post['noOfComments'];
                          }
                          return Card(
                            color: Colors.white,
                            margin: const EdgeInsets.all(10.0),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        child: Image.network(
                                          userImagePath,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        "${post["user"]['firstName']} ${post["user"]['lastName']}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  if (imagePath != "")
                                    Image.network(
                                      imagePath,
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  const SizedBox(height: 10),
                                  Text(post['abstractContent'],
                                      style: const TextStyle(fontSize: 14)),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.favorite,
                                                color: Colors.red),
                                            onPressed: () => {},
                                          ),
                                          Text('${post['noOfLikes']}'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (kDebugMode) {
                                                print("Tapped");
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                const Icon(Icons.comment),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.02,
                                                ),
                                                Text('$comments comments'),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              );
            }
          } else {
            return const Center(child: Text("Something went wrong"));
          }
        },
      ),
    );
  }
}
