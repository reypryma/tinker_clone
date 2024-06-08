import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tinker_clone/global/app_constant.dart';

import '../../../../models/Person.dart';

class UserInfoFragment extends StatefulWidget {
  final String userID;

  const UserInfoFragment({super.key, required this.userID});

  @override
  State<UserInfoFragment> createState() => _UserInfoFragmentState();
}

class _UserInfoFragmentState extends State<UserInfoFragment> {
  //Personal Info
  late Person userPerson;

  List<String> sliderImages = [];

  @override
  void initState() {
    super.initState();
    retrieveUserInfo();
  }

  retrieveUserInfo() async {
    await FirebaseFirestore.instance
        .collection(AppConstant.firebaseUserCollections)
        .doc(widget.userID)
        .get()
        .then(
      (snapshot) {
        for (int i = 1; i <= 5; i++) {
          sliderImages.add(snapshot.data()?["urlImage$i"] ??
              AppConstant.firebaseDefaultAvatarUrl);
        }

        //Personal Info
        userPerson = Person.fromDataSnapshot(snapshot);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User Profile",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(
              Icons.logout,
              size: 30,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              //image slider
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                child: Padding(padding: const EdgeInsets.all(2)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
