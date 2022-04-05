import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageCompressor extends StatefulWidget {
  const ImageCompressor({Key? key}) : super(key: key);

  @override
  _ImageCompressorState createState() => _ImageCompressorState();
}

/*enum AppState {
  free,
  picked,
  cropped,
}*/

class _ImageCompressorState extends State<ImageCompressor> {
  //late AppState state;
  File? imageFile;

  // new stuff
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFileList = [];

  @override
  void initState() {
    super.initState();
    //state = AppState.free;
  }

  Future<File> customCompressed({
    @required File? imagePathtoCompress,
    quality = 100,
    percentage = 10,
  }) async {
    var path = await FlutterNativeImage.compressImage(
      imagePathtoCompress!.absolute.path,
      quality: 100,
      percentage: 10,
    );
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('crop image'),
      ),
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: _imageFileList!.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                /* Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            (ImageCrop(_imageFileList![index].path))));*/
              },
              child: Card(
                  elevation: 5.0,
                  child: Image.file(File(_imageFileList![index].path))),
            ),
          );
        },
        //   child: imageFile != null ? Image.file(imageFile!) : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          _pickImage();
          /* else if (state == AppState.picked)
            _cropImage();*/
        },
        child: _buildButtonIcon(),
      ),
    );
  }

  Widget _buildButtonIcon() {
    return Icon(Icons.add);
  }

  Future<Null> _pickImage() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      _imageFileList!.addAll(selectedImages);
    }
    /*final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    imageFile = pickedImage != null ? File(pickedImage.path) : null;*/
    if (_imageFileList != null) {
      setState(() {
        //  state = AppState.picked;
      });
    }
  }

  void _clearImage() {
    imageFile = null;
    setState(() {
      //   state = AppState.free;
    });
  }
}
