import 'package:carappsl/Screens/profile_screenN.dart';
import 'package:carappsl/models/user_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdCard extends StatelessWidget {

  AdCard(this.ad, this.context, this.userId);

  final ad;
  final context;
  final userId;

  Widget _buildImageWidget() {
    if (ad["profileImageUrl"] != null && ad["profileImageUrl"] != '') {

      return Material(
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: ((context) => ProfileScreenN(
                    currentUserId: Provider.of<userData>(context).currentUserId,
                    userId: userId,
                  ))
              ));
            },
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.network(ad["profileImageUrl"])
              ),),
          )
      );

    } else {
      return Material(
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: ((context) => ProfileScreenN(
                    currentUserId: Provider.of<userData>(context).currentUserId,
                    userId: userId,
                  ))
              ));
            },
            child: Container(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network('https://uae.microless.com/cdn/no_image.jpg')
              ),),
          )
      );

    }
  }

  Widget _buildUserNameWidget() {
    if (ad["name"] != null && ad["name"] != '') {
      return Text(ad["name"], style: TextStyle(fontWeight: FontWeight.bold),);
    } else {
      return SizedBox();
    }
  }

  Widget _buildRegNoWidget() {
    if (ad["vehiceRegNo"] != null && ad["vehiceRegNo"] != '') {
      return Text(" ${ad["vehiceRegNo"]}");
    } else {
      return SizedBox();
    }
  }

  Widget _buildModelWidget() {
    if (ad["brandModel"] != null && ad["vehiceRegNo"] != '') {
      return Row(
        children: <Widget>[
          Icon(Icons.directions_car),
          SizedBox(width: 4.0,),
          Expanded(child: Text(ad["brandModel"]))
        ],
      );
    } else {
      return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildImageWidget(),
          _buildUserNameWidget(),
          _buildModelWidget(),
          _buildRegNoWidget(),
        ],
      ),
    );
  }
}