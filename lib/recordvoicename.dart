
import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:mycontactapp/logger/mylogger.dart';

class RecordVoiceName extends StatefulWidget{
   final String phoneNumber;
   final String appPath;
   final bool isNew;
   RecordVoiceName(this.phoneNumber,this.appPath,this.isNew);
  _RecordVoiceNameState createState()=> _RecordVoiceNameState(phNumber: phoneNumber,appdirpath: appPath,isNew: isNew);
}
class _RecordVoiceNameState extends State<RecordVoiceName>{
  String phNumber;
  String appdirpath;
  late MyLogger logger;
  bool isNew;
    FlutterAudioRecorder2? _recorder2;
    Recording? _current;
  RecordingStatus _currentStats = RecordingStatus.Unset;
 AudioPlayer player=AudioPlayer();
   _RecordVoiceNameState(
      {required this.phNumber,
      required this.appdirpath,
      required this.isNew});

  void initState() {
    super.initState();
     logger = new MyLogger(" RecordAduioButtonSheet ",appdirpath);
     logger.log(phNumber);
    _init();
  }

  void dispose() {
    super.dispose();
    
    // player.dispose();
  }

  void _init() async {
    try {
      bool? hasPermission = await FlutterAudioRecorder2.hasPermissions;
      // var hasStoragePermission = await Permission.storage.request();

      if (hasPermission!) {
        var fileName = appdirpath + "/" + phNumber;
        //If It isn't new make update file
        if (!isNew) {
          fileName += "_tempupdate";
        }
        File audioFile = File(fileName + ".wav");
        if (await audioFile.exists()) {
          await audioFile.delete();
        }
        _recorder2 =new FlutterAudioRecorder2(fileName, audioFormat: AudioFormat.WAV,);
        //initialize recorder
        await _recorder2?.initialized;
        //get current from _recorder2
        var current = await _recorder2!.current(channel: 0);
        // print(current);
        //setState  current to _current
        //set Current Stats
        setState(() {
          _current = current!;
          _currentStats = current.status!;
          // print(_currentStats);
        });
      } else {
        // if permission is not granted
        // we are not allow to record audio
        logger.logErr(" Permission is Not Granted !");
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Permission is not granted!")));
        Navigator.pop(context, false);
      }
    } catch (e) {
      logger.logErr(e.toString());
      //print("Error on Catch ${e.toString()}");
    }
  }

  _reset() async {
    if (_currentStats == RecordingStatus.Stopped) {
      //print("Recording Stop ...");
      if (isNew) {
        File audioFile =new File(appdirpath + "/" + phNumber + ".wav");
        if (await audioFile.exists()) {
          await audioFile.delete();
        }
      } else {
        File audioFile =new File(appdirpath + "/" + phNumber + "_tempupdate" + ".wav");
        if (await audioFile.exists()) {
          await audioFile.delete();
        }
      }
      _init();
    }
  }

