import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:finstagram/pages/feed_page.dart';
import 'package:finstagram/pages/profile_page.dart';
import 'package:finstagram/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseService? firebaseService;

  int currentPage = 0;
  final List<Widget> pages = [
    const FeedPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finstagram'),
        actions: [
          GestureDetector(
            onTap: postImage,
            child: const Icon(
              Icons.add_a_photo,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            child: GestureDetector(
              onTap: () async {
                await firebaseService!.logOut();
                Navigator.popAndPushNamed(
                  context,
                  'login',
                );
              },
              child: const Icon(Icons.logout),
            ),
          )
        ],
      ),
      bottomNavigationBar: bottomNavigationBar(),
      body: pages[currentPage],
    );
  }

  Widget bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentPage,
      onTap: (index) {
        setState(() {
          currentPage = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          label: 'Feed',
          icon: Icon(
            Icons.feed,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Profile',
          icon: Icon(
            Icons.account_box,
          ),
        ),
      ],
    );
  }

  void postImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    File? image = File(result!.files.first.path!);
    await firebaseService!.postImage(image);
  }
}
