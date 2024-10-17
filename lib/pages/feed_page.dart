import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finstagram/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  double? deviceHeight, deviceWidth;
  FirebaseService? firebaseService;

  @override
  void initState() {
    super.initState();
    firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: deviceHeight,
      width: deviceWidth,
      child: postsListView(),
    );
  }

  Widget postsListView() {
    return StreamBuilder<QuerySnapshot>(
      stream: firebaseService!.getLatestPosts(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List posts = snapshot.data!.docs.map((e) => e.data()).toList();
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
              Map post = posts[index];
              return Container(
                margin: EdgeInsets.symmetric(
                  vertical: deviceHeight! * 0.01,
                  horizontal: deviceWidth! * 0.05
                ),
                height: deviceHeight! * 0.30,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                        post['image'],
                      ),
                      fit: BoxFit.cover),
                ),
              );
            },
          );
        } else {
          return Center(
            child: const CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
