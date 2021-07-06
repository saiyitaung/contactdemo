import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mycontactapp/detail.dart';
import 'package:mycontactapp/entity/mycontact.dart';
import 'package:mycontactapp/newcontact.dart';

class ContactList extends StatefulWidget {
  final List<MyContact> imgNames;
  ContactList(this.imgNames);
  _ContactListState createState() => _ContactListState(imgNames);
}

class _ContactListState extends State<ContactList> {
  List<MyContact> imgNames;
  _ContactListState(this.imgNames);
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All contact"),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            childAspectRatio: 1.1),
        itemBuilder: (context, index) {
          return InkWell(
            child: Card(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),

                  image: imgNames[index].picture != ""
                      ? DecorationImage(
                          image: FileImage(
                            File(imgNames[index].picture),
                          ),
                          fit: BoxFit.cover)
                      : DecorationImage(
                          image: AssetImage("assets/img/defaultpic.png"),
                          fit: BoxFit.cover,
                        ),
                  // image: DecorationImage(
                  //     image: AssetImage(imgNames[index].picture), fit: BoxFit.cover)),
                ),
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailPage(imgNames[index])));
            },
          );
        },
        itemCount: imgNames.length,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute<MyContact>(
                  builder: (context) => NewContact()))
              .then((value) {
            if (value != null) {
              print("${value.picture}");
              setState(() {
                imgNames.add(value);
              });
            }
          });
        },
      ),
    );
  }
}
