import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tinker_clone/global/app_constant.dart';

import '../models/Person.dart';

class ProfileController extends GetxController {
  final Rx<List<Person>> usersProfileList = Rx<List<Person>>([]);

  List<Person> get allUsersProfileList => usersProfileList.value;

  @override
  void onInit() {
    super.onInit();

    usersProfileList.bindStream(FirebaseFirestore.instance
        .collection(AppConstant.firebaseUserCollections)
        .where("uid", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((QuerySnapshot queryDataSnapshot) {
      List<Person> profilesList = [];

      for (var eachProfile in queryDataSnapshot.docs) {
        profilesList.add(Person.fromDataSnapshot(eachProfile));
      }
      return profilesList;
    }));
  }

  favoriteSentAndFavoriteReceived(String toUserID, String senderName) async {
    var document = await FirebaseFirestore.instance
        .collection(AppConstant.firebaseUserCollections)
        .doc(toUserID)
        .collection(AppConstant.firebaseUserFavoriteReceivedCollections)
        .doc(currentUserID)
        .get();

    //remove the favorite from database
    if (document.exists) {
      //remove currentUserID from the favoriteReceived list of that profile person [toUserID]
      await FirebaseFirestore.instance
          .collection(AppConstant.firebaseUserCollections)
          .doc(toUserID)
          .collection(AppConstant.firebaseUserFavoriteReceivedCollections)
          .doc(currentUserID)
          .delete();

      //remove profile person [toUserID] from the favoriteSent list of the currentUser
      await FirebaseFirestore.instance
          .collection(AppConstant.firebaseUserCollections)
          .doc(currentUserID)
          .collection(AppConstant.firebaseUserFavoriteSentCollections)
          .doc(toUserID)
          .delete();
    } else //mark as favorite //add favorite in database
    {
      //add currentUserID to the favoriteReceived list of that profile person [toUserID]
      await FirebaseFirestore.instance
          .collection(AppConstant.firebaseUserCollections)
          .doc(toUserID)
          .collection(AppConstant.firebaseUserFavoriteReceivedCollections)
          .doc(currentUserID)
          .set({});

      //add profile person [toUserID] to the favoriteSent list of the currentUser
      await FirebaseFirestore.instance
          .collection(AppConstant.firebaseUserCollections)
          .doc(currentUserID)
          .collection(AppConstant.firebaseUserFavoriteSentCollections)
          .doc(toUserID)
          .set({});

      //send notification
    }

    update();
  }
  likeSentAndLikeReceived(String toUserID, String senderName) async {
    var document = await FirebaseFirestore.instance
        .collection(AppConstant.firebaseUserCollections)
        .doc(toUserID)
        .collection(AppConstant.firebaseUserLikeReceivedCollections)
        .doc(currentUserID)
        .get();

    /// Remove the like from database
    if (document.exists) {
      /// remove currentUserID from the likeReceived list of that profile person [toUserID]
      await FirebaseFirestore.instance
          .collection(AppConstant.firebaseUserCollections)
          .doc(toUserID)
          .collection(AppConstant.firebaseUserLikeReceivedCollections)
          .doc(currentUserID)
          .delete();

      ///remove profile person [toUserID] from the likeSent list of the currentUser
      await FirebaseFirestore.instance
          .collection(AppConstant.firebaseUserCollections)
          .doc(currentUserID).collection(AppConstant.firebaseUserLikeSentCollections)
          .doc(toUserID)
          .delete();

    } else {
      await FirebaseFirestore.instance
          .collection(AppConstant.firebaseUserCollections)
          .doc(toUserID)
          .collection(AppConstant.firebaseUserLikeReceivedCollections)
          .doc(currentUserID)
          .delete();

      //add profile person [toUserID] to the likeSent list of the currentUser
      await FirebaseFirestore.instance
          .collection(AppConstant.firebaseUserCollections)
          .doc(currentUserID).collection(AppConstant.firebaseUserLikeSentCollections)
          .doc(toUserID)
          .set({});

      /// TODO send notification
    }
    update();
  }
}
