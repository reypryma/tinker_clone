import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:tinker_clone/ui/screens/home/fragments/user_info_fragment.dart';
import 'package:tinker_clone/ui/widgets/loading_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../controllers/profile_controller.dart';
import '../../../../global/app_constant.dart';
import '../../../../services/firebase_access.dart';
import '../../../../services/push_notification_system.dart';

class SwipingFragment extends StatefulWidget {
  const SwipingFragment({super.key});

  @override
  State<SwipingFragment> createState() => _SwipingFragmentState();
}

class _SwipingFragmentState extends State<SwipingFragment> {
  ProfileController profileController = Get.put(ProfileController());
  String senderName = "";
  final pageController = PageController(initialPage: 0, viewportFraction: 1);
  bool loading = true;

  startChattingInWhatsApp(String receiverPhoneNumber) async
  {
    var androidUrl = "whatsapp://send?phone=$receiverPhoneNumber&text=Hi, I found your profile on dating app.";
    var iosUrl = "https://wa.me/$receiverPhoneNumber?text=${Uri.parse('Hi, I found your profile on dating app.')}";

    try
    {
      if(Platform.isIOS)
      {
        await launchUrl((Uri.parse(iosUrl)));
      }
      else
      {
        await launchUrl((Uri.parse(androidUrl)));
      }
    }
    on Exception
    {
      showDialog(
          context: context,
          builder: (BuildContext context)
          {
            return AlertDialog(
              title: const Text("Whatsapp Not Found"),
              content: const Text("WhatsApp is not installed."),
              actions: [
                TextButton(
                  onPressed: ()
                  {
                    Get.back();
                  },
                  child: const Text("Ok"),
                ),
              ],
            );
          }
      );
    }
  }


