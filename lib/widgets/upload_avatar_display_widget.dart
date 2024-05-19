import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tinker_clone/global/app_constant.dart';

class UploadAvatarDisplayWidget extends StatelessWidget {
  final XFile? imageFile;
  const UploadAvatarDisplayWidget({super.key, this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          imageFile == null ?
          const CircleAvatar(
            radius: 80,
            backgroundImage: AssetImage(
                AppConstant.profileAvatar
            ),
            backgroundColor: Colors.black,
          ) :
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
                image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: FileImage(
                    File(
                      imageFile!.path,
                    ),
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }
}
