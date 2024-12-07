import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool original = true;
  bool frame1 = false;
  bool frame2 = false;
  bool frame3 = false;
  bool frame4 = false;
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
        return; // Permission granted
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Permission denied to access storage')),
        // );
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
          // _isImageSelected = true;
        });
        _showImageDialog();
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

  void _showImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'Uploaded Image',
                style: TextStyle(fontSize: 28),
              ),
              SizedBox(
                height: 10,
              ),
              if(original)
              Image.file(_image!),
              if(frame1)
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/frame_1.png'),fit: BoxFit.cover)
                  ),
                  child: Image.file(_image!),
                ),
              const SizedBox(height: 10),
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            'Original',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black.withOpacity(0.7)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          frame1 = true;
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/frame_1.png',
                            fit: BoxFit.contain,
                            height: 25,
                            width: 25,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/frame_2.png',
                            fit: BoxFit.contain,
                            height: 25,
                            width: 25,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/frame_3.png',
                            fit: BoxFit.contain,
                            height: 25,
                            width: 25,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/frame_4.png',
                            fit: BoxFit.contain,
                            height: 25,
                            width: 25,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isImageSelected = true;
                    Navigator.of(context).pop();
                  });
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
                      'Use this image',
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: IconButton(
              onPressed: () {}, icon: Icon((Icons.arrow_back_ios), size: 35)),
        ),
        elevation: 10,
        backgroundColor: Colors.white,
        title: Text(
          'Add Image / Icon',
          style: TextStyle(
              fontSize: 28,
              fontStyle: FontStyle.italic,
              color: Colors.black.withOpacity(0.6)),
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
                  height: size.height * 0.4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(File(_image!.path)),
                        fit: BoxFit.cover),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
