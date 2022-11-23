import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:new_project/auth/entryPoint.dart';
import 'package:new_project/auth/viewVideo.dart';
import 'package:new_project/services/postVideo.dart';
import 'package:new_project/widgets/customMessage.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  final searchController = TextEditingController();
  
  // instance for realtime database
  final dataBaseRef = FirebaseDatabase.instance.ref("PostedData");
  final _auth = FirebaseAuth.instance;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Home Screen "),
        actions: [
          IconButton(
              onPressed: () {
                _auth.signOut().then(
                  (value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EntryScreen(),
                      ),
                    );
                  },
                ).onError(
                  (error, stackTrace) {
                    CustomMsg().customMsg(
                      error.toString(),
                    );
                  },
                );
              },
              icon: Icon(Icons.logout_outlined))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostVideoScreen(),
            ),
          );
        },
      ),
      body: Container(
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
            Expanded(
              child: FirebaseAnimatedList(
                query: dataBaseRef,
                itemBuilder: (context, snapshot, animation, index) {
                  final mytitle =
                      snapshot.child('video_Title').value.toString();
                  VideoPlayerController videoController = VideoPlayerController
                      .network(snapshot.child('video_URL').value.toString())
                    ..initialize();
                  final Id = snapshot.child('video_Id').value.toString();  

                  if (searchController.text.isEmpty) {
                    return InkWell(
                      onTap: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewVideoScreen(Id: Id),
                          ),
                        );
                      },
                      child: Card(
                        shadowColor: Colors.blue,
                        elevation: 20,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                height: 150,
                                width: 150,
                                child: AspectRatio(
                                    aspectRatio:
                                        videoController.value.aspectRatio,
                                    child: VideoPlayer(videoController)),
                              ),
                              Container(
                                color: Colors.lightBlueAccent,
                                width: 200,
                                height: 150,
                                margin: EdgeInsets.only(left: 10),
                                // padding: EdgeInsets.all(value),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot
                                          .child('video_Title')
                                          .value
                                          .toString(),
                                      style: TextStyle(fontSize: 40),
                                    ),
                                    Text(
                                      snapshot
                                          .child('video_description')
                                          .value
                                          .toString(),
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      snapshot
                                          .child('video_category')
                                          .value
                                          .toString(),
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    Text(
                                      "Latitude :- ${snapshot.child('location_latitude').value.toString()}",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    Text(
                                      "Longitude :- ${snapshot.child('location_longitude').value.toString()}",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if (mytitle.toLowerCase().contains(
                      searchController.text.toLowerCase().toString())) {
                    return InkWell(
                      // onTap: () => 
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => ViewVideoScreen(Id: snapshot.child('value_Id').value.toString()),
                      //   ),
                      // ),
                      child: Card(
                        shadowColor: Colors.blue,
                        elevation: 20,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                color: Colors.blue,
                                height: 150,
                                width: 150,
                              ),
                              Container(
                                color: Colors.lightBlueAccent,
                                width: 200,
                                height: 150,
                                margin: EdgeInsets.only(left: 10),
                                // padding: EdgeInsets.all(value),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot
                                          .child('video_Title')
                                          .value
                                          .toString(),
                                      style: TextStyle(fontSize: 40),
                                    ),
                                    Text(
                                      snapshot
                                          .child('video_description')
                                          .value
                                          .toString(),
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      snapshot
                                          .child('video_category')
                                          .value
                                          .toString(),
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    Text(
                                      "Latitude :- ${snapshot.child('location_latitude').value.toString()}",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    Text(
                                      "Longitude :- ${snapshot.child('location_longitude').value.toString()}",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
