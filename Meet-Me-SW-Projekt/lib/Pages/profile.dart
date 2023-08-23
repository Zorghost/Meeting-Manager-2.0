import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../models/user_model.dart';

///this Class extends the profile info of the current user
class profile extends StatefulWidget {

  final User user ;
  profile(this.user);

  @override
  State<profile> createState() => _profileState();
}
///this class extends the state of the profile page and where all the widgets will be built
class _profileState extends State<profile> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile'),
        backgroundColor: Color(0xFF4B39EF),
      ),
        body: profileView(),
      );
    }
  Widget profileView() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(),
          child: Stack(
            children: [
              CircleAvatar(
                radius: 75,
                backgroundImage: AssetImage('assets/images/logo-meet-me.png'),
                child: ClipOval(
                    child: image == null ? Text("") : Image.file(File(image!.path),width: 250,fit: BoxFit.cover,)
                ),
              ),
              Positioned(
                bottom: 1,
                right: 1,
                child: IconButton(
                  icon: const Icon(Icons.add_a_photo_outlined),
                  color: Colors.black,
                  onPressed: () {
                    _showPicker(context);
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: widget.user.name,
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: widget.user.email,
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                maxLines: 5,
                maxLength: 100,
                decoration: InputDecoration(
                  labelText: 'About your self',
                  border: OutlineInputBorder(),
                ),
              ),
            ],

          ),
        )
        )
      ],

    );
  }
  ///this function is to pick a photo from the Camera or Gallery for the profile photo
  void _showPicker(context) {
    showModalBottomSheet(context: context, builder: (BuildContext bc) {
      return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  _imageFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Camera'),
                onTap: () {
                  _imageFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          )
      );
    });
  }
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  Future<void> _imageFromCamera() async {
    final XFile? selectImage = await _picker.pickImage(source: ImageSource.camera);
    print(selectImage!.path);
    setState((){
      image = selectImage;
    });
  }

  Future<void> _imageFromGallery() async {
    final XFile? selectImage = await _picker.pickImage(source: ImageSource.gallery);
    print(selectImage!.path);
    setState((){
      image = selectImage;
    });
  }
  }
