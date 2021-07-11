import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:hive/hive.dart';
import 'package:mycontactapp/editcontact.dart';
import 'package:mycontactapp/entity/mycontact.dart';
import 'package:mycontactapp/logger/mylogger.dart';
import 'package:mycontactapp/utils/util.dart';

class DetailPage extends StatefulWidget {
  final contact;
  DetailPage(this.contact);
  _DetailPageState createState() => _DetailPageState(contact: contact);
}

class _DetailPageState extends State<DetailPage> {
  MyContact contact;
  MyLogger logger = MyLogger("DetailPage", "");
  Box<MyContact> box = Hive.box(DB);
  AudioPlayer player = AudioPlayer();
  _DetailPageState({required this.contact});

  void dispose() {
    super.dispose();
    player.stop();
  }

  Widget build(BuildContext context) {
    logger.log(contact.picture!);
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail page"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                contact.isFavorite = !contact.isFavorite;
                box.put(contact.uuid, contact);
              });

              logger.log("add to favorite");
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(!contact.isFavorite ? "remove from favorite":"add to favorite"),
                duration: Duration(milliseconds: 700),
              ));
            },
            icon: Icon(
              Icons.star,
              color: contact.isFavorite ? Colors.black : Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              logger.log("edit .,.");
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //   content: Text(
              //     "Edit contact",
              //   ),
              //   duration: Duration(milliseconds: 800),
              // ));
              Navigator.of(context)
                  .push(MaterialPageRoute<MyContact>(
                      builder: (context) => EditContact(contact)))
                  .then((value) {
                setState(() {});
              });
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: (MediaQuery.of(context).size.height / 100) * 40,
            child: Hero(
              tag: contact.uuid!,
              child: Container(
                width: (MediaQuery.of(context).size.width / 100) * 80,
                height: (MediaQuery.of(context).size.height / 100) * 40,
                decoration: BoxDecoration(
                  // shape: BoxShape.circle,
                  // color: Colors.grey[500],
                  image: contact.picture == ""
                      ? DecorationImage(
                          image: AssetImage("assets/img/defaultpic.png"),
                          fit: BoxFit.cover,
                        )
                      : DecorationImage(
                          image: FileImage(
                            File(contact.picture!),
                          ),
                          fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: IconButton(
                    onPressed: () async {
                      File f = File(contact.audioName!);
                      logger.log(contact.audioName!);
                      if (await f.exists()) {
                        // await AudioPlayer()
                        //     .play(contact.audioName!, isLocal: true);
                        player.play(contact.audioName!, isLocal: true);
                      } else {
                        logger.log("File doesn't exist!");
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("File does not Exists!")));
                      }
                    },
                    icon: Image(
                      image: AssetImage("assets/img/speaker.png"),
                    ),
                  ),
                ),
                Container(
                  child: IconButton(
                      onPressed: () {
                        FlutterPhoneDirectCaller.callNumber(
                            contact.numbers!.first);
                      },
                      icon: Icon(Icons.call)),
                ),
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (context, index) {
              return Padding(
                child: ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.phone, color: Colors.green),
                    onPressed: () {
                      FlutterPhoneDirectCaller.callNumber(
                          contact.numbers![index]);
                    },
                  ),
                  title: Text(
                    contact.numbers![index],
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20),
              );
            },
            itemCount: contact.numbers!.length,
          )),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     showDialog<bool>(context: context, builder: (context){
      //       return AlertDialog(
      //         title: Text("Delete?",textAlign: TextAlign.center,),
      //         content: Text("Please Confirm to Delete."),
      //         actions: [
      //           Container(
      //             width: MediaQuery.of(context).size.width,
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //               children: [
      //                 TextButton(onPressed: ()=>Navigator.pop(context,false), child: Text("Cancel")),
      //                 TextButton(onPressed: ()=>Navigator.pop(context,true), child: Text("Confirm")),
      //               ],
      //             ),
      //           )
      //         ],
      //       );
      //     }).then((value) => value == true ? Navigator.of(context).pop(value):logger.log("cancel deleting "));
      //   },
      //   child: Icon(Icons.delete),
      // ),
    );
  }
}
