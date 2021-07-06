import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mycontactapp/entity/mycontact.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class NewContact extends StatefulWidget {
  _NewContactState createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {
  File? image;
  PickedFile? _pickedFile;
  final ImagePicker _picker = new ImagePicker();
  TextEditingController phCtl=TextEditingController();
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
                        ? Image.file(image!,fit: BoxFit.cover,)
                        : Image(
                            image: AssetImage("assets/img/defaultpic.png",),
                            fit: BoxFit.cover,
                          ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: (MediaQuery.of(context).size.width / 100) * 37,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black.withOpacity(.5),
                      ),
                      child: Text("Take Picture"),
                      onPressed: () async {
                        _pickedFile =
                            await _picker.getImage(source: ImageSource.camera);
                        if (_pickedFile != null) {
                          print("new pic was taken");
                          image = File(_pickedFile!.path);
                          print("File path :: ${image?.path}");
                          image!.stat().then((value) => print("size :: ${value.size}"));
                          print("file size :: ${image!.stat().then((value) => value.size)}");
                          //final dir=await getExternalStorageDirectory();
                          //List<String> splits=image!.path.split("/");
                         // image!.copy(dir!.path+"/"+splits.last);
                        } else {
                          print("Cancel taking pic");
                        }
                        setState(() {});
                      },
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
                    child: Text("Phone Number",textAlign: TextAlign.center,),
                    width: (MediaQuery.of(context).size.width / 100) * 40,
                  ),
                  Container(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Phone Number",
                        labelText: "Phone Number"
                      ),
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
                    child: Text("Name",textAlign: TextAlign.center,),
                    width: (MediaQuery.of(context).size.width / 100) * 30,
                  ),
                  Container(
                    child: Icon(Icons.mic),
                    width: (MediaQuery.of(context).size.width / 100) * 30,
                  ),
                  Container(
                    child: IconButton(onPressed: (){},icon: Image(image: AssetImage("assets/img/speaker.png"),),),
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
                onPressed: () async{
                  if( phCtl.text != ""){
                    MyContact newContact;
                     final dir=await getExternalStorageDirectory();
                        
                    if(image?.path == null){                      
                      newContact=MyContact(Uuid().v4().toString(),"default","",[phCtl.text],"default");
                    }else{
                        List<String> splits=image!.path.split("/");
                        String filepath=dir!.path+"/"+splits.last;
                         image!.copy(filepath);
                      newContact=MyContact(Uuid().v4().toString(),"default",filepath,[phCtl.text],"default");
                    }
                    print("new Contact ${newContact.picture}");
                    Navigator.of(context).pop(newContact);
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
