import 'dart:async';

import 'package:bluu/pages/chatscreens/widgets/cached_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:bluu/models/call.dart';
import 'package:bluu/resources/call_methods.dart';
import 'package:bluu/utils/permissions.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import '../videocall_screen.dart';
import '../voicecall_screen.dart';

class PickupScreen extends StatefulWidget {
  final Call call;

  PickupScreen({
    @required this.call,
  });

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final CallMethods callMethods = CallMethods();
  Connectivity connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> connectivitySubs;
  var connectivityStatus = 'Unknown';
  @override
  void initState() {
    super.initState();
    FlutterRingtonePlayer.playRingtone();
    connectivitySubs = connectivity.onConnectivityChanged
        .listen((ConnectivityResult result) async {
      connectivityStatus = result.toString();
      if (result == ConnectivityResult.none) {
        FlutterRingtonePlayer.stop();
        await callMethods.endCall(call: widget.call);
      }
    });
  }

  @override
  dispose() {
    connectivitySubs.cancel();
    FlutterRingtonePlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Incoming...",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(height: 30),
            CachedImage(
              widget.call.callerPic,
              isRound: true,
              radius: 150,
            ),
            SizedBox(height: 15),
            Text(
              widget.call.callerName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.call_end,
                    size: 32,
                  ),
                  color: Colors.redAccent,
                  onPressed: () async {
                    FlutterRingtonePlayer.stop();
                    await callMethods.endCall(call: widget.call);
                  },
                ),
                SizedBox(width: 64),
                IconButton(
                  icon: Icon(
                    Icons.call,
                    size: 32,
                  ),
                  color: Colors.green,
                  // onPressed: () async =>
                  //     await Permissions.cameraandmicrophonePermissionsGranted()
                  //         ? call.isCall == "video"
                  //             ? Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                   builder: (context) =>
                  //                       VideoCallScreen(call: call),
                  //                 ),
                  //               )
                  //             : Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                   builder: (context) =>
                  //                       VoiceCallScreen(call: call),
                  //                 ),
                  //               )
                  //         : {},
                  onPressed: () async {
                    FlutterRingtonePlayer.stop();
                    await callMethods.callCollection
                        .document(widget.call.callerId)
                        .setData({"has_accepted": true}, merge: true);
                    await callMethods.callCollection
                        .document((widget.call.receiverId))
                        .setData({"has_accepted": true}, merge: true);

                    return widget.call.isCall == "video"
                        ? await Permissions
                                .cameraandmicrophonePermissionsGranted()
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      VideoCallScreen(call: widget.call),
                                ),
                              )
                            : {}
                        : await Permissions.microphonePermissionsGranted()
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      VoiceCallScreen(call: widget.call),
                                ),
                              )
                            : {};
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
