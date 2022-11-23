import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_project/widgets/customMessage.dart';
import 'package:new_project/widgets/myButton.dart';
import 'package:video_player/video_player.dart';

class PostVideoScreen extends StatefulWidget {
  const PostVideoScreen({Key? key}) : super(key: key);

  @override
  State<PostVideoScreen> createState() => _PostVideoScreenState();
}

class _PostVideoScreenState extends State<PostVideoScreen> {
  Position? _position;
  void _getCurrentLocation() async {
    Position position = await _determinePosition();
    setState(() {
      _position = position;
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }


  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final searchController = TextEditingController();
  final videoTitleControler = TextEditingController();
  final videoCategoryControler = TextEditingController();
  final dataBaseRef = FirebaseDatabase.instance.ref("PostedData");
  late VideoPlayerController _videoController;

  File? _videoFile;

  final picker = ImagePicker();

  // final _auth = FirebaseAuth.instance;
  final id = DateTime.now().millisecondsSinceEpoch.toString();

  postData() async {
    final storageDirRef =
        FirebaseStorage.instance.ref('VideoFolder/' + id);
    final uploadTask = storageDirRef.putFile(_videoFile!);

    // final snapshot = await uploadTask.whenComplete((){});
    Future.value(uploadTask)
    
    .then((value) async{ 
       var downloadUrl =  await storageDirRef.getDownloadURL();
      CustomMsg().customMsg("Video Uploaded");
      
      dataBaseRef.child(id).set({
      'video_Title': videoTitleControler.text.toString(),
      'video_category': videoCategoryControler.text.toString(),
      'video_URL' : downloadUrl.toString(),
      'video_Id' : id,
      'location_latitude': _position!.latitude.toString(),
      'location_longitude': _position!.longitude.toString(),
      'location_altitude': _position!.altitude.toString(),
      'location_accuracy': _position!.accuracy.toString(),
    });
      setState(() {
        loading = false;
      });
      Navigator.pop(context);
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      CustomMsg().customMsg(error.toString());
    });
    
  }

  _getVideo() async {
    final pickedvideoFile = await picker.pickVideo(source: ImageSource.camera);

    setState(() {
      if (pickedvideoFile != null) {
        _videoFile = File(pickedvideoFile.path);

        _videoController = VideoPlayerController.file(_videoFile!)
          ..initialize().then((_) {
            setState(() {});
            _videoController.play();
          });
      } else {
        print("No Video picked");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Post Video Screen "),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                    hintText: "Search",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(300))),
                onChanged: (String value) {
                  setState(() {});
                },
              ),
            ),
            Center(
              child: InkWell(
                onTap: () {
                  _getCurrentLocation();
                  _getVideo();
                },
                child: Container(
                  height: 250,
                  width: 250,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: _videoFile != null
                      ? AspectRatio(
                          aspectRatio: _videoController.value.aspectRatio,
                          child: VideoPlayer(_videoController),
                        )
                      : Icon(Icons.video_camera_back),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: videoTitleControler,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Video Title is a must";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "Video Title",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Video Category";
                        } else {
                          return null;
                        }
                      },
                      controller: videoCategoryControler,
                      // maxLines: 1,
                      decoration: InputDecoration(
                        hintText: "Video category",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            myButton(() async {
              setState(() {
                loading = true;
              });
              if (_formKey.currentState!.validate()) {
                if (_videoFile != null) {
                  postData();
                }
              }
            }, "Post", loading),
          ],
        ),
      ),
    );
  }
}
