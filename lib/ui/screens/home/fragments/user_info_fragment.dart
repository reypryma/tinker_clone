import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tinker_clone/global/app_constant.dart';

import '../../../../models/Person.dart';
import '../../account/account_settings_screen.dart';

class UserInfoFragment extends StatefulWidget {
  final String userID;

  const UserInfoFragment({super.key, required this.userID});

  @override
  State<UserInfoFragment> createState() => _UserInfoFragmentState();
}

class _UserInfoFragmentState extends State<UserInfoFragment> {
  //Personal Info
  late Person userPerson;
  bool isLoading = true;

  List<String> sliderImages = [];
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();

    if(kDebugMode) print("Run User Detail Fragment");
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

        setState(() {
          isLoading = false;
        });
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
        leading: widget.userID != currentUserID ? IconButton(
          onPressed: ()
          {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_outlined, size: 30,),
        ) : Container(),
        automaticallyImplyLeading: false,
        actions: [
          widget.userID == currentUserID ?
          Row(
            children: [
              IconButton(
                onPressed: ()
                {
                  Get.to(AccountSettingsScreen());
                },
                icon: const Icon(
                  Icons.settings,
                  size: 30,
                ),
              ),
              IconButton(
                onPressed: ()
                {
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(
                  Icons.logout,
                  size: 30,
                ),
              ),
            ],
          ) : Container(),
        ],
      ),
      body: isLoading ? Container() : SingleChildScrollView(
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
              //personal info table data
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Table(
                  children: [

                    //name
                    TableRow(
                      children:
                      [
                        const Text(
                          "Name: ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),

                        Text(
                          userPerson.name ?? "-",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),

                    //extra row
                    const TableRow(
                      children:
                      [
                        Text(""),
                        Text(""),
                      ],
                    ),

                    //age
                    TableRow(
                      children:
                      [
                        const Text(
                          "Age: ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),

                        Text(
                          "${userPerson.age ?? "-"}",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),

                    //extra row
                    const TableRow(
                      children:
                      [
                        Text(""),
                        Text(""),
                      ],
                    ),

                    //phone No
                    TableRow(
                      children:
                      [
                        const Text(
                          "Phone Number: ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),

                        Text(
                          userPerson.phoneNo ?? "-",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),

                    //extra row
                    const TableRow(children :[
                      Text(''),
                      Text(""),
                    ]),

                    //city
                    TableRow(children :[
                      const Text(
                        "City: ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        userPerson.city ?? "-",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ]),

                    //extra row
                    const TableRow(children :[
                      Text(''),
                      Text(""),
                    ]),

                    //country
                    TableRow(children :[
                      const Text(
                        "Country: ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        userPerson.country ?? "-",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ]),

                    //extra row
                    const TableRow(children :[
                      Text(''),
                      Text(""),
                    ]),

                    //seeking
                    TableRow(children :[
                      const Text(
                        "Seeking: ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        userPerson.lookingForInaPartner ?? "-",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ]),

                  ],
                ),
              ),

              //appearance title
              const SizedBox(height: 30,),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Appearance:",
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
              //appearance table data
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Table(
                  children: [

                    //height
                    TableRow(children :[
                      const Text(
                        "Height: ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        userPerson.height ?? "-",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ]),

                    //extra row
                    const TableRow(children :[
                      Text(''),
                      Text(""),
                    ]),

                    //Weight
                    TableRow(children :[
                      const Text(
                        "Weight: ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        userPerson.weight ?? "-",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ]),

                    //extra row
                    const TableRow(children :[
                      Text(''),
                      Text(""),
                    ]),

                    //Body Type
                    TableRow(children :[
                      const Text(
                        "Body Type: ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        userPerson.bodyType ?? "-",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ]),

                  ],
                ),
              ),

              //Life style title
              const SizedBox(height: 30,),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Life style:",
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
              //Life style table data
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Table(
                  children: [

                    //Drink
                    TableRow(children :[
                      const Text(
                        "Drink: ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        userPerson.drink ?? "-",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ]),

                    //extra row
                    const TableRow(children :[
                      Text(''),
                      Text(""),
                    ]),

                    //Smoke
                    TableRow(children :[
                      const Text(
                        "Smoke: ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        userPerson.smoke ?? "-",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ]),

                    //extra row
                    const TableRow(children :[
                      Text(''),
                      Text(""),
                    ]),

                    //Martial Status
                    TableRow(children :[
                      const Text(
                        "Martial Status: ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        userPerson.martialStatus ?? "-",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ]),

                    //extra row
                    const TableRow(children :[
                      Text(''),
                      Text(""),
                    ]),

                    //Have Children
                    TableRow(children :[
                      const Text(
                        "Have Children: ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        userPerson.haveChildren ?? "-",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ]),

                    //extra row
                    const TableRow(children :[
                      Text(''),
                      Text(""),
                    ]),

                    //Number of Children
                    TableRow(children :[
                      const Text(
                        "Number of Children: ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        userPerson.noOfChildren ?? "-",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ]),

                    //extra row
                    const TableRow(children :[
                      Text(''),
                      Text(""),
                    ]),

                    //Profession
                    TableRow(children :[
                      const Text(
                        "Profession: ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        userPerson.profession ?? "-",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ]),

                    //extra row
                    const TableRow(children :[
                      Text(''),
                      Text(""),
                    ]),

                    //Employment Status
                    TableRow(children :[
                      const Text(
                        "Employment Status: ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        userPerson.employmentStatus ?? "-",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ]),

                    //extra row
                    const TableRow(children :[
                      Text(''),
                      Text(""),
                    ]),

                    //Income
                    TableRow(children :[
                      const Text(
                        "Income: ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        userPerson.income ?? "-",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ]),

                    //extra row
                    const TableRow(children :[
                      Text(''),
                      Text(""),
                    ]),

                    //Living Situation
                    TableRow(children :[
                      const Text(
                        "Living Situation: ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        userPerson.livingSituation ?? "-",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ]),

                    //extra row
                    const TableRow(children :[
                      Text(''),
                      Text(""),
                    ]),

                    //Willing to Relocate
                    TableRow(children :[
                      const Text(
                        "Willing to Relocate: ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        userPerson.willingToRelocate ?? "-",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ]),

                    //extra row
                    const TableRow(children :[
                      Text(''),
                      Text(""),
                    ]),

                    //Looking for
                    TableRow(children :[
                      const Text(
                        "Looking for: ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        userPerson.relationshipYouAreLookingFor ?? "-",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ]),

                  ],
                ),
              ),

              //Background - Cultural Values title
              const SizedBox(height: 30,),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Background - Cultural Values:",
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
              //Background - Cultural Values tables data
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Table(
                  children: [

                    //Nationality
                    TableRow(children :[
                      const Text(
                        "Nationality: ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        userPerson.nationality ?? "-",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ]),

                    //extra row
                    const TableRow(children :[
                      Text(''),
                      Text(""),
                    ]),

                    //Education
                    TableRow(children :[
                      const Text(
                        "Education: ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        userPerson.education ?? "-",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ]),

                    //extra row
                    const TableRow(children :[
                      Text(''),
                      Text(""),
                    ]),

                    //Language Spoken
                    TableRow(children :[
                      const Text(
                        "Language Spoken: ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        userPerson.languageSpoken ?? "-",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ]),

                    //extra row
                    const TableRow(children :[
                      Text(''),
                      Text(""),
                    ]),

                    //Religion
                    TableRow(children :[
                      const Text(
                        "Religion: ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        userPerson.religion ?? "-",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ]),

                    //extra row
                    const TableRow(children :[
                      Text(''),
                      Text(""),
                    ]),

                    //Ethnicity
                    TableRow(children :[
                      const Text(
                        "Ethnicity: ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        userPerson.ethnicity ?? "-",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ]),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
