import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();
  double _rotationAngle = 0;
  bool _isFlipped = false;
  File? _image;
  bool _isImageSelected = false;
  String? imagePath;

  // Function to check and request permissions
  Future<void> _checkPermissions() async {
    // Check if storage permissions are granted
    var status = await Permission.storage.status;

    if (status.isGranted) {
      // Permission already granted
      return;
    } else if (status.isDenied) {
      // Request permission
      PermissionStatus newStatus = await Permission.storage.request();
      if (newStatus.isGranted) {
        return;  // Permission granted
      } else {
        // If permission denied, show a snackbar or toast
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permission denied to access storage')),
        );
      }
    } else if (status.isPermanentlyDenied) {
      // If permission is permanently denied, redirect user to settings
      openAppSettings();
    }
  }

  // Pick image and crop it
  void pickImage() async {
    // Check permissions first
    await _checkPermissions();

    // Pick image if permissions are granted
    XFile? imageFile = await _picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      imageFile = await cropImage(imageFile);
      if (imageFile != null) {
        setState(() {
          _image = File(imageFile!.path);
          _isImageSelected = true;
        });
      }
    }
  }

  // Crop the image
  Future<XFile?> cropImage(XFile imageFile) async {
    CroppedFile? croppedFile = await ImageCropper.platform.cropImage(
      sourcePath: imageFile.path,
      maxHeight: 800,
      maxWidth: 600,
      compressQuality: 70,
    );

    if (croppedFile != null) {
      return XFile(croppedFile.path);
    } else {
      return null;
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: IconButton(onPressed: () {}, icon: Icon((Icons.arrow_back_ios), size: 35)),
        ),
        elevation: 10,
        backgroundColor: Colors.white,
        title: Text(
          'Add Image / Icon',
          style: TextStyle(fontSize: 28, fontStyle: FontStyle.italic, color: Colors.black.withOpacity(0.6)),
        ),
        centerTitle: true,
        // actions: [
        //   if (_isImageSelected)
        //     TextButton(
        //       child: Text('CROP'),
        //       onPressed: () {},
        //     ),
        //   if (_isImageSelected)
        //     IconButton(
        //       icon: const Icon(Icons.rotate_right),
        //       onPressed: _rotateImage,
        //     ),
        //   if (_isImageSelected)
        //     IconButton(
        //       icon: const Icon(Icons.flip),
        //       onPressed: _flipImage,
        //     ),
        // ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Upload Image',
                      style: TextStyle(color: Colors.grey, fontSize: 22),
                    ),
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        pickImage();
                        print('click');
                      },
                      child: Container(
                        height: 50,
                        width: 230,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.teal,
                        ),
                        child: Center(
                          child: Text(
                            'Choose from Device',
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              SizedBox(height: 30),
              if (_isImageSelected)
                Container(
                  height: size.height*0.4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(File(_image!.path)),
                      fit: BoxFit.cover
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
