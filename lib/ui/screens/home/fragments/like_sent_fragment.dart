import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../global/app_constant.dart';

class LikeSentLikeReceivedFragment extends StatefulWidget {
  const LikeSentLikeReceivedFragment({super.key});

  @override
  State<LikeSentLikeReceivedFragment> createState() =>
      _LikeSentLikeReceivedFragmentState();
}

class _LikeSentLikeReceivedFragmentState
    extends State<LikeSentLikeReceivedFragment> {
  bool isLikeSentClicked = true;
  List<String> likeSentList = [];
  List<String> likeReceivedList = [];
  List likesList = [];

  getLikedListKeys() async {
    if (isLikeSentClicked) {
      var favoriteSentDocument = await FirebaseFirestore.instance
          .collection(AppConstant.firebaseUserCollections)
          .doc(currentUserID.toString())
          .collection(AppConstant.firebaseUserLikeSentCollections)
          .get();

      for (int i = 0; i < favoriteSentDocument.docs.length; i++) {
        likeSentList.add(favoriteSentDocument.docs[i].id);
      }

      if (kDebugMode) {
        print("likeSentList = $likeSentList");
      }
      getKeysDataFromUsersCollection(likeSentList);
    } else {
      var favoriteReceivedDocument = await FirebaseFirestore.instance
          .collection(AppConstant.firebaseUserCollections)
          .doc(currentUserID.toString())
          .collection(AppConstant.firebaseUserLikeReceivedCollections)
          .get();

      for (int i = 0; i < favoriteReceivedDocument.docs.length; i++) {
        likeReceivedList.add(favoriteReceivedDocument.docs[i].id);
      }

      if (kDebugMode) {
        print("likeReceivedList = $likeReceivedList");
      }
      getKeysDataFromUsersCollection(likeReceivedList);
    }
  }

  getKeysDataFromUsersCollection(List<String> keysList) async {
    var allUsersDocument = await FirebaseFirestore.instance
        .collection(AppConstant.firebaseUserCollections)
        .get();

    for (int i = 0; i < allUsersDocument.docs.length; i++) {
      for (int k = 0; k < keysList.length; k++) {
        if (((allUsersDocument.docs[i].data() as dynamic)["uid"]) ==
            keysList[k]) {
          likesList.add(allUsersDocument.docs[i].data());
        }
      }
    }

    setState(() {
      likesList;
    });

    if (kDebugMode) {
      print("likesList = $likesList");
    }
  }

  @override
  void initState() {
    super.initState();
    if(kDebugMode) print("Run Like Fragment");
    getLikedListKeys();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                likeSentList.clear();
                likeSentList = [];
                likeReceivedList.clear();
                likeReceivedList = [];
                likesList.clear();
                likesList = [];

                setState(() {
                  isLikeSentClicked = true;
                });

                getLikedListKeys();
              },
              child: Text(
                "My Likes",
                style: TextStyle(
                  color: isLikeSentClicked ? Colors.white : Colors.grey,
                  fontWeight:
                      isLikeSentClicked ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
            const Text(
              "   |   ",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            TextButton(
              onPressed: () {
                likeSentList.clear();
                likeSentList = [];
                likeReceivedList.clear();
                likeReceivedList = [];
                likesList.clear();
                likesList = [];

                setState(() {
                  isLikeSentClicked = false;
                });

                getLikedListKeys();
              },
              child: Text(
                "Liked Me",
                style: TextStyle(
                  color: isLikeSentClicked ? Colors.grey : Colors.white,
                  fontWeight:
                      isLikeSentClicked ? FontWeight.normal : FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: likesList.isEmpty
          ? const Center(
              child: Icon(
                Icons.person_off_sharp,
                color: Colors.white,
                size: 60,
              ),
            )
          : GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(8),
              children: List.generate(likesList.length, (index) {
                return GridTile(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Card(
                      color: Colors.blue.shade200,
                      child: GestureDetector(
                        onTap: () {},
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: NetworkImage(
                              likesList[index]["imageProfile"],
                            ),
                            fit: BoxFit.cover,
                          )),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Spacer(),

                                  //name - age
                                  Text(
                                    "${likesList[index]["name"]} ◉ ${likesList[index]["age"]}",
                                    maxLines: 2,
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 4,
                                  ),

                                  //icon - city - country
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.grey,
                                        size: 16,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${likesList[index]["city"]}, ${likesList[index]["country"]}",
                                          maxLines: 2,
                                          style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
    );
  }
}