  _start() async {
    try {
      await _recorder2!.start();
      var recording = await _recorder2!.current(channel: 0);
      setState(() {
        _current = recording!;
      });

      const tick = const Duration(milliseconds: 5);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStats == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder2!.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current!;
          _currentStats = _current!.status!;
        });
      });
      //set durtion for 6 sec
      const d_tostop=const Duration(seconds:6);
      //we only allow user to record for 6 sec
      //set a time for recording
      //after 6 sec if user doesn't stop we stop it
      new Timer(d_tostop, () async {
        if (_currentStats == RecordingStatus.Recording) {
          _stop();
        }
      });
    } catch (e) {
      logger.logErr(e.toString());
      // print(e);
    }
  }

  _stop() async {
    var result = await _recorder2!.stop();
    setState(() {
      _current = result!;
      _currentStats = _current!.status!;
    });
  }

  bool isRecording() {
    if (_currentStats == RecordingStatus.Recording ||
        _currentStats == RecordingStatus.Paused) {
      return true;
    }
    return false;
  }

  Widget displayFileName(String filePath) {
    List<String> names = filePath.split("/");
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(names[names.length - 1].substring(0,10)+".wav"),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: _reset,
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    double fullheight = MediaQuery.of(context).size.height;
    double halfHeight = fullheight / 2;
    return new WillPopScope(
      onWillPop: () async => false,
      child: new Container(
        height: fullheight / 3,
        decoration: new BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black, offset: new Offset(0.0, -0.4), blurRadius: 3.0)
        ]),
        child: new Column(
          children: [
            new Flexible(
                child: new Container(
              padding: new EdgeInsets.only(top: 10, bottom: 10),
              // height: halfheight / 4,
              width: MediaQuery.of(context).size.width,
              child: new Text(
                "Record voice for $phNumber",
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
            )),
            new Flexible(
              flex: 1,
              child:new Container(
                child:new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                   new Flexible(
                      flex: 1,
                      child: new MyRrecordAudioButtonAction(
                          text: "Start",
                          bgColor: isRecording() ||
                                  _currentStats == RecordingStatus.Stopped
                              ? Colors.blue.withOpacity(.5)
                              : Colors.blue,
                          onClick: isRecording() ||
                                  _currentStats == RecordingStatus.Stopped
                              ? (){}
                              : () {
                                  _start();
                                }),
                    ),
                    new Flexible(
                      flex: 1,
                      child: new MyRrecordAudioButtonAction(
                        text: "Stop",
                        bgColor: isRecording()
                            ? Colors.blue
                            : Colors.blue.withOpacity(.5),
                        onClick: isRecording() ? _stop : (){},
                      ),
                    ),
                    new Flexible(
                      flex: 1,
                      child: new MyRrecordAudioButtonAction(
                          bgColor: _currentStats == RecordingStatus.Stopped
                              ? Colors.blue
                              : Colors.blue.withOpacity(.5),
                          text: "Play",
                          onClick: _currentStats == RecordingStatus.Stopped
                              ? () {
                                  onPlayAudio();
                                }
                              : (){},
                    ),
                    ),
                  ],
                ),
              ),
            ),
            new Container(
              height: halfHeight / 4,
              width: MediaQuery.of(context).size.width,
              // color: Colors.blue,
              child: _currentStats == RecordingStatus.Stopped
                  ? Center(child: displayFileName("${_current?.path}"))
                  : Center(
                      child: Text("${_current?.duration}"),
                    ),
            ),
            new Expanded(
              child: new Container(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    new Flexible(
                      flex: 1,
                      child: new MyRrecordAudioButtonAction(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 50,
                          bgColor: isRecording() ||
                                  _currentStats != RecordingStatus.Stopped
                              ? Colors.red.withOpacity(.5)
                              : Colors.red,
                          text: "Close",
                          color: Colors.white,
                          onClick: isRecording() ||
                                  _currentStats != RecordingStatus.Stopped
                              ? (){}
                              : () {
                                  //print("Pop without saving...");
                                  Navigator.pop(context, false);
                                }),
                    ),
                    new Flexible(
                      flex: 1,
                      child: new MyRrecordAudioButtonAction(
                          bgColor: isRecording() ||
                                  _currentStats != RecordingStatus.Stopped
                              ? Colors.green.withOpacity(.5)
                              : Colors.green,
                          width: MediaQuery.of(context).size.width / 3,
                          height: 50,
                          text: "Save",
                          color: Colors.white,
                          onClick: isRecording() ||
                                  _currentStats != RecordingStatus.Stopped
                              ? (){}
                              : () {
                                  Navigator.pop(context, true);
                                }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onPlayAudio() async {
    logger.log(_current!.path!);
    await player.play(_current!.path!,isLocal: true);
      }
}

class MyRrecordAudioButtonAction extends StatelessWidget {
  final String text;
  final VoidCallback onClick;
  final double width;
  final double height;
  final Color bgColor;
  final Color color;
  MyRrecordAudioButtonAction(
      {required this.text,
      required this.onClick,
      this.width = 80,
      this.height = 30,
      this.color = Colors.white,
      this.bgColor = Colors.blue});
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(50)),
      child: new TextButton(
        child: new Text(
          text,
          style: new TextStyle(color: color),
        ),
        onPressed: onClick,
      ),
      height: height,
      width: width,
    );
  }
}
