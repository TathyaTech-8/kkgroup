import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:kkgroup/models/AppController.dart';
import 'package:kkgroup/models/Constants.dart';
import 'package:kkgroup/models/styles.dart';

class HomeScreen extends StatelessWidget {

  int num = 0;

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        child: Scaffold(
      // appBar: AppBar(
      //   title: Text("K. K. Group"),
      // ),

      //drawer: MyDrawer(1),
        body: Center(child: Container(
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Hello!",style: new TextStyle(fontSize: 25,color: Colors.black54),),
                        Text(Constants.USERNAME,style: new TextStyle(fontSize: 28,color: Colors.black),),
                      ],
                    ),
                    GFButton(
                      shape: GFButtonShape.pills,
                      size: 50,
                      color: Colors.lightGreen,
                      child: Padding(padding: EdgeInsets.all(10),child: Text("Dashboard",style: Mystyle().InputStyle,),),
                      onPressed: () { RouteController().GoTo(context, Constants.DASHBOARD); },
                    ),
                  ],
                ),
                SizedBox(height: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MenuCard(context,1,Icons.people_alt_rounded),
                    MenuCard(context,2,Icons.list),
                    MenuCard(context,3,Icons.playlist_add_outlined),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MenuCard(context,4,Icons.launch),
                    MenuCard(context,5,Icons.featured_play_list_outlined),
                    MenuCard(context,6,Icons.featured_play_list_outlined),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MenuCard(context,7,Icons.featured_play_list_outlined),
                    MenuCard(context,8,Icons.featured_play_list_outlined),
                    MenuCard(context,9,Icons.featured_play_list_outlined),
                  ],
                )
              ],
            ),
          )
        //MakeGrid(),
      ),),
    ), onWillPop: () async{
      return (await showDialog(
          //context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
            ),
              new TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
          ),
        ],
      ), context: context,
      )) ?? false;
    },);
  }

  MenuCard(BuildContext context,int index,icon){
    //print("Entered with $index");
    return InkWell(
      onTap: (){
        String str = "0x00N0$index" + "0";
        print(str);
        RouteController().GoTo(context, str);
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              //elevation: 0.0,
              //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.20,
                  height: MediaQuery.of(context).size.width * 0.20,
                child: Image(image: AssetImage(Constants.IMG_MENU[index]),),
              ),
              //clipBehavior: Clip.antiAlias,
              padding: EdgeInsets.all(8.0),
            ),
            SizedBox(height: 5,),
            SizedBox(width: MediaQuery.of(context).size.width * 0.2, child: Text(
              Constants.MENU_NAMES[index],
              style: TextStyle(fontSize: 20.0,),textAlign: TextAlign.center,
            ),),
          ],
        ),),
    );
  }
}