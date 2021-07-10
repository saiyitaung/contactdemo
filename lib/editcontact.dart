import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mycontactapp/entity/mycontact.dart';
import 'package:mycontactapp/logger/mylogger.dart';

class EditContact extends StatefulWidget {
  final MyContact contact;
  EditContact(this.contact);
  _EditContactState createState() => _EditContactState(contact);
}

class _EditContactState extends State<EditContact> {
  MyContact contact;
  MyLogger logger = MyLogger("_EditContactState", "");
  TextEditingController phCtl=TextEditingController();
  _EditContactState(this.contact);
  void initState(){
    super.initState();
    setState(() {
      phCtl.text=contact.numbers!.first;
    });
  }
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: (h / 100) * 40,
              width: w,
              child: Stack(
                children: [
                  Container(
                    height: (h / 100) * 40,
                    width: w,
                    decoration: BoxDecoration(
                        image: contact.picture != ""
                            ? DecorationImage(
                                image: FileImage(File(contact.picture!)),
                                fit: BoxFit.cover)
                            : DecorationImage(
                                image: AssetImage("assets/img/defaultpic.png"),
                                fit: BoxFit.cover)),
                  ),
                  Positioned(
                    bottom: 20,
                    left: (MediaQuery.of(context).size.width / 100) * 37,
                    child: Container(child:DropdownButton<ImageSource>(
                      dropdownColor: Colors.blueGrey,
                      underline: Container(),
                      items: [
                        DropdownMenuItem<ImageSource>(
                          child: Text("Camera"),
                          value: ImageSource.camera,
                        ),
                        DropdownMenuItem<ImageSource>(
                          child: Text("gallery"),
                          value: ImageSource.gallery,
                        )
                      ],
                      onChanged: (v) async {
                        if (v == ImageSource.camera) {
                          logger.log("Image Source Camera");
                        } else {
                          logger.log("Image Source gallery");
                        }
                      },
                      selectedItemBuilder: (context) {
                        return [
                          DropdownMenuItem<ImageSource>(
                            child:  Text("Set Picture",
                                style: TextStyle(color: Colors.white,),
                                 ),
                            value: ImageSource.camera,
                          ),
                        ];
                      },
                      value: ImageSource.camera,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blueGrey,

                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                  ),
                  ),
                ],
              ),
            ),

             Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Text(
                      "Phone Number",
                      textAlign: TextAlign.center,
                    ),
                    width: (MediaQuery.of(context).size.width / 100) * 40,
                  ),
                  Container(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: "Phone Number", labelText: "Phone Number"),
                      controller: phCtl,
                    ),
                    width: (MediaQuery.of(context).size.width / 100) * 55,
                  ),
                ],
              ),
            ),
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Text(
                      "Name",
                      textAlign: TextAlign.center,
                    ),
                    width: (MediaQuery.of(context).size.width / 100) * 30,
                  ),
                  Container(
                    child: IconButton(
                      icon: Icon(Icons.mic),
                      onPressed: () async {
 
                      },
                    ),
                    width: (MediaQuery.of(context).size.width / 100) * 30,
                  ),
                  Container(
                    child: IconButton(
                      onPressed: () async {
                       
                      },
                      icon: Image(
                        image: AssetImage("assets/img/speaker.png"),
                      ),
                    ),
                    width: (MediaQuery.of(context).size.width / 100) * 30,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () async {
                  
                },
                child: Container(
                  child: Center(
                      child: Text(
                    "Update",
                    style: TextStyle(color: Colors.white),
                  )),
                  width: 120,
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
