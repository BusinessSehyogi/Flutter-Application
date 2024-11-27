import 'dart:convert';

import 'package:business_sehyogi/SharePreferences/saveSharePreferences.dart';
import 'package:business_sehyogi/ipAddress.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FounderHomePage extends StatefulWidget {
  const FounderHomePage({super.key});

  @override
  State<FounderHomePage> createState() => _FounderHomePageState();
}

class _FounderHomePageState extends State<FounderHomePage> {
  Map homePagePost = {};
  late int userKey;
  int totProud = 50;
  int page = 0;
  late Future<void> getHomePost;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getUserKey();
    // Initialize the future to fetch the posts
    scrollController.addListener(loadMoreData);
  }

  Future<void> getUserKey() async {
    userKey = (await getKey())!;
    setState(() {

    });
  }

  // Method to handle likes
  void _toggleLike(int index) {
    setState(() {
      homePagePost[index]['liked'] = !homePagePost[index]['liked'];
      homePagePost[index]['likes'] += homePagePost[index]['liked'] ? 1 : -1;
    });
  }

  // Method to handle adding a comment
  void _addComment(int index) {
    setState(() {
      homePagePost[index]['comments'] += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    getHomePost = _fetchHomePagePosts();
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF3A4183),
              automaticallyImplyLeading: false,
              title: const Text(
                "Home page",
                style: TextStyle(color: Colors.white),
              ),
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
            ),
            body: FutureBuilder<void>(
              future: getHomePost, // Use the future initialized in initState
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (homePagePost.isEmpty) {
                    return const Center(child: Text("No posts available"));
                  } else {
                    return Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8127,
                          child: ListView.builder(
                            // padding: EdgeInsets.all(1),
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: scrollController,
                            itemCount: homePagePost.length,
                            itemBuilder: (context, index) {
                              final post = homePagePost[index];
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

                              return Card(
                                color: Colors.white,
                                margin: const EdgeInsets.all(10.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                onPressed: () =>
                                                    _toggleLike(index),
                                              ),
                                              Text('${post['noOfLikes']}'),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.comment),
                                                onPressed: () =>
                                                    _addComment(index),
                                              ),
                                              Text(
                                                  '${post['noOfComments']} comments'),
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
                        )
                      ],
                    );
                  }
                } else {
                  return const Center(child: Text("Something went wrong"));
                }
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _fetchHomePagePosts() async {
    var homePagePostsURL = "http://$IP/getPostForHomePage/$userKey?page=$page&size=15";
    try {
      final response = await http.get(Uri.parse(homePagePostsURL));
      List<dynamic> responseData = jsonDecode(response.body);

      // Create a Map using integer keys (starting from the next available key)
      Map<int, dynamic> newPosts = {
        for (int i = 0; i < responseData.length; i++) homePagePost.length + i: responseData[i]
      };

      // Append new posts to the existing homePagePost map
        homePagePost.addAll(newPosts); // This merges newPosts into homePagePost
      // setState(() {
      // });
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }



  void loadMoreData() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent &&
        homePagePost.length < totProud) {
      setState(() {
        page++;
      });
      _fetchHomePagePosts();
    }
  }
}
