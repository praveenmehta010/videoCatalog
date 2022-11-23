import 'package:better_player/better_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:new_project/video.dart/video.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class ViewVideoScreen extends StatefulWidget {
  final String Id;

  ViewVideoScreen({Key? key, required this.Id}) : super(key: key);

  @override
  _ViewVideoScreenState createState() => _ViewVideoScreenState();
}

class _ViewVideoScreenState extends State<ViewVideoScreen> {
  bool loading = false;
  bool likeOption = false;
  bool disLikeOption = false;
  var likeCount = 0;
  var disLikeCount = 0;
  final searchController = TextEditingController();
  final id = 1;

  final dataBaseVideoBarRef = FirebaseDatabase.instance.ref("VideoBarData");
  final dataBaseRef = FirebaseDatabase.instance.ref("PostedData");
  late final snapshot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("View Video Screen "),
      ),
      body: Column(
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
          Container(
            height: 400,
            color: Colors.black,
            child: FirebaseAnimatedList(
              query: dataBaseRef,
              itemBuilder: (context, snapshot, animation, index) {
                final videoTitle =
                    snapshot.child('video_Title').value.toString();
                final videoCategory =
                    snapshot.child("video_category").value.toString();
                final videoId = snapshot.child('video_Id').value.toString();
                var videoURL = snapshot.child('link').value.toString();
                var mylikeCount = 0;
                return widget.Id == videoId
                    ? Column(
                        children: [
                          VideoPlayerView(
                            url: videoURL,
                            dataSourceType: DataSourceType.network,
                          ),
                          Container(
                            height: 150,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8, right: 8, top: 8),
                              child: Column(
                                children: [
                                  Card(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          videoTitle,
                                          style: TextStyle(
                                            fontSize:40,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          "Views",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          videoCategory,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          "DaysAgo",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Card(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          likeOption
                                              ? IconButton(
                                                  color: Colors.blue,
                                                  onPressed: () {
                                                    setState(() {
                                                      likeCount--;
                                                      likeOption = false;
                                                    });
                                                    dataBaseVideoBarRef
                                                        .child(id.toString())
                                                        .set({
                                                      'likeCount':
                                                          likeCount.toString(),
                                                    });
                                                  },
                                                  icon: Icon(Icons.thumb_up),
                                                )
                                              : IconButton(
                                                  onPressed: () {
                                                    if (disLikeOption) {
                                                      setState(() {
                                                        disLikeOption = false;
                                                        disLikeCount--;
                                                      });
                                                      dataBaseVideoBarRef
                                                          .child(id.toString())
                                                          .set({
                                                        'likeCount': likeCount
                                                            .toString(),
                                                        'dislikeCount':
                                                            disLikeCount
                                                                .toString(),
                                                      });
                                                    }
                                                    setState(() {
                                                      likeCount++;
                                                      likeOption = true;
                                                    });
                                                    dataBaseVideoBarRef
                                                        .child(id.toString())
                                                        .set({
                                                      'likeCount':
                                                          likeCount.toString(),
                                                    });
                                                  },
                                                  icon: Icon(Icons.thumb_up),
                                                ),
                                          Text(likeCount.toString()),
                                          disLikeOption
                                              ? IconButton(
                                                  color: Colors.blue,
                                                  onPressed: () {
                                                    setState(() {
                                                      disLikeCount--;
                                                      disLikeOption = false;
                                                    });
                                                    dataBaseVideoBarRef
                                                        .child(id.toString())
                                                        .set({
                                                      'dislikeCount':
                                                          likeCount.toString(),
                                                    });
                                                  },
                                                  icon: Icon(Icons.thumb_down),
                                                )
                                              : IconButton(
                                                  onPressed: () {
                                                    if (likeOption) {
                                                      setState(() {
                                                        likeCount--;
                                                        likeOption = false;
                                                      });
                                                      dataBaseVideoBarRef
                                                          .child(id.toString())
                                                          .set({
                                                        'likeCount': likeCount
                                                            .toString(),
                                                        'dislikeCount':
                                                            disLikeCount
                                                                .toString(),
                                                      });
                                                    }

                                                    setState(() {
                                                      disLikeCount++;
                                                      disLikeOption = true;
                                                    });
                                                    dataBaseVideoBarRef
                                                        .child(id.toString())
                                                        .set({
                                                      'dislikeCount':
                                                          disLikeCount
                                                              .toString(),
                                                    });
                                                  },
                                                  icon: Icon(Icons.thumb_down),
                                                ),
                                          Text(disLikeCount.toString()),
                                          IconButton(
                                              onPressed: () {
                                                Share.share(videoURL);
                                              },
                                              icon: Icon(Icons.share))
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container();
              },
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
              query: dataBaseRef,
              itemBuilder: (context, snapshot, animation, index) {
                final mytitle = snapshot.child('video_Title').value.toString();
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
                } else if (mytitle
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase().toString())) {
                  return InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewVideoScreen(
                            Id: snapshot.child('value_Id').value.toString()),
                      ),
                    ),
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
          ),
        ],
      ),
    );
  }
}
