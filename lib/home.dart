import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mycontactapp/contactlist.dart';
import 'package:mycontactapp/entity/mycontact.dart';
import 'package:mycontactapp/logger/mylogger.dart';
import 'package:mycontactapp/newcontact.dart';
import 'package:mycontactapp/utils/util.dart';
// import 'package:uuid/uuid.dart';
import './detail.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Box<MyContact> box = Hive.box(DB);
  MyLogger logger = MyLogger("_MyHomePageState", "");
  late List<MyContact> contactList;
  late List<MyContact> favorites;
  AudioPlayer player=AudioPlayer();
  List<MyContact> favoritesList(List<MyContact> contacts) {
    List<MyContact> favorites = [];
    for (MyContact c in contacts) {
      if (c.isFavorite) {
        favorites.add(c);
      }
    }
    return favorites;
  }

  @override
  Widget build(BuildContext context) {
    contactList = box.values.toList();
    favorites = favoritesList(contactList);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Container(
        padding: EdgeInsets.only(top: 22),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 80,
              child: Stack(
                children: [
                  favorites.length == 0
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          child:
                              Center(child: Text("Add favorites contact here")),
                        )
                      : ValueListenableBuilder(
                          valueListenable: box.listenable(),
                          builder: (context,Box<MyContact> contactsBox, child) {
                            favorites = favoritesList(contactsBox.values.toList());
                            return ListView.builder(
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 80,
                                  width: 80,
                                  margin: EdgeInsets.symmetric(horizontal: 1),
                                  // decoration: BoxDecoration(shape: BoxShape.circle),
                                  child: OpenContainer(
                                    // closedColor: Colors.teal,
                                    closedShape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    transitionDuration:
                                        Duration(milliseconds: 350),
                                    transitionType:
                                        ContainerTransitionType.fade,
                                    closedBuilder: (context, closeContainer) {
                                      return favorites[index].picture != ""
                                          ? Image.file(
                                              File(favorites[index].picture!),
                                              fit: BoxFit.cover,
                                            )
                                          : Image(
                                              image: AssetImage(
                                                  "assets/img/defaultpic.png"),
                                              fit: BoxFit.cover,
                                            );
                                    },
                                    openBuilder: (context, openContainer) {
                                      return DetailPage(favorites[index]);
                                    },
                                  ),
                                );
                              },
                              itemCount: favorites.length,
                              scrollDirection: Axis.horizontal,
                            );
                          },
                        ),
                  Positioned(
                      right: 0,
                      child: TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ContactList()));
                        },
                        child: Container(
                          margin: EdgeInsets.zero,
                          child: Center(
                            child: Text("more"),
                          ),
                          width: 80,
                          height: 80,
                          color: Colors.black.withOpacity(.7),
                        ),
                      )),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<Iterable<CallLogEntry>>(
                future: loadingCallLogs(),
                builder: (context, snapShop) {
                  if (snapShop.hasData) {
                    List<CallLogEntry> callLogs = snapShop.data!.toList();
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        CallLogEntry log = callLogs[index];
                        return Slidable(
                          child: ListTile(
                            leading: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.only(topRight: Radius.)),
                                border:
                                    Border.all(width: 2, color: Colors.indigo),
                                shape: BoxShape.circle,
                                image: isContain(log.number!) &&
                                        getImagePath(log.number!) != ""
                                    ? DecorationImage(
                                        image: FileImage(
                                          File(
                                            getImagePath(log.number!),
                                          ),
                                        ),
                                        fit: BoxFit.cover)
                                    : DecorationImage(
                                        image:
                                            AssetImage("assets/img/defaultpic.png"),
                                        fit: BoxFit.cover),
                              ),
                            ),
                            title: Text(
                              "${log.number}",
                              style: TextStyle(fontSize: 22),
                            ),
                            subtitle: Row(
                              children: [
                                callType(log.callType),
                                Text("${fmtTime(log.timestamp)}")
                              ],
                            ),
                            trailing: IconButton(
                              icon: isContain(log.number!)
                                  ? Image(
                                      image:
                                          AssetImage("assets/img/speaker.png"),
                                    )
                                  : Icon(Icons.add),
                              onPressed: isContain(log.number!)
                                  ? () async {
                                      String audioPath =
                                          getAudioNamePath(log.number!);
                                      logger.log(audioPath);
                                      if (audioPath != " ") {
                                        File f = File(audioPath);
                                        if (await f.exists()) {
                                          logger.log("play audio");
                                          player.play(audioPath,isLocal: true);
                                        }
                                      }
                                    }
                                  : () {
                                      logger.log("add new ");
                                      Navigator.of(context)
                                          .push(MaterialPageRoute<MyContact>(
                                              builder: (context) =>
                                                  NewContact(log.number!)))
                                          .then((value) {
                                        if (value != null) {
                                          setState(() {
                                            contactList.add(value);
                                            box.put(value.uuid, value);
                                          });
                                        }
                                        logger.log(
                                            box.values.toList().toString());
                                      });
                                    },
                            ),
                          ),
                          actionPane: SlidableDrawerActionPane(),
                          secondaryActions: [
                            IconButton(
                              icon: Icon(
                                Icons.call,
                                size: 28,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                FlutterPhoneDirectCaller.callNumber(contactList[index].numbers!.first);                                
                              },
                            )
                          ],
                        );
                      },
                      itemCount: callLogs.length,
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Iterable<CallLogEntry>> loadingCallLogs() {
    return CallLog.query(
        dateFrom:
            DateTime.now().subtract(Duration(days: 200)).millisecondsSinceEpoch,
        dateTo: DateTime.now().millisecondsSinceEpoch);
  }

  String fmtTime(int? time) {
    var t = DateTime.fromMillisecondsSinceEpoch(time!);
    return "${t.day}/${t.month}/${t.year}";
  }

  bool isContain(String number) {
    for (MyContact c in contactList) {
      for (String ph in c.numbers!) {
        if (ph == number) {
          return true;
        }
      }
    }
    return false;
  }

  String getAudioNamePath(String number) {
    for (MyContact c in contactList) {
      for (String ph in c.numbers!) {
        if (ph == number) return c.audioName!;
      }
    }
    return "";
  }

  String getImagePath(String number) {
    for (MyContact contact in contactList) {
      for (String ph in contact.numbers!) {
        if (ph == number) {
          return contact.picture!;
        }
      }
    }
    return "";
  }

  Widget callType(CallType? ct) {
    switch (ct) {
      case CallType.missed:
        return Icon(Icons.call_missed, color: Colors.red);
      case CallType.outgoing:
        return Icon(
          Icons.call_made_rounded,
          color: Colors.green,
        );
      case CallType.rejected:
        return Icon(
          Icons.call_missed_outgoing_rounded,
          color: Colors.red,
        );
      case CallType.incoming:
        return Icon(
          Icons.call_received_rounded,
          color: Colors.green,
        );
      case CallType.blocked:
        return Icon(Icons.block);
      default:
        return Container();
    }
  }
}
