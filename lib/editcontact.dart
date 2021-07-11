import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mycontactapp/entity/mycontact.dart';
import 'package:mycontactapp/logger/mylogger.dart';
import 'package:mycontactapp/recordvoicename.dart';
import 'package:mycontactapp/utils/util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class EditContact extends StatefulWidget {
  final MyContact contact;
  EditContact(this.contact);
  _EditContactState createState() => _EditContactState(contact);
}

class _EditContactState extends State<EditContact> {
  MyContact contact;
  MyLogger logger = MyLogger("_EditContactState", "");
  File? _imageFile;
  PickedFile? _pickFile;
  final ImagePicker _picker = new ImagePicker();
  TextEditingController phCtl = TextEditingController();
  TextEditingController phCtl2 = TextEditingController();
  final player = AudioPlayer();
  Box<MyContact> box = Hive.box(DB);
  _EditContactState(this.contact);
  void initState() {
    super.initState();
    setState(() {
      phCtl.text = contact.numbers!.first;
      if(contact.numbers!.length == 2){
        phCtl2.text=contact.numbers!.last;
      }
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
                    child: Container(
                      child: DropdownButton<ImageSource>(
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
                          final appPath = await getExternalStorageDirectory();
                          if (v == ImageSource.camera) {
                            _pickFile = await _picker.getImage(
                                source: ImageSource.camera);
                            _imageFile = File(_pickFile!.path);
                            logger.log("Update profile pic from camera");
                          } else {
                            _pickFile = await _picker.getImage(
                                source: ImageSource.gallery);
                            _imageFile = File(_pickFile!.path,);
                            logger.log("Update profile pic from gallery");
                          }

                          logger.log("selecte file path ${_imageFile!.path}");
                          // get file name
                          final _fileName = _pickFile!.path.split("/").last;
                          //get file ext
                          final _fileExt = _fileName.split(".").last;
                          //copy image file to appdir and rename with contact's uuid
                          final _oldPicName = contact.picture!;
                          final _newPicName = appPath!.path +
                              "/" +
                              Uuid().v4().toString() +
                              "." +
                              _fileExt;

                              if(contact.picture! != "" ){
                               await File(_oldPicName).delete();
                               logger.log("Delete old pic $_oldPicName");
                              }
                          await _imageFile!.copy(_newPicName);
                          //delete old profile pic if file ext is not the same or some reason file doesn't overwrite with new pic
                          // if (_oldPicName != _newPicName) {
                            
                          //   logger.log("Deleting $_oldPicName");
                          // }
                          setState(() {
                            contact.picture = _newPicName;
                            logger.log("change pice ${contact.picture}");
                            box.put(contact.uuid, contact);
                          });
                        },
                        selectedItemBuilder: (context) {
                          return [
                            DropdownMenuItem<ImageSource>(
                              child: Text(
                                "Set Picture",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
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
                      onChanged: (v) {
                         if (v.length > 8 && v.length < 12) {
                        contact.numbers!.first = v;
                        box.put(contact.uuid, contact);
                         }
                      },
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
                      "Phone Number 2",
                      textAlign: TextAlign.center,
                    ),
                    width: (MediaQuery.of(context).size.width / 100) * 40,
                  ),
                  Container(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: "Phone Number", labelText: "Phone Number"),
                      controller: phCtl2,
                      onChanged: (v) {
                        if (v.length > 8 && v.length < 12) {
                           if(contact.numbers!.length == 1){
                             contact.numbers!.add(v);
                           }else{
                             contact.numbers!.last=v;
                           }
                          logger.log("${contact.numbers!.last}");
                           box.put(contact.uuid, contact);
                        }
                      },
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
                        final dirPath = await getExternalStorageDirectory();

                        showModalBottomSheet<bool>(
                            isDismissible: false,
                            enableDrag: false,
                            context: context,
                            builder: (context) {
                              logger.log("contact uuid : ${contact.uuid!}");
                              return RecordVoiceName(
                                  contact.uuid!, dirPath!.path, false);
                            }).then((value) async {
                          logger.log("return from recordvoice $value");
                          // if true replace old file with update file
                          File f = File(dirPath!.path +
                              "/" +
                              contact.uuid! +
                              "_tempupdate" +
                              ".wav");
                          if (await f.exists()) {
                            if (value!) {
                              logger.log("update audiofile here!");
                              final filePath =
                                  dirPath.path + "/" + contact.uuid! + ".wav";
                              final oldFile = File(filePath);
                              logger.log("deleting old audio file");
                              await oldFile.delete();
                              logger.log("Rename updated file");
                              await f.rename(filePath);
                            } else {
                              //else delete an update recorded audio file
                              await f.delete();
                              logger.log("doesn't want to save a update!");
                            }
                          }
                        });
                      },
                    ),
                    width: (MediaQuery.of(context).size.width / 100) * 30,
                  ),
                  Container(
                    child: IconButton(
                      onPressed: () async {
                        await player.play(contact.audioName!);
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
          ],
        ),
      ),
    );
  }
}
