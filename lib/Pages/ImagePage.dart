import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';

class ImagePickCrop extends StatefulWidget {
  @override
  State<ImagePickCrop> createState() => _ImagePickCropState();
}

class _ImagePickCropState extends State<ImagePickCrop> {
  File? imageFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('imagePick')),
        body: Container(
            child: imageFile == null
                ? Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          color: Color(0XFF307777),
                          onPressed: () {
                            _getFromGallery();
                          },
                          child: Text(
                            "PICK FROM GALLERY",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    child: Image.file(
                      imageFile!,
                      fit: BoxFit.cover,
                    ),
                  )));
  }

  /// Get from gallery
  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    //_cropImage(pickedFile!.path);
  }

  /// Crop Image
  /*_cropImage(filePath) async {
    File? croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    if (croppedImage != null) {
      imageFile = croppedImage;
      setState(() {});
    }
  }*/
}
