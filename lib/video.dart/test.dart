import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:new_project/video.dart/video.dart';
import 'package:video_player/video_player.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VideoPlayerView(
        url: 'https://rr2---sn-xmjpuxa-qxa6.googlevideo.com/videoplayback?expire=1668939912&ei=KKx5Y6ScJY_akAP237iQDw&ip=216.131.75.138&id=o-AAKjiq7qolXgAricQviVRN2uWeBHOKK64o9qb8ARjpqQ&itag=18&source=youtube&requiressl=yes&spc=SFxXNkGTamyhIuljDya0B7Ldj37ik3k&vprv=1&mime=video%2Fmp4&ns=yirpsivORmjOTbVLMO4-wLMJ&cnr=14&ratebypass=yes&dur=160.751&lmt=1664278027920696&fexp=24001373,24007246&c=WEB&txp=5538434&n=fgivr6kyVM0zpQ&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cspc%2Cvprv%2Cmime%2Cns%2Ccnr%2Cratebypass%2Cdur%2Clmt&sig=AOq0QJ8wRQIhAMcf4KHIluL60Koqcg3IcyNJrhgXfoMjziG-BFocqK4zAiAzVx3JY7006WpRweZQyqmOnjB3gYEczFI3svu5FBKM0A%3D%3D&redirect_counter=1&rm=sn-5uars7z&req_id=b742ae8accb2a3ee&cms_redirect=yes&ipbypass=yes&mh=9b&mip=103.212.145.235&mm=31&mn=sn-xmjpuxa-qxa6&ms=au&mt=1668918296&mv=m&mvi=2&pl=24&lsparams=ipbypass,mh,mip,mm,mn,ms,mv,mvi,pl&lsig=AG3C_xAwRAIgIN9ONj2Zrtx7DJbdzGM-ucoAGs485IFbklk5iNZBUc0CIGIuddy4hZKlOfx2Q9lRzcNE7loejcmVuvKKAwD_AXL4',
         dataSourceType: DataSourceType.network),
    );
  }
}