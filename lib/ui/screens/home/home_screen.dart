import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    const ViewSentViewReceivedFragment(),
    const FavoriteSentFavoriteReceivedFragment(),
    UserInfoFragment(userID: FirebaseAuth.instance.currentUser!.uid),
  ];

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
                Icons.remove_red_eye,
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
                Icons.favorite,
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
