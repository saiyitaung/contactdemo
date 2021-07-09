import 'dart:io';

import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mycontactapp/contactlist.dart';
import 'package:mycontactapp/entity/mycontact.dart';
import 'package:uuid/uuid.dart';
import './detail.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<MyContact> imgNames = [
    MyContact(
        Uuid().v4().toString(), "", ["0954858238"], "someaudiopath in future"),
    MyContact(
        Uuid().v4().toString(), "", ["0948275223"], "someaudiopath in future"),
    MyContact(
        Uuid().v4().toString(), "", ["0947717383"], "someaudiopath in future"),
    MyContact(
        Uuid().v4().toString(), "", ["09371563474"], "someaudiopath in future"), 
  ];
  @override
  Widget build(BuildContext context) {
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
                  ListView.builder(
                    itemBuilder: (context, index) {
                      return Hero(
                        tag: imgNames[index].uuid,
                        child:Container(
                        height: 80,
                        width: 80,
                        margin: EdgeInsets.symmetric(horizontal: 1),
                        // decoration: BoxDecoration(shape: BoxShape.circle),
                        child: OpenContainer(
                          // closedColor: Colors.teal,
                          closedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          transitionDuration: Duration(milliseconds: 350),
                          transitionType: ContainerTransitionType.fade,
                          closedBuilder: (context, closeContainer) {
                            return imgNames[index].picture != ""
                                ? Image.file(
                                    File(imgNames[index].picture),
                                    fit: BoxFit.cover,
                                  )
                                : Image(
                                    image:
                                        AssetImage("assets/img/defaultpic.png"),
                                    fit: BoxFit.cover,
                                  );
                          },
                          openBuilder: (context, openContainer) {
                            return DetailPage(imgNames[index]);
                          },
                        ),
                      ),);
                    },
                    itemCount: imgNames.length,
                    scrollDirection: Axis.horizontal,
                  ),
                  Positioned(
                      right: 0,
                      child: TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ContactList(imgNames)));
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
                        return Slidable(child:    ListTile(
                          leading: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              // borderRadius: BorderRadius.only(topRight: Radius.)),
                              border:
                                  Border.all(width: 2, color: Colors.indigo),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage("assets/img/pfour.jfif"),
                                  fit: BoxFit.cover),
                              // color: Colors.grey[600],
                              // image: imgNames[index].picture == ""
                              //     ? DecorationImage(
                              //         image: AssetImage(
                              //             "assets/img/defaultpic.png"),
                              //         fit: BoxFit.cover)
                              //     : DecorationImage(
                              //         image: FileImage(
                              //           File(imgNames[index].picture),
                              //         ),
                              //         fit: BoxFit.cover),
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
                            icon: Image(
                              image: AssetImage("assets/img/speaker.png"),
                            ),
                            onPressed: () {},
                          ),
                        ),
                        actionPane: SlidableDrawerActionPane(),
                        secondaryActions: [
                          IconButton(icon: Icon(Icons.call,size: 28,color: Colors.green,),onPressed: (){},)
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
