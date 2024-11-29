// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:business_sehyogi/Founder/user_profile_info.dart';
import 'package:business_sehyogi/SharePreferences/saveSharePreferences.dart';
import 'package:business_sehyogi/ipAddress.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FounderHomePage extends StatefulWidget {
  const FounderHomePage({super.key});

  @override
  State<FounderHomePage> createState() => _FounderHomePageState();
}

class _FounderHomePageState extends State<FounderHomePage> {
  Map<int, dynamic> homePagePost = {};
  late int userKey;
  int totProud = 50;
  int page = 0;
  late Future<void> getHomePost;
  ScrollController scrollController = ScrollController();
  bool isCommentVisible = false;
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserKey();
    scrollController.addListener(loadMoreData);
  }

  Future<void> getUserKey() async {
    userKey = (await getKey())!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getHomePost = _fetchHomePagePosts();
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 1.5,
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
              future: getHomePost,
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
                            controller: scrollController,
                            itemCount: homePagePost.length,
                            itemBuilder: (context, index) {
                              final post = homePagePost[index];

                              var imagePath = "";

                              // print(homePagePost);

                              // print(post["images"] == null);
                              // print(post['images']);

                              // if(post["images"].isNotEmpty){
                              //   imagePath = "https://firebasestorage.googleapis.com/v0/b/business-sehyogi.appspot.com/o/userProfileImages%2F${post["images"]['photo']}?alt=media";
                              // }

                              // var imagePath = post["images"]?['photo'] != null
                              //     ?
                              //     : 'https://firebasestorage.googleapis.com/v0/b/arogyasair-157e8.appspot.com/o/UserImage%2FDefaultProfileImage.png?alt=media';

                              var userImagePath = post["user"]?['photo'] != null
                                  ? "https://firebasestorage.googleapis.com/v0/b/business-sehyogi.appspot.com/o/userProfileImages%2F${post["user"]['photo']}?alt=media"
                                  : 'https://firebasestorage.googleapis.com/v0/b/arogyasair-157e8.appspot.com/o/UserImage%2FDefaultProfileImage.png?alt=media';

                              // Inside your StatefulBuilder for each post
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return Card(
                                    color: Colors.white,
                                    margin: const EdgeInsets.all(10.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Post User Info
                                          Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(50.0),
                                                child: Image.network(
                                                  userImagePath,
                                                  height: MediaQuery.of(context).size.height * 0.04,
                                                  width: MediaQuery.of(context).size.height * 0.04,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          FounderGetUserInfo(post["user"]["email"]),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  "${post["user"]['firstName']} ${post["user"]['lastName']}",
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.bold, fontSize: 16),
                                                ),
                                              ),
                                            ],
                                          ),

                                          // Post Image
                                          const SizedBox(height: 10),
                                          if (imagePath.isNotEmpty)
                                            Image.network(
                                              imagePath,
                                              height: 200,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),

                                          // Post Abstract Content
                                          const SizedBox(height: 10),
                                          Text(
                                            post['abstractContent'],
                                            style: const TextStyle(fontSize: 14),
                                          ),

                                          // Like and Comment Buttons
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      post['liked'] == true
                                                          ? Icons.favorite
                                                          : Icons.favorite_border,
                                                      color: post['liked'] == true ? Colors.red : null,
                                                    ),
                                                    onPressed: () async {
                                                      var likePostURL =
                                                          "http://$IP/addLike/$userKey/${post["postId"]}";
                                                      try {
                                                        final response = await http.post(Uri.parse(likePostURL));
                                                        setState(() {
                                                          post['liked'] = !(post['liked'] ?? false);
                                                          post['noOfLikes'] = post['liked'] == true
                                                              ? (post['noOfLikes'] ?? 0) + 1
                                                              : (post['noOfLikes'] ?? 0) - 1;
                                                        });
                                                      } catch (e) {
                                                        debugPrint('Error toggling like: $e');
                                                      }
                                                    },
                                                  ),
                                                  Text('${post['noOfLikes']}'),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(Icons.comment),
                                                    onPressed: () async {
                                                      // Ensure comments are loaded first
                                                      await _fetchComments(index);
                                                      setState(() {
                                                        post['isCommentVisible'] =
                                                        !(post['isCommentVisible'] ?? false);
                                                      });
                                                    },
                                                  ),
                                                  Text('${post['noOfComments']} comments'),
                                                ],
                                              ),
                                            ],
                                          ),

                                          // Comment Section
                                          if (post['isCommentVisible'] ?? false)
                                            Column(
                                              children: [
                                                ...post['comments']
                                                    .map<Widget>(
                                                      (comment) => ListTile(
                                                    title: Text(
                                                      "${comment['user']['firstName']} ${comment['user']['lastName']}",
                                                    ),
                                                    subtitle: Text(
                                                      "- ${comment['comment'] ?? "Anonymous"}",
                                                    ),
                                                  ),
                                                )
                                                    .toList(),
                                                // Add New Comment Field
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: TextField(
                                                          controller: commentController,
                                                          decoration: const InputDecoration(
                                                            labelText: "Write a comment...",
                                                            border: OutlineInputBorder(),
                                                          ),
                                                          onSubmitted: (value) async {
                                                            if (value.isNotEmpty) {
                                                              // Add comment logic
                                                              var commentPostURL =
                                                                  "http://$IP/addComment/${post["postId"]}";
                                                              try {
                                                                final response = await http.post(
                                                                  Uri.parse(commentPostURL),
                                                                  headers: {"Content-Type": "application/json"},
                                                                  body: jsonEncode({
                                                                    "userKey": userKey,
                                                                    "comment": value,
                                                                  }),
                                                                );
                                                                if (response.statusCode == 200) {
                                                                  setState(() {
                                                                    post['comments'].add({
                                                                      "user": {
                                                                        "firstName": "Your",
                                                                        "lastName": "Name",
                                                                      },
                                                                      "comment": value,
                                                                    });
                                                                    post['noOfComments'] =
                                                                        (post['noOfComments'] ?? 0) + 1;
                                                                  });
                                                                }
                                                              } catch (e) {
                                                                debugPrint("Error adding comment: $e");
                                                              }
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                      IconButton(
                                                        icon: const Icon(Icons.send),
                                                        onPressed: () async {
                                                          if (commentController.text.isNotEmpty) {
                                                            try {
                                                              // Add the comment via API
                                                              var addCommentURL =
                                                                  "http://$IP/addComment/${post['postId']}/$userKey?comment=${commentController.text}";
                                                              final response = await http.post(Uri.parse(addCommentURL));

                                                              if (response.statusCode == 200) {
                                                                // Refresh the comments for the current post
                                                                await _fetchComments(index);

                                                                // Clear the input field and refresh the UI
                                                                setState(() {
                                                                  commentController.clear();
                                                                });
                                                              } else {
                                                                debugPrint("Failed to add comment: ${response.body}");
                                                              }
                                                            } catch (e) {
                                                              debugPrint("Error adding comment: $e");
                                                            }
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
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
    var homePagePostsURL =
        "http://$IP/getPostForHomePage/$userKey?page=$page";
    try {
      final response = await http.get(Uri.parse(homePagePostsURL));
      List<dynamic> responseData = jsonDecode(response.body);
      // print(responseData[0]);

      for (var post in responseData) {
        int postId = post['postId'];
        var likedURL = "http://$IP/getLikesForPost/$userKey/$postId";

        try {
          final likedResponse = await http.get(Uri.parse(likedURL));
          var isLiked = jsonDecode(likedResponse.body);
          post['liked'] = isLiked;
        } catch (e) {
          post['liked'] = false;
        }
        post['comments'] = [];
        post['commentPage'] = 0;
      }

      Map<int, dynamic> newPosts = {
        for (int i = 0; i < responseData.length; i++)
          homePagePost.length + i: responseData[i]
      };

      homePagePost.addAll(newPosts);
    } catch (e) {
      debugPrint("Error fetching posts: $e");
    }
  }

  Future<void> _fetchComments(int postIndex) async {
    var postId = homePagePost[postIndex]["postId"];
    var commentURL = "http://$IP/getCommentForPost/$postId";

    try {
      final response = await http.get(Uri.parse(commentURL));

      if (response.statusCode == 404) {
        debugPrint("Error: Comments not found for post $postId");
        return; // No comments found, do nothing
      }

      if (response.statusCode == 200) {
        // Print response body for debugging
        // print(response.body);

        var responseData = jsonDecode(response.body);

        // Check if the response is a List directly
        if (responseData is List) {
          List<dynamic> comments = responseData;
          setState(() {
            homePagePost[postIndex]['comments'] = comments;
          });
        } else {
          debugPrint("Invalid response format for comments: $responseData");
        }
      } else {
        debugPrint("Error fetching comments: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching comments: $e");
    }
  }


  void loadMoreData() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        page++;
      });
    }
  }
}
