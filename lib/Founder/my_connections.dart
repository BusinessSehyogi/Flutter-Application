import 'dart:convert';

import 'package:business_sehyogi/Founder/user_profile_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../SharePreferences/saveSharePreferences.dart';
import '../ipAddress.dart';

class FounderMyConnectionsPage extends StatefulWidget {
  const FounderMyConnectionsPage({super.key});

  @override
  State<FounderMyConnectionsPage> createState() =>
      _FounderMyConnectionsPageState();
}

class _FounderMyConnectionsPageState extends State<FounderMyConnectionsPage> {
  var userKey;
  List<dynamic> userData = []; // Initialize as an empty list

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch initial data
  }

  Future<void> fetchData() async {
    userKey = await getKey(); // Fetch the current user ID
    var getUserURL = "http://$IP/getAllConnection/$userKey";

    try {
      final response = await http.get(Uri.parse(getUserURL));
      // print(response.body[0]);
      if (response.statusCode == 200) {
        setState(() {
          userData = jsonDecode(response.body);
        });
      } else {
        // Handle error
        setState(() {
          userData = [];
        });
      }
    } catch (e) {
      // Handle exception
      setState(() {
        userData = [];
      });
    }
  }

  Future<void> addConnection(int targetUserId) async {
    var connectionURL = "http://$IP/deleteConnection/$targetUserId";

    try {
      final response = await http.delete(Uri.parse(connectionURL));
      if (response.statusCode == 200) {
        // Fetch updated list after connection is added
        await fetchData();
      } else {
        // Handle error
        if (kDebugMode) {
          print("Failed to add connection. Status Code: ${response.statusCode}");
        }
      }
    } catch (e) {
      // Handle exception
      if (kDebugMode) {
        print("Error adding connection: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return userData.isNotEmpty
            ? Scaffold(
                appBar: AppBar(
                  title: const Text("Explore Page"),
                ),
                body: ListView.builder(
                  itemCount: userData.length,
                  itemBuilder: (context, index) {
                    var userImagePath = userData[index]?["coFounderOrInvestorUser"]['photo'] != null
                        ? "https://firebasestorage.googleapis.com/v0/b/business-sehyogi.appspot.com/o/userProfileImages%2F${userData[index]["coFounderOrInvestorUser"]['photo']}?alt=media"
                        : 'https://firebasestorage.googleapis.com/v0/b/arogyasair-157e8.appspot.com/o/UserImage%2FDefaultProfileImage.png?alt=media';
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(7),
                        child: Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50.0),
                                    child: Image.network(
                                      userImagePath,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04,
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.04,
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
                                              FounderGetUserInfo(
                                                  userData[index]["coFounderOrInvestorUser"]["email"]),
                                        ),
                                      );
                                    },
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${userData[index]["coFounderOrInvestorUser"]['firstName']} ${userData[index]["coFounderOrInvestorUser"]['lastName']}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          Text(
                                            "${userData[index]["coFounderOrInvestorUser"]['email']}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                    onPressed: () async {
                                      // Call the API to add a connection
                                      await addConnection(
                                          userData[index]["connectionId"]);
                                    },
                                    child: Row(
                                      children: [
                                        const Icon(Icons.check),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.01,
                                        ),
                                        const Text("Connected")
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              height: 20,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
