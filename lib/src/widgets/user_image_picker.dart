import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../helpers/app_colors.dart';


class UserImagePicker extends StatefulWidget {
  var imgFunction;
  var avatar;

  UserImagePicker({
    this.imgFunction,
    required this.avatar,

  });

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? imageFile;

  // final formKey = GlobalKey<>();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        imageFile != null
            ? Container(
                width: 50,
                height: 50,
                child: ClipOval(
                  child: imageFile == null
                      ?SizedBox.shrink()
                      : Image.file(
                          imageFile!,
                          fit: BoxFit.cover,
                        ),
                ),
              )
            : InkWell(
                onTap: () {
                  imagePickerOption(context);
                },
                child:
                Icon( Icons.camera_enhance_sharp,
                  color: Colors.white,),
                // Stack(
                //   children: [
                //     Container(
                //       decoration: BoxDecoration(
                //           shape: BoxShape.circle,
                //           border: Border.all(
                //             width: 2,
                //             color: Colors.white,
                //           )),
                //       height: 50,
                //       width: 50,
                //       child: Icon(
                //         Icons.person,
                //         size: 40,
                //         color:Colors.blue.withOpacity(0.5),
                //       ),
                //     ),
                //     Positioned(
                //         right: 0,
                //         bottom: 0,
                //         child: Icon(
                //           Icons.add_circle,
                //           size: 22,
                //           color:Colors.blue.withOpacity(0.5),
                //         )),
                //   ],
                // ),
              ),

        // ElevatedButton.icon(
        //   onPressed: () {
        //     imagePickerOption(context);
        //   },
        //   icon: Icon(Icons.image),
        //   label: Text('Add Image'),
        // ),
      ],
    );
  }

  imagePickerOption(context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return Container(
         decoration: BoxDecoration(
           color: AppColors.DARK_ORANGE,
           // borderRadius: BorderRadius.only(
           //   topLeft: Radius.circular(20.0),
           //   topRight: Radius.circular(20.0),
           // ),
         ),
          height: 250,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    "Pick Image From",
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).highlightColor,
                  ),
                  onPressed: () {
                    pickImage(ImageSource.camera, context);
                  },
                  icon: Icon(
                    Icons.camera,
                    // color: Theme.of(context).highlightColor,
                  ),
                  label: Text(
                    "Camera",
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).highlightColor,
                  ),
                  onPressed: () {
                    pickImage(ImageSource.gallery, context);
                  },
                  icon: Icon(Icons.image),
                  label: Text("Gallery"),
                ),
                SizedBox(
                  height: 0,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).highlightColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                  label: Text("Cancel"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  pickImage(ImageSource imageType, context) async {
    final ImagePicker _picker = ImagePicker();
    try {
      final photo = await _picker.pickImage(source: imageType);
      if (photo == null) return;
      setState(() {
        imageFile = File(photo.path);
        widget.imgFunction(imageFile);
      });
      Navigator.pop(context);
    } catch (error) {
      print(error);
    }
  }
}
