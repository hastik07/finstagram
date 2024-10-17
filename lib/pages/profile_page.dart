import 'package:finstagram/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: deviceWidth! * 0.05,
        vertical: deviceHeight! * 0.02,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          profileImage(),
          postsGridView(),
        ],
      ),
    );
  }

  Widget profileImage() {
    return Container(
      margin: EdgeInsets.only(
        bottom: deviceHeight! * 0.02,
      ),
      height: deviceHeight! * 0.15,
      width: deviceHeight! * 0.15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          100,
        ),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            firebaseService!.currentUser!['image'],
          ),
        ),
      ),
    );
  }

  Widget postsGridView() {
    return Expanded(
      child: StreamBuilder(
        stream: firebaseService!.getPostsUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List posts = snapshot.data!.docs
                .map(
                  (e) => e.data(),
                )
                .toList();
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
              ),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                Map post = posts[index];
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        post['image'],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: const CircularProgressIndicator(
                color: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }
}
