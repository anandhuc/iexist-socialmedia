import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:i_exist_1/Constants/ConstantColors.dart';
import 'package:i_exist_1/Screens/Messaging/directMessaging/directMessagingHelper.dart';
import 'package:provider/provider.dart';

class ScreenDMessageing extends StatelessWidget {
   ScreenDMessageing({required this.reciversname,required this.reciversimage ,super.key}); 
  String reciversname;
  String reciversimage;

  @override
  Widget build(BuildContext context) {
    final ConstantColors constantColors=ConstantColors();
    return SafeArea( 
      child: Scaffold(
        backgroundColor: constantColors.greyColor1,     
         appBar:PreferredSize(preferredSize: const Size.fromHeight(50),
          
          child: Provider.of<DirectMessagingHelper >(context).customAppbar(context, reciversname, reciversimage)),
      
     
     body: SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            AnimatedContainer(duration: Duration(seconds: 1),
            curve: Curves.bounceIn,
            height: MediaQuery.of(context).size.height*0.83,
            width: MediaQuery.of(context).size.width,
                // child: Provider.of<GroupMessegingHelper>(context, listen: false)
                //     .showMesages(context, widget.documentSnapshot,
                //         widget.documentSnapshot['useruid']),
         ) ],
        ),
      ),
     ),
     
      ),
    );
  }
}