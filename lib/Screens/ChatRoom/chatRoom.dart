import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:i_exist_1/Constants/ConstantColors.dart';
import 'package:i_exist_1/Screens/ChatRoom/ChatRoomHelper.dart';
import 'package:provider/provider.dart';

class ScreenChatRoom extends StatelessWidget {
  const ScreenChatRoom({super.key});

  @override
  Widget build(BuildContext context) {
    final ConstantColors constantColors = ConstantColors();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: constantColors.darkColor.withOpacity(0.3),
        centerTitle: true,
        title: RichText(
            text: TextSpan(
                text: "Chat",
                style: TextStyle(
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Solway',
                    fontSize: 20),
                children: <TextSpan>[
              TextSpan(
                  text: "Box",
                  style: TextStyle(
                      color: constantColors.blueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20))
            ])),
        leading: IconButton(
            onPressed: () {
              Provider.of<ChatRoomHelper>(context, listen: false)
                  .showCreateChatroomSheet(context);
            },
            icon: Icon(
              FontAwesomeIcons.plus,
              color: constantColors.greenColor,
            )),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                EvaIcons.moreVertical,
                color: constantColors.whiteColor,
              ))
        ], 
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Provider.of<ChatRoomHelper>(context, listen: false)
            .showChatrooms(context),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: constantColors.blueGreyColor,
        child: Icon(
          FontAwesomeIcons.plus,
          color: constantColors.whiteColor,
        ),
        onPressed: () {
          Provider.of<ChatRoomHelper>(context, listen: false)
              .showCreateChatroomSheet(context);
        },
      ),
    );
  }
}
