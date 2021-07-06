import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mycontactapp/entity/mycontact.dart';

class DetailPage extends StatelessWidget {
  final MyContact contact;
  DetailPage(this.contact);
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail page"),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: (MediaQuery.of(context).size.height / 100) * 40,
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
                          File(contact.picture),
                        ),
                        fit: BoxFit.cover),
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
                  child:
                      IconButton(onPressed: () {}, icon: Image(image: AssetImage("assets/img/speaker.png"),)),
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
                  leading: Icon(Icons.phone),
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
