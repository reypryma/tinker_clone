import 'package:carousel_slider/carousel_slider.dart';
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
  int _current = 0;
  final CarouselController _controller = CarouselController();

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
        setState(() {
          for (int i = 1; i <= 5; i++) {
            sliderImages.add(snapshot.data()?["urlImage$i"] ??
                AppConstant.firebaseDefaultAvatarUrl);
          }
        });
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
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: CarouselSlider(
                    items: sliderImages
                        .map(
                          (e) => Image.network(
                            e,
                            fit: BoxFit.cover,
                          ),
                        )
                        .toList(),
                    carouselController: _controller,
                    options: CarouselOptions(
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.3,
                      scrollDirection: Axis.vertical,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      },
                    ),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: sliderImages.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black)
                              .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(
                height: 10.0,
              ),

              //personal info title
              const SizedBox(
                height: 30,
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Personal Info:",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(
                color: Colors.white,
                thickness: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
