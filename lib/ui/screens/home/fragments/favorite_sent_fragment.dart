import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../global/app_constant.dart';

class FavoriteSentFavoriteReceivedFragment extends StatefulWidget {
  const FavoriteSentFavoriteReceivedFragment({super.key});

  @override
  State<FavoriteSentFavoriteReceivedFragment> createState() =>
      _FavoriteSentFavoriteReceivedFragmentState();
}

class _FavoriteSentFavoriteReceivedFragmentState
    extends State<FavoriteSentFavoriteReceivedFragment> {
  bool isFavoriteSentClicked = true;
  List<String> favoriteSentList = [];
  List<String> favoriteReceivedList = [];
  List favoritesList = [];

  getFavoriteListKeys() async {
    if (isFavoriteSentClicked) {
      var favoriteSentDocument = await FirebaseFirestore.instance
          .collection(AppConstant.firebaseUserCollections)
          .doc(currentUserID.toString())
          .collection(AppConstant.firebaseUserFavoriteSentCollections)
          .get();

      for (int i = 0; i < favoriteSentDocument.docs.length; i++) {
        favoriteSentList.add(favoriteSentDocument.docs[i].id);
      }

      if (kDebugMode) {
        print("favoriteSentList = $favoriteSentList");
      }
      getKeysDataFromUsersCollection(favoriteSentList);
    } else {
      var favoriteReceivedDocument = await FirebaseFirestore.instance
          .collection(AppConstant.firebaseUserCollections)
          .doc(currentUserID.toString())
          .collection(AppConstant.firebaseUserFavoriteReceivedCollections)
          .get();

      for (int i = 0; i < favoriteReceivedDocument.docs.length; i++) {
        favoriteReceivedList.add(favoriteReceivedDocument.docs[i].id);
      }

      if (kDebugMode) {
        print("favoriteReceivedList = $favoriteReceivedList");
      }
      getKeysDataFromUsersCollection(favoriteReceivedList);
    }
  }

  getKeysDataFromUsersCollection(List<String> keysList) async {
    var allUsersDocument =
        await FirebaseFirestore.instance.collection(AppConstant.firebaseUserCollections).get();

    for (int i = 0; i < allUsersDocument.docs.length; i++) {
      for (int k = 0; k < keysList.length; k++) {
        if (((allUsersDocument.docs[i].data() as dynamic)["uid"]) ==
            keysList[k]) {
          favoritesList.add(allUsersDocument.docs[i].data());
        }
      }
    }

    setState(() {
      favoritesList;
    });

    if (kDebugMode) {
      print("favoritesList = $favoritesList");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Favorite Sent Favorite Received Screen",
          style: TextStyle(
            color: Colors.green,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
