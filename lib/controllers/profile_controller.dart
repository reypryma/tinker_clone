import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tinker_clone/global/app_constant.dart';
import 'package:tinker_clone/services/firebase_access.dart';
import 'package:http/http.dart' as http;

import '../models/Person.dart';

class ProfileController extends GetxController {
  final Rx<List<Person>> usersProfileList = Rx<List<Person>>([]);
  Rx<String?> fcmToken = Rx<String?>(null);

  String? get getFcmToken => fcmToken.value;


  List<Person> get allUsersProfileList => usersProfileList.value;

  @override
  void onInit() async {
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

  @override
  void onReady() {
    super.onReady();
  }

  favoriteSentAndFavoriteReceived(String toUserID, String senderName) async {
    var document = await FirebaseFirestore.instance
        .collection("users")
        .doc(toUserID)
        .collection("favoriteReceived")
        .doc(currentUserID)
        .get();

    //remove the favorite from database
    if (document.exists) {
      //remove currentUserID from the favoriteReceived list of that profile person [toUserID]
      await FirebaseFirestore.instance
          .collection("users")
          .doc(toUserID)
          .collection("favoriteReceived")
          .doc(currentUserID)
          .delete();

      //remove profile person [toUserID] from the favoriteSent list of the currentUser
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID)
          .collection("favoriteSent")
          .doc(toUserID)
          .delete();
    } else //mark as favorite //add favorite in database
    {
      //add currentUserID to the favoriteReceived list of that profile person [toUserID]
      await FirebaseFirestore.instance
          .collection("users")
          .doc(toUserID)
          .collection("favoriteReceived")
          .doc(currentUserID)
          .set({});

      //add profile person [toUserID] to the favoriteSent list of the currentUser
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID)
          .collection("favoriteSent")
          .doc(toUserID)
          .set({});

      //send notification
      sendNotificationToUser(toUserID, "Favorite", senderName);
    }

    update();
  }

  Future<void> tokenGenerateProfile() async {
    await FirebaseAccessToken().getAccessToken().then((value) {
      fcmToken = Rx<String?>(value);
      log("tokenGenerateProfile ${fcmToken.value!}");
    },).onError((error, stackTrace) {
      print("OnInit: $stackTrace");
    },);

    update();
  }

  likeSentAndLikeReceived(String toUserID, String senderName) async {
    var document = await FirebaseFirestore.instance
        .collection("users")
        .doc(toUserID)
        .collection("likeReceived")
        .doc(currentUserID)
        .get();

    //remove the like from database
    if (document.exists) {
      //remove currentUserID from the likeReceived list of that profile person [toUserID]
      await FirebaseFirestore.instance
          .collection("users")
          .doc(toUserID)
          .collection("likeReceived")
          .doc(currentUserID)
          .delete();

      //remove profile person [toUserID] from the likeSent list of the currentUser
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID)
          .collection("likeSent")
          .doc(toUserID)
          .delete();
    } else //add-sent like in database
    {
      //add currentUserID to the likeReceived list of that profile person [toUserID]
      await FirebaseFirestore.instance
          .collection("users")
          .doc(toUserID)
          .collection("likeReceived")
          .doc(currentUserID)
          .set({});

      //add profile person [toUserID] to the likeSent list of the currentUser
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID)
          .collection("likeSent")
          .doc(toUserID)
          .set({});

      //send notification
      sendNotificationToUser(toUserID, "Like", senderName);
    }

    update();
  }

  viewSentAndViewReceived(String toUserID, String senderName) async {
    var document = await FirebaseFirestore.instance
        .collection("users")
        .doc(toUserID)
        .collection("viewReceived")
        .doc(currentUserID)
        .get();

    if (document.exists) {
      if (kDebugMode) {
        print("already in view list");
      }
      sendNotificationToUser(toUserID, "View", senderName);
    } else //add new view in database
    {
      //add currentUserID to the viewReceived list of that profile person [toUserID]
      await FirebaseFirestore.instance
          .collection("users")
          .doc(toUserID)
          .collection("viewReceived")
          .doc(currentUserID)
          .set({});

      //add profile person [toUserID] to the viewSent list of the currentUser
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID)
          .collection("viewSent")
          .doc(toUserID)
          .set({});

      //send notification
      sendNotificationToUser(toUserID, "View", senderName);
    }

    update();
  }

  sendNotificationToUser(
      String receiverID, String featureType, String senderName) async {
    String userDeviceToken = "";

    await FirebaseFirestore.instance
        .collection("users")
        .doc(receiverID)
        .get()
        .then((snapshot) {
      if (snapshot.data()!["userDeviceToken"] != null) {
        userDeviceToken = snapshot.data()!["userDeviceToken"].toString();
      }
    });

    print("UserDeviceToken from DB Is $userDeviceToken");

    try {
      notificationFormat(
            userDeviceToken,
            receiverID,
            featureType,
            senderName,
          );
    } catch (e) {
      print("AAAAAAA ${e}");
    }
  }

  Future<void> notificationFormat(
      String userDeviceToken, receiverID, featureType, senderName) async {
    Map<String, String> headerNotification = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${getFcmToken!}"
    };
    Map bodyNotification =
    {
      "body": "you have received a new $featureType from $senderName. Click to see.",
      "title": "New $featureType",
    };


    Map dataMap =
    {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "userID": receiverID,
      "senderID": currentUserID,
    };

    Map notificationOfficialFormat =
    {
      "notification": bodyNotification,
      "data": dataMap,
      // "priority": "high",
      "token": userDeviceToken,
    };


    Map messageWrapper = {
      "message": notificationOfficialFormat
    };

    log("Map ${jsonEncode(messageWrapper)}");

    final http.Response response = await http.post(
      Uri.parse("https://fcm.googleapis.com/v1/projects/fir-learn-2166e/messages:send"),
      headers: headerNotification,
      body: jsonEncode(messageWrapper),
    );

    if(response.statusCode == 200){
      print("notification sent successfully ${response.body.toString()}");
    } else {
      print("Notification Failed, ${response.statusCode} is ${response.body.toString()}");
    }
  }
}
