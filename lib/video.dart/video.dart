import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatefulWidget {
  final String url;
  final DataSourceType dataSourceType;
  const VideoPlayerView({
    Key? key, 
    required this.url, 
    required this.dataSourceType
    }) : super(key: key);

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.url);
    chewieController = ChewieController(videoPlayerController: videoPlayerController,
    aspectRatio: 16/9,
    );
  }
  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.dataSourceType.name.toUpperCase(),),
        Divider(),
        AspectRatio(aspectRatio: 16/9,
        child: Chewie(controller: chewieController),
        )
      ],
    );
  }
}