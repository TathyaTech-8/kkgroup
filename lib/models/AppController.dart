

import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/components/drawer/gf_drawer_header.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:kkgroup/models/models.dart';
import 'package:kkgroup/screens/dashboard.dart';
import 'package:kkgroup/screens/login_log.dart';
import 'package:kkgroup/screens/menu_1_1.dart';
import 'package:kkgroup/screens/menu_1_1_1.dart';
import 'package:kkgroup/screens/menu_8.dart';
import 'package:kkgroup/screens/menu_8_1.dart';
import 'package:kkgroup/screens/menu_9.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/menu_1.dart';
import '../screens/menu_2.dart';
import '../screens/menu_3.dart';
import '../screens/menu_4.dart';
import '../screens/menu_5.dart';
import '../screens/menu_6.dart';
import '../screens/menu_7.dart';
import 'Constants.dart';
import 'styles.dart';

class AppController {
  void ShowToast({String text, Color bgColor = Colors.grey, Color fontColor = Colors.white}){
    Fluttertoast.showToast(
        msg: text,
        toastLength:
        Toast.LENGTH_SHORT,
        gravity:
        ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: bgColor,
        textColor: fontColor,
        fontSize: 16.0);
  }

  MonthYearSelector(){

  }

  DatePicker(_dateController){
    return Padding(padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
      child: DateTimePicker(
        type: DateTimePickerType.date,
        controller: _dateController,
        decoration: new InputDecoration(border: Mystyle().FullBorder(Colors.black54),prefixIcon:  Icon(Icons.date_range,color: Colors.black,size: 30,)),
        //initialValue: DateTime.now().toString(),
        firstDate: DateTime(2000),
        style: Mystyle().InputStyle,
        lastDate: DateTime(2100),
        dateLabelText: 'Date',
        onChanged: (val) { print(val);},
        validator: (val) {
          print(val);
          return null;
        },
        onSaved: (val) => print(val),
      ),);
  }
  CallDialog(BuildContext context,List<String> numbers){

    if(numbers.length == 1){ AppController().MakeCall(numbers[0]);}
    else{
      if(numbers[1] == "0" || numbers[1] == ""){
        AppController().MakeCall(numbers[0]);
      }
      else{
        return showDialog(context: context,builder: (context){
          return Dialog(
            shape: Mystyle().RoundShape,
            backgroundColor: Colors.white,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: numbers.length,
                itemBuilder: (context,index){
                  return ListTile(
                    shape: Mystyle().RoundShape,
                    title: Mystyle().AppText(numbers[index], TextAlign.center),
                    onTap: ()=>AppController().MakeCall(numbers[index]),
                  );
                }
            ),
          );
        });
      }
    }
  }

  MakeCall(String number){
    print(number);
    launch("tel:" + number);
  }


  static showLoader(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
            child: Padding(child:Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 25, height: 25,child:
                new CircularProgressIndicator(),),
                SizedBox(width: 25,),
                new Text("કૃપા કરી ને રાહ જુવો...",style: Mystyle().subText,),
              ],
            ), padding: EdgeInsets.all(20))
        );
      },
    );
  }

  static bool GetDateDiff(String fddate){

    if(fddate!=null && fddate!=""){

      //print(fddate);
      final f = new DateFormat('dd/MM/yyyy').parse(fddate);

      print(f);

      final difference = DateTime.now().difference(f).inDays;

      if(difference>2){
        return true;
      }else{
        return false;
      }
    }else{
      return false;
    }
  }

  static GetDateDiffInDays(String fddate){

    if(fddate!=null && fddate!=""){

      //print(fddate);
      final f = new DateFormat('dd/MM/yyyy').parse(fddate);

      print(f);

      final difference = f.difference(DateTime.now()).inDays;

      return difference;
    }
    else{
      return 0;
    }
  }

  Future<bool> CanWrite() async {
    Directory directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          String newPath = "";
          print(directory);
          List<String> paths = directory.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/KK_Group";
          directory = Directory(newPath);
        } else {
          return false;
        }
      }

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        Constants.DIR_PATH = directory.path;

        await MakeAllDirectories(directory);
        print("path is ${directory.path}");
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  MakeAllDirectories(Directory path) async {

    //Custmerlist
    {
      var newPath = path.path + "/Dayri";
      var directory = Directory(newPath);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        Constants.DIR_LOAN = directory.path;
      }
    }
    //Pedhi_Hisab
    {
      var newPath = path.path + "/Hisab";
      var directory = Directory(newPath);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        Constants.DIR_HISAB = directory.path;
      }
    }
    {
      var newPath = path.path + "/Investor";
      var directory = Directory(newPath);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        Constants.DIR_INVESTOR = directory.path;
      }
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  getDir(){


  }

  Future<void> setSelMY(String month, String year) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("SelMonth", month);
    prefs.setString("SelYear", year);

    Constants.SelMonth = prefs.getString("SelMonth");
    Constants.SelYear = prefs.getString("SelYear");
  }

}