  void readCurrentUserData() async {
    await FirebaseFirestore.instance
        .collection(AppConstant.firebaseUserCollections)
        .doc(currentUserID)
        .get()
        .then((dataSnapshot) {
      setState(() {
        senderName = dataSnapshot.data()!["name"].toString();
      });
    });

    await profileController.tokenGenerateProfile().then((value) {
      PushNotificationSystem notificationSystem = PushNotificationSystem();
      notificationSystem.generateDeviceRegisterationToken(profileController.getFcmToken!);
      notificationSystem.whenNotificationReceived(context);
    },).whenComplete(
      () => setState(() {
        loading = false;
      }),
    ).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      Get.snackbar('Error', stackTrace.toString());
    },);
  }
  @override
  void initState() {
    super.initState();
    if (kDebugMode) print("Run Swipe Fragment");
    readCurrentUserData();
    // init();
  }

  applyFilter()
  {
    showDialog(
        context: context,
        builder: (BuildContext context)
        {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState)
            {
              return AlertDialog(
                title: const Text(
                  "Matching Filter",
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("I am looking for a:"),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DropdownButton<String>(
                        hint: const Text('Select gender'),
                        value: chosenGender,
                        underline: Container(),
                        items: [
                          'Male',
                          'Female',
                          'Others'
                        ].map((value)
                        {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value)
                        {
                          setState(() {
                            chosenGender = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20,),

                    const Text("who lives in:"),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DropdownButton<String>(
                        hint: const Text('Select country'),
                        value: chosenCountry,
                        underline: Container(),
                        items: [
                          'Spain',
                          'France',
                          'Germany',
                          'United Kingdom',
                          'Canada',
                          'USA',
                        ].map((value)
                        {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value)
                        {
                          setState(() {
                            chosenCountry = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20,),

                    const Text("who's age is equal to or above:"),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DropdownButton<String>(
                        hint: const Text('Select age'),
                        value: chosenAge,
                        underline: Container(),
                        items: [
                          '18',
                          '20',
                          '25',
                          '30',
                          '35',
                          '40',
                          '45',
                          '50',
                          '55',
                        ].map((value)
                        {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value)
                        {
                          setState(() {
                            chosenAge = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20,),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: ()
                    {
                      Get.back();
                      profileController.getResults();
                    },
                    child: const Text("Done"),
                  ),
                ],
              );
            },
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {

    Widget mainSwippingView(){
      return NotificationListener<OverscrollIndicatorNotification>(
        onNotification: ((notification) {
          if (notification.leading) {
            return true; // Prevent glow effect at the start of the list
          } else if (pageController.page ==
              profileController.allUsersProfileList.length - 1) {
            // User is overscrolling at the end of the list
            pageController.animateToPage(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
            return true; // Prevent glow effect at the end of the list
          }
          return false;
        }),
        child: PageView.builder(
          itemCount: profileController.allUsersProfileList.length,
          controller: pageController,
          scrollDirection: Axis.horizontal,
          onPageChanged: (int index) {
            // // Check if the user swiped to the last index
            // if (index == profileController.allUsersProfileList.length) {
            //   // Animate to the first page smoothly
            //   pageController.animateToPage(
            //     0, // Index of the first page
            //     duration: const Duration(milliseconds: 300), // Animation duration
            //     curve: Curves.ease, // Animation curve for smooth transition
            //   );
            // }
          },
          itemBuilder: (context, index) {
            final eachProfileInfo =
            profileController.allUsersProfileList[index];

            return DecoratedBox(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      eachProfileInfo.imageProfile.toString(),
                    ),
                    fit: BoxFit.cover,
                  )),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    //filter icon button
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: IconButton(
                          onPressed: () {
                            applyFilter();
                          },
                          icon: const Icon(
                            Icons.filter_list,
                            size: 30,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    //user data
                    GestureDetector(
                      onTap: () {
                        profileController.viewSentAndViewReceived(
                          eachProfileInfo.uid.toString(),
                          senderName,
                        );

                        //send user to profile person userDetailScreen
                        Get.to(UserInfoFragment(
                          userID: eachProfileInfo.uid.toString(),
                        ));
                      },
                      child: Column(
                        children: [
                          //name
                          Text(
                            eachProfileInfo.name.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              letterSpacing: 4,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          //age - city
                          Text(
                            "${eachProfileInfo.age} ◉ ${eachProfileInfo.city}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              letterSpacing: 4,
                            ),
                          ),

                          const SizedBox(
                            height: 4,
                          ),

                          //profession and religion
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white30,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(16)),
                                ),
                                child: Text(
                                  eachProfileInfo.profession.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white30,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(16)),
                                ),
                                child: Text(
                                  eachProfileInfo.religion.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          //country and ethnicity
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white30,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(16)),
                                ),
                                child: Text(
                                  eachProfileInfo.country.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white30,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(16)),
                                ),
                                child: Text(
                                  eachProfileInfo.ethnicity.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    //image buttons - favorite - chat - like
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //favorite button
                        GestureDetector(
                          onTap: () {
                            profileController.favoriteSentAndFavoriteReceived(
                              eachProfileInfo.uid.toString(),
                              senderName,
                            );
                          },
                          child: Image.asset(
                            AppConstant.favoriteImage,
                            width: 60,
                          ),
                        ),

                        //chat button
                        GestureDetector(
                          onTap: () {
                            startChattingInWhatsApp(eachProfileInfo.phoneNo.toString());
                          },
                          child: Image.asset(
                            AppConstant.chatImage,
                            width: 90,
                          ),
                        ),

                        //like button
                        GestureDetector(
                          onTap: () {
                            profileController.likeSentAndLikeReceived(
                                eachProfileInfo.uid.toString(), senderName);
                          },
                          child: Image.asset(
                            AppConstant.likeImage,
                            width: 60,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      body: loading ? LoadingWidget(containerWidth: MediaQuery.of(context).size.width) : Obx(() {
          return mainSwippingView();
      }),
    );
  }
}
