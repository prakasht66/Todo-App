import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iostest/constants.dart';
import 'package:iostest/designComponents/Input_text.dart';
import 'package:iostest/designComponents/base_template.dart';

import '../designComponents/space.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var aboutTC = TextEditingController();
  File? imageFile;
  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      leadingIcon: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          )),
      trailingIcon: const SizedBox(),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
          child:  Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: spacing_x_large,
                    horizontal: spacing_small,
                  ),
                  child:   Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: imageFile != null ? Image.file(
                        imageFile!,
                        fit: BoxFit.cover,
                      ).image: null ,
                      child: imageFile !=null ? SizedBox():Icon(Icons.person_outline,size: 80,color: Colors.black12,),
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ),
                Positioned(
                    top: 100,
                    right: 160,
                    child: Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      width: 40,
                      height: 40,
                      child: SizedBox(),
                    )),
                Positioned(
                    top: 105,
                    right: 165,
                    child: Container(
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      width: 30,
                      height: 30,
                      child: InkWell(
                        onTap: () async {
                          await _pickImageFromGallery();

                          print('ifdsgfuds');
                        },
                        child: const CircleAvatar(
                          backgroundColor: Colors.black,
                          child: Icon(
                            Icons.edit_note_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )),


            Container(
              margin: EdgeInsets.only(top: 150),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      'Hey Buddy',
                      style: TextStyle(
                          color: kPrimary,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 22),
                    ),
                  ),
                  VSpace(
                    size: spacing_small,
                  ),
                  Container(
                    height: 150.0,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(color: kPrimary)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: TextField(
                            maxLines: 5,
                            controller: aboutTC,
                            decoration: const InputDecoration(
                                hintStyle: TextStyle(
                                  height:
                                  2.0, // sets the distance between label and input
                                ),
                                // needed to create space between label and input
                                border: InputBorder.none,
                                hintText: 'Write something about you...',
                                labelStyle: TextStyle(color: Colors.grey)),
                          )),
                    ),
                  ),
                  VSpace(size: spacing_xx_large),
                  Center(child: _submitButton())
                ],
              ),
            ),


          ]),


      ),
    );
  }

  Future _pickImageFromGallery() async
  {
    try
    {
      final ImagePicker _picker = ImagePicker();

      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return ;
      imageFile = File(image.path);
      setState(() {

      });
    }
    on PlatformException catch (e){
          print('Failed to pick image $e');
    }


  }




Widget _submitButton() {
    return Center(
      child: SafeArea(
        child: SizedBox(
          width: 150.0,
          child: ElevatedButton(
              onPressed: () {},
              // onPressed: () async {
              //   var isValid = validateInputs();
              //   if (isValid) {
              //     await addTask();
              //   }
              // },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(kPrimary),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
              child: Text('Save')),
        ),
      ),
    );
  }
}
