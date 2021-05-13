
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:kkgroup/models/AppController.dart';
import 'package:kkgroup/models/Constants.dart';
import 'package:kkgroup/models/GetPDF.dart';
import 'package:kkgroup/models/models.dart';
import 'package:kkgroup/models/styles.dart';

class LoginLog extends StatefulWidget {
  @override
  _LoginLogState createState() => _LoginLogState();
}

class _LoginLogState extends State<LoginLog> {

  bool isLoading=false;

  final _searchController = new TextEditingController();

  List <GetLog> _Fulllist = [];
  List <GetLog> _list = [];

  @override
  void initState(){
    super.initState();

    getLogs().whenComplete(() {
      isLoading = true;
      _list = List.from(_Fulllist);

      DateTime date = DateTime.parse(_list[0].log_time);
      print("DATE = $date");

    });
  }

  SearchFilter(String _searchTxt){
    print("enterd");
    setState(() {
      _list = _Fulllist.where((customer) =>
          customer.log_tmid.toLowerCase().contains(_searchTxt.toLowerCase()) || customer.log_time.toLowerCase().contains(_searchTxt.toLowerCase())
      ).toList();
    });
    //print(_list);
  }
  Future<bool> _onWillPop() async {
    return isLoading;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: GFAppBar(
            title: Text("લોગ ડેટા"),
            searchBar: true,
            searchController: _searchController,
            searchTextStyle: Mystyle().InputStyle,
            searchHintStyle: Mystyle().InputStyle,
            searchBarColorTheme: Colors.black,
            searchHintText: "રેકોર્ડ શોધો",
            onChanged: (value) {
              SearchFilter(value);
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: generatePDF,
            child: Icon(Icons.print,size: 25,),
          ),
          body: Center(child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("ઉત્સવ",style: new TextStyle(fontFamily: Constants.H_FONT_PATH),),
                isLoading ?
                _list!=null && _list.length>0 ? Expanded(child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                  itemCount: _list.length,
                  itemBuilder: (context,index){
                    return Card(
                      color: index%2 == 0 ? Colors.grey[200]:Colors.white,
                      shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        title: Text(" ${_list[index].log_tm_name}",style: Mystyle().InputStyle,),
                        subtitle:Text("${_list[index].log_time}",style: new TextStyle(fontSize: 20),),
                      ),
                    );
                  },
                )) : Center(child: Text(Constants.NO_DATA,style: Mystyle().subText,),) :
                Center(child: CircularProgressIndicator())
              ],
            )
          ),),
        ), onWillPop: _onWillPop);
  }


  generatePDF() async {
    GetPDF().getLogPDF(_list);

    /*pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        orientation: pw.PageOrientation.portrait,
        crossAxisAlignment: pw.CrossAxisAlignment.start,

        build: (pw.Context context) => [
          pw.Center(
              child: pw.ListView.builder(
                spacing: 20,
                itemCount: _list.length,
                itemBuilder: (context, index) {
                  return pw.Row(
                    children: [
                      pw.Text(" ${_list[index].log_tm_name}",style:new pw.TextStyle(fontSize: 25, font: ttf) ),
                      pw.Text("${_list[index].log_time}",style: new pw.TextStyle(fontSize: 25),),
                    ],
                  );
                },
              )
          )
        ],
      ),
    );*/

    //final file = File('${Constants.DIR_PATH}/example.pdf');
    //await file.writeAsBytes(await pdf.save()).then((value) {AppController().ShowToast(text:"PDF Created");});
  }
  getLogs() async {
    isLoading = false;
    _Fulllist = [];
    _list = [];
    Response response;
    Dio dio = new Dio();

    try {


      response =
      await dio.get(Constants.API_LOGS).timeout(Constants.API_TIMEOUT);
      if (response != null && response.data != null) {
        var nodata = response.data["nodata"];
        if (nodata["response_code"] == Constants.CODE_SUCESS) {
          var data = response.data["data"];
          setState(() {
            for (var element in data) {
              _Fulllist.insert(0, GetLog.fromJson(element));
            }
          });
          //AppController().ShowToast(text: "${data.length} Customer Found");
        }
      }
      //print("GEtData Response : ${response.data}");
    }
    catch (e) {
      print(e.toString());
      AppController().ShowToast(text: Constants.NO_INTERNET);
    }
  }
}
