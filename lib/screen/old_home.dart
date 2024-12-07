import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class OldHomePage extends StatefulWidget {
  @override
  _OldHomePageState createState() => _OldHomePageState();
}

class _OldHomePageState extends State<OldHomePage> {
  late File _image;
  bool _isImageSelected = false;

  // Image editing flags
  bool _isFlipped = false;
  double _rotationAngle = 0;
  final ImagePicker _picker = ImagePicker();

  // Method to pick image from gallery
  _getImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _isImageSelected = true;
      });
    }
  }

  // Crop image
  Future<void> _cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image.path,

    );
    if (croppedFile != null) {
      setState(() {
        _image = File(croppedFile.path);
      });
    }
  }

  // Rotate image
  void _rotateImage() {
    setState(() {
      _rotationAngle += 90;
      if (_rotationAngle >= 360) _rotationAngle = 0;
    });
  }

  // Flip image
  void _flipImage() {
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  // Show Image in AlertDialog
  void _showImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.rotate(
                angle: _rotationAngle * 3.14159 / 180,
                child: _isFlipped
                    ? Transform.scale(scaleX: -1, child: Image.file(_image))
                    : Image.file(_image),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite),
                    onPressed: () {
                      // Wrap the image with love frame
                      Fluttertoast.showToast(msg: "Image inside love framework!");
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.circle),
                    onPressed: () {
                      // Wrap the image inside circle framework
                      Fluttertoast.showToast(msg: "Image inside circle framework!");
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.crop_square),
                    onPressed: () {
                      // Wrap the image inside square framework
                      Fluttertoast.showToast(msg: "Image inside square framework!");
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.crop_rounded),
                    onPressed: () {
                      // Wrap the image inside rectangle framework
                      Fluttertoast.showToast(msg: "Image inside rectangle framework!");
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Editing App"),
        actions: [
          if (_isImageSelected)
            IconButton(
              icon: const Icon(Icons.crop),
              onPressed: _cropImage,
            ),
          if (_isImageSelected)
            IconButton(
              icon: const Icon(Icons.rotate_right),
              onPressed: _rotateImage,
            ),
          if (_isImageSelected)
            IconButton(
              icon: const Icon(Icons.flip),
              onPressed: _flipImage,
            ),
        ],
      ),
      body: Center(
        child: _isImageSelected
            ? GestureDetector(
          onTap: _showImageDialog,
          child: Transform.rotate(
            angle: _rotationAngle * 3.14159 / 180,
            child: _isFlipped
                ? Transform.scale(scaleX: -1, child: Image.file(_image))
                : Image.file(_image),
          ),
        )
            : ElevatedButton(
          onPressed: _getImageFromGallery,
          child: const Text("Choose from Device"),
        ),
      ),
    );
  }
}