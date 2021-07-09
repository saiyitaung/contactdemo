import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mycontactapp/entity/mycontact.dart';
import 'package:mycontactapp/logger/mylogger.dart';

class DetailPage extends StatelessWidget {
  final MyContact contact;
  final MyLogger logger = MyLogger("DetailPage", "");
  DetailPage(this.contact);
  Widget build(BuildContext context) {
    logger.log(contact.picture);
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail page"),
        actions: [
          IconButton(onPressed: (){
            logger.log("add to favorite");
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Add to favorite"),duration: Duration(milliseconds: 700),));
          },icon: Icon(Icons.star),),
           IconButton(onPressed: (){
             logger.log("edit .,.");
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Edit contact",),duration: Duration(milliseconds: 800),));

           },icon: Icon(Icons.edit),),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: (MediaQuery.of(context).size.height / 100) * 40,
            child: Hero(
              tag: contact.uuid,
              child:Container(
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
                          File(contact.picture),
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
                        File f = File(contact.audioName);
                        if (await f.exists()) {
                          await AudioPlayer()
                              .play(contact.audioName, isLocal: true);
                        } else {
                          logger.log("File doesn't exist!");
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:  Text("File Not Exists!")));
                        }
                      },
                      icon: Image(
                        image: AssetImage("assets/img/speaker.png"),
                      )),
                ),
                Container(
                  child: IconButton(onPressed: () {}, icon: Icon(Icons.call)),
                ),
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (context, index) {
              return Padding(
                child: ListTile(
                  leading: IconButton(icon: Icon(Icons.phone,color: Colors.green),onPressed: (){},),
                  title: Text(
                    contact.numbers.first,
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20),
              );
            },
            itemCount: 2,
          )),
        ],
      ),
    );
  }
}
