import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mycontactapp/entity/mycontact.dart';
import 'package:mycontactapp/logger/mylogger.dart';
import 'package:mycontactapp/recordvoicename.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class NewContact extends StatefulWidget {
  final String number;
  NewContact(this.number);
  _NewContactState createState() => _NewContactState(number);
}

class _NewContactState extends State<NewContact> {
  String number;
  File? image;
  PickedFile? _pickedFile;
  final ImagePicker _picker = new ImagePicker();
  TextEditingController phCtl = TextEditingController();
  final String uuid = Uuid().v4().toString();
  AudioPlayer player =AudioPlayer();
  MyLogger logger = MyLogger("NewContact", "");

  void initState() {
    super.initState();
    if (number != "") {
      setState(() {
        phCtl.text = number;
      });
    }
  }

  _NewContactState(this.number);
  void dispose() {
    super.dispose();
    logger.log("dispose");
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("add new contact"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: (MediaQuery.of(context).size.height / 100) * 40,
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: (MediaQuery.of(context).size.height / 100) * 40,
                    child: image != null
                        ? Image.file(
                            image!,
                            fit: BoxFit.cover,
                          )
                        : Image(
                            image: AssetImage(
                              "assets/img/defaultpic.png",
                            ),
                            fit: BoxFit.cover,
                          ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: (MediaQuery.of(context).size.width / 100) * 37,
                    child: DropdownButton<ImageSource>(
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
                          _pickedFile = await _picker.getImage(
                              source: ImageSource.camera);
                          if (_pickedFile != null) {
                            logger.log("new pic was taken");
                            image = File(_pickedFile!.path);
                            logger.log("File path :: ${image?.path}");
                            image!.stat().then(
                                (value) => logger.log("size :: ${value.size}"));
                            logger.log(
                                "file size :: ${image!.stat().then((value) => value.size)}");
                          } else {
                            logger.log("Cancel taking pic");
                          }
                          setState(() {});
                        } else {
                          _pickedFile = await _picker.getImage(
                              source: ImageSource.gallery);
                          if (_pickedFile != null) {
                            image = File(_pickedFile!.path);
                          }
                          setState(() {});
                        }
                      },
                      selectedItemBuilder: (context) {
                        return [
                          DropdownMenuItem<ImageSource>(
                            child: Text("Set Picture",
                                style: TextStyle(color: Colors.white)),
                            value: ImageSource.camera,
                          ),
                        ];
                      },
                      value: ImageSource.camera,
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
                        Directory? dir = await getExternalStorageDirectory();
                        logger.log(dir!.path);
                        showModalBottomSheet(
                            isDismissible: false,
                            enableDrag: false,
                            context: context,
                            builder: (context) {
                              return RecordVoiceName(uuid, dir.path, true);
                            });
                      },
                    ),
                    width: (MediaQuery.of(context).size.width / 100) * 30,
                  ),
                  Container(
                    child: IconButton(
                      onPressed: () async {
                        Directory? dir = await getExternalStorageDirectory();
                        if (await File(dir!.path + "/" + uuid + ".wav")
                            .exists()) {
                          // await AudioPlayer()
                          //     .play(dir.path + "/" + uuid + ".wav");
                          player.play(dir.path+"/"+uuid+".wav");
                        }
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
                  final dir = await getExternalStorageDirectory();
                  if (phCtl.text != "" &&
                      await File(dir!.path + "/" + uuid + ".wav").exists()) {
                    MyContact newContact;
                    if (image?.path == null) {
                      newContact = MyContact(uuid:uuid, picture:"", numbers:[phCtl.text],
                          audioName:dir.path + "/" + uuid + ".wav");
                    } else {
                      List<String> splits = image!.path.split("/");
                      final fileExt = splits.last.split(".")[1];
                      final fileName = uuid + "." + fileExt;
                      logger.log(" image file Name = $fileName");
                      image!.copy(dir.path + "/" + fileName);
                      newContact = MyContact(
                          uuid:Uuid().v4().toString(),
                          picture:dir.path + "/" + fileName,
                          numbers:[phCtl.text],
                          audioName:dir.path + "/" + uuid + ".wav");
                    }
                    logger.log("new Contact ${newContact.picture}");
                    Navigator.of(context).pop(newContact);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Audio Name and Phone Number Required"),
                      duration: Duration(milliseconds: 700),
                    ));
                  }
                },
                child: Container(
                  child: Center(
                      child: Text(
                    "Save",
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
