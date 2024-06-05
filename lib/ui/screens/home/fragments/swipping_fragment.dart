import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:tinker_clone/controllers/profile_controller.dart';
import 'package:tinker_clone/global/app_constant.dart';

class SwipingFragment extends StatefulWidget {
  const SwipingFragment({super.key});

  @override
  State<SwipingFragment> createState() => _SwipingFragmentState();
}

class _SwipingFragmentState extends State<SwipingFragment> {
  ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return PageView.builder(
          itemCount: profileController.allUsersProfileList.length,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.horizontal,
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
                          onPressed: () {},
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
                      onTap: () {},
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
                                      borderRadius: BorderRadius.circular(16)),
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
                                      borderRadius: BorderRadius.circular(16)),
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
                                      borderRadius: BorderRadius.circular(16)),
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
                                      borderRadius: BorderRadius.circular(16)),
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
                          onTap: () {},
                          child: Image.asset(
                            AppConstant.favoriteImage,
                            width: 60,
                          ),
                        ),

                        //chat button
                        GestureDetector(
                          onTap: () {},
                          child: Image.asset(
                            AppConstant.chatImage,
                            width: 90,
                          ),
                        ),

                        //like button
                        GestureDetector(
                          onTap: () {},
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
        );
      }),
    );
  }
}
