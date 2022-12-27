import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:i_exist_1/Constants/ConstantColors.dart';
import 'package:i_exist_1/Screens/AltProfile/alt_profileHelpers.dart';
import 'package:provider/provider.dart';

class AltProfile extends StatelessWidget {
  final String useruid;
  AltProfile({
    required this.useruid,
    super.key,
  });
  ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    final kheight = MediaQuery.of(context).size.height;
    final kwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Provider.of<AltProfileHelper>(context).appBar(context)),
      body: SingleChildScrollView(
        child: Container(
          height: kheight,
          width: kwidth,
          decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12))),
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(useruid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      Provider.of<AltProfileHelper>(context, listen: false)
                            .headerProfile(context, snapshot, useruid) ,
                            Provider.of<AltProfileHelper>(context, listen: false)
                            .divider() , 
                            Provider.of<AltProfileHelper>(context, listen: false)
                            .middleProfile(context, snapshot) ,
                            Provider.of<AltProfileHelper>(context, listen: false)
                            .footerProfile(context, snapshot)  ,
                    ]
                        );
              }
            },
          ),
        ),
      ),
    );
  }
}