class RouteController{
  void GoTo2(BuildContext context,String screen,GetTLoan _tloan){
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => TEMILIST(loan: _tloan,)));
  }
  void GoTo(BuildContext context,String screen,{String month, String year,GetCustomer cust,GetLoans loan}){
    switch(screen){
      case Constants.HOME_SCREEN:
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
        break;
      case Constants.LOGIN_SCREEN:
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
        break;
      case Constants.CUST_LIST_SCREEN:
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CUSTLIST(PageIndex: 1,)));
        break;
      case Constants.LOAN_LIST_SCREEN:
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LOANLIST(customer: cust,)));
        break;
      case Constants.EMI_LIST_SCREEN:
        print("innre chk ${cust.cust_id} -- ${loan.id}");
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => EMILIST(customer: cust,loan: loan,)));
        break;
      case Constants.TODAY_COLL_SCREEN:
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => TODAY_COLL(PageIndex: 2,)));
        break;
      case Constants.PEND_COLL_SCREEN:
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => PEND_COLL(PageIndex: 3,)));
        break;
      case Constants.COLL_BANK_SCREEN:
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => COLL_BANK(PageIndex: 4,)));
        break;
      case Constants.BANK_TOTAL_SCREEN:

        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => BANK_TOTAL(PageIndex: 5,getMonth: DateTime.now().month,getYear: DateTime.now().year,)));
        break;
      case Constants.OTHER_EXP_SCREEN:
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => OTHER_EXP(PageIndex: 6,)));
        break;
      case Constants.TEAM_LIST_SCREEN:
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => TEAM_LIST(PageIndex: 7,)));
        break;
      case Constants.TLOAN_SCREEN:
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => TLOAN(PageIndex: 8,)));
        break;
      case Constants.TCALL_SCREEN:
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => TEMI_COLL(PageIndex: 9,)));
        break;
      case Constants.DASHBOARD:
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DashBoard()));
        break;
      case Constants.LOG_SCREEN:
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LoginLog()));
        break;

    }
  }
}

class MyDrawer extends StatelessWidget {
final int _selected;
final  List iconsImage = [
  ImageIcon(AssetImage(Constants.IMG_MENU[0]),size: 20,)
];

  MyDrawer(this._selected);
  @override
  GFDrawer build(BuildContext context) {
    return GFDrawer(
      colorFilter: ColorFilter.linearToSrgbGamma(),
      child:Column(
          children: [
            InkWell(
              child: GFDrawerHeader(
                decoration: BoxDecoration(color: Colors.lightGreen[500],),
                closeButton: SizedBox(),
                child: GFTypography(
                  text: Constants.USERNAME,
                  type: GFTypographyType.typo1,
                  dividerBorderRadius: new BorderRadius.all(Radius.zero),
                ),
              ),
              onTap: (){
                //RouteController().GoTo(context, Constants.PROFILE_SCREEN);
              },
            ),
            Expanded(child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: Constants.MENU_NAMES.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 3,horizontal: 20),
                  title: GFTypography(
                    text: Constants.MENU_NAMES[index],
                    icon: Image(image: AssetImage(Constants.IMG_MENU[index]),width: 30,),
                    type: GFTypographyType.typo2,
                    showDivider: false,
                  ),
                  selectedTileColor: Colors.grey[300],
                  selected: (index == _selected) ? true :false,
                  onTap: () => onPressedEvent(context,index),dense: true,
                );
              },
            ))
          ],
        ),
    );
  }

  void onPressedEvent(BuildContext context,int index){
    print("index $index");
    if(index == _selected){return;}
    if(index == 0){
      RouteController().GoTo(context, Constants.HOME_SCREEN);
    }
    else if(index == Constants.MENU_NAMES.length-1){
      RouteController().GoTo(context, Constants.LOGIN_SCREEN);
    }
    else {
      String str = "0x00N0$index" + "0";
      print(str);
      RouteController().GoTo(context, str);
    }
  }
}