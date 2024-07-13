import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tinker_clone/global/app_constant.dart';
import 'package:tinker_clone/services/push_notification_system.dart';

import '../../../services/firebase_access.dart';
import 'fragments/favorite_sent_fragment.dart';
import 'fragments/like_sent_fragment.dart';
import 'fragments/swipping_fragment.dart';
import 'fragments/user_info_fragment.dart';
import 'fragments/view_sent_fragment.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
{
  int screenIndex = 0;

  List tabScreensList =
  [
    const SwipingFragment(),
    const LikeSentLikeReceivedFragment(),
    const FavoriteSentFavoriteReceivedFragment(),
    const ViewSentViewReceivedFragment(),
    UserInfoFragment(userID: currentUserID),
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    PushNotificationSystem notificationSystem = PushNotificationSystem();
    notificationSystem.generateDeviceRegisterationToken();
    notificationSystem.whenNotificationReceived(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (indexNumber)
        {
          setState(() {
            screenIndex = indexNumber;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white12,
        currentIndex: screenIndex,
        items: const [
          //SwippingScreen
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30,
              ),
              label: ""
          ),

          //viewSentViewReceived icon button
          BottomNavigationBarItem(
              icon: Icon(
                Icons.dvr_outlined,
                size: 30,
              ),
              label: ""
          ),

          //favoriteSentFavoriteReceived icon button
          BottomNavigationBarItem(
              icon: Icon(
                Icons.star,
                size: 30,
              ),
              label: ""
          ),

          //likeSentLikeReceived icon button
          BottomNavigationBarItem(
              icon: Icon(
                Icons.remove_red_eye,
                size: 30,
              ),
              label: ""
          ),

          //userDetailsScreen icon button
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 30,
              ),
              label: ""
          ),

        ],
      ),
      body: tabScreensList[screenIndex],
    );
  }
}
