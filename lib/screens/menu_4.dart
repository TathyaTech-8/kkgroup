import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:kkgroup/models/AppController.dart';
import 'package:kkgroup/models/Constants.dart';
import 'package:kkgroup/models/GetPDF.dart';
import 'package:kkgroup/models/models.dart';
import 'package:kkgroup/models/styles.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:smart_select/smart_select.dart';


class COLL_BANK extends StatefulWidget {
  int PageIndex;
  COLL_BANK({this.PageIndex});

  @override
  _COLL_BANKState createState() => _COLL_BANKState(PageIndex: this.PageIndex);
}

class _COLL_BANKState extends State<COLL_BANK> {

  final int PageIndex;
  final _searchController = new TextEditingController();
  bool isLoading = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  String month = Constants.SelMonth;
  String year = Constants.SelYear ;

  final _btnController = new RoundedLoadingButtonController();

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  int ScrIndex = 0;

  // simple usage
  List <TxnList> _Fulllist = [];
  List <TxnList> _list = [];

  _COLL_BANKState({this.PageIndex});

  void initState(){
    super.initState();
    GetTxnAPI().whenComplete(() {
      isLoading = true;
      _list = List.from(_Fulllist);
      if (_list != null && _list.length > 0) {
        Timer(Duration(seconds: 1), () {
          scrollTo(ScrIndex);
        });
      }
    });
  }
  Future<bool> _onWillPop() async {
    return isLoading;
  }

  getPDF(){
    if(isLoading && _list.length > 0){

      String title;
      if(month == "0"){
        title = "$year";
      }
      else{
        title = "${Constants.Months[int.parse(month)] } $year";
      }


      GetPDF().getTxnList(_list, title);
    }
    else{
      AppController().ShowToast(text: Constants.NO_DATA);
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: GFAppBar(
        actions: [
          GFIconButton(
              color: Colors.lightGreen,
              splashColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 20),
              iconSize: 25,
              icon: Icon(Icons.print_rounded,size: 30,color: Colors.black,),
              onPressed: getPDF
          )
        ],
        title: Text(Constants.MENU_NAMES[PageIndex]),
        searchBar: true,
        searchController: _searchController,
        searchTextStyle: Mystyle().InputStyle,
        searchHintStyle: Mystyle().InputStyle,
        searchBarColorTheme: Colors.black,
        searchHintText: "નામ શોધો",
        onChanged: (value) {
          SearchFilter(value);
        },
      ),
      drawer: MyDrawer(PageIndex),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MainCard(),
            isLoading ? COLL_BANK != null && _list.length > 0 ? ListCard()
                : Center(child: Text(Constants.NO_DATA,style: Mystyle().subText,),)
                : Center(child: CircularProgressIndicator())
          ],
        ),
      ),
    ), onWillPop: _onWillPop);
  }

  MainCard(){
    List<S2Choice<String>> years = new List();
    int cyear = DateTime.now().year;
    for(int i = cyear;i >2018;i--){
      years.add(new S2Choice(value: "$i", title: "$i"));
    }
    List<S2Choice<String>> months = [
      S2Choice(value: "0", title: "All Months"),
      S2Choice(value: "1", title: "January"),
      S2Choice(value: "2", title: "February"),
      S2Choice(value: "3", title: "March"),
      S2Choice(value: "4", title: "April"),
      S2Choice(value: "5", title: "May"),
      S2Choice(value: "6", title: "June"),
      S2Choice(value: "7", title: "July"),
      S2Choice(value: "8", title: "August"),
      S2Choice(value: "9", title: "September"),
      S2Choice(value: "10", title: "October"),
      S2Choice(value: "11", title: "November"),
      S2Choice(value: "12", title: "December"),
    ];

    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                Card(
                  shape: Mystyle().RoundShape,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: SmartSelect<String>.single(
                        title: 'Year',
                        value: year,
                        choiceItems: years,
                        choiceType: S2ChoiceType.chips,
                        modalType: S2ModalType.bottomSheet,
                        onChange: (state) => setState(()
                        {
                          year = state.value;
                          RefreshData();
                        })
                    ),),
                ),
                Card(
                  shape: Mystyle().RoundShape,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: SmartSelect<String>.single(
                        title: 'Month',
                        value: month,
                        choiceItems: months,
                        choiceType: S2ChoiceType.chips,
                        modalType: S2ModalType.bottomSheet,
                        onChange: (state) => setState(()
                        {
                          month = state.value;
                          RefreshData();
                        })
                    ),),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ListCard() {
    return Expanded(child: ScrollablePositionedList.builder(
      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
      itemScrollController: itemScrollController,
      itemPositionsListener: itemPositionsListener,
      scrollDirection: Axis.vertical,
      itemCount: _list.length,
      itemBuilder: (context,index){
        return Card(
          color: index%2 == 0 ? Colors.grey[200]:Colors.white,
          shape: Mystyle().RoundShape,
          margin: EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
            title: Text(
                _list[index].from_name,
                style: Mystyle().InputStyle
            ),
            subtitle: _list[index].status == "0" ?
            Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("તારીખ : ${_list[index].date}",style: Mystyle().subText,),
                Text('રકમ : ${int.parse(_list[index].emi_amount) + int.parse(_list[index].panalti_amount)}',style: Mystyle().subText),
                Constants.USER_TYPE != "3" ? InkWell(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(
                          Icons.done,
                          size: 35,
                          color: Colors.blue,
                        ),
                      ),
                      onTap: () {
                        TxnDone(index);//ConfirmEMI(index);
                      },
                    ),
                  ),
                ) :Container()
              ],
            ) :
            Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("તારીખ : ${_list[index].date}",style: Mystyle().subText,),
              Text('રકમ : ${int.parse(_list[index].emi_amount) + int.parse(_list[index].panalti_amount)}',style: Mystyle().subText),
              Text("જમા તારીખ : ${_list[index].receive_date}",style: Mystyle().subText,),
              Text("જમા લેનાર : ${_list[index].to_name}",style: Mystyle().subText,)
            ],
          ),
          ),
        );
      },
    ));
  }
  void scrollTo(int index) {
    print("scroll called");
    itemScrollController.scrollTo(
        index: index,
        duration: Duration(seconds: 1),
        curve: Curves.easeInOutCubic,
        alignment: 0);
  }
  ConfirmEMI(index) {
    // set up the buttons
    Widget yesBTn1 = Padding(
      padding: EdgeInsets.all(10),
      child: RoundedLoadingButton(
        child: Text('હાં', style: TextStyle(color: Colors.green, fontSize: 20)),
        controller: _btnController,
        onPressed: () => TxnDone(index),
        width: 80,
        color: Colors.grey[200],
        successColor: Colors.green,
        valueColor: Colors.black,
      ),
    );
    Widget noBTn = RoundedLoadingButton(
      child: Text('નાં', style: TextStyle(color: Colors.red, fontSize: 20)),
      onPressed: () {
        Navigator.pop(context);
      },
      width: 80,
      animateOnTap: false,
      color: Colors.grey[200],
      successColor: Colors.green,
      valueColor: Colors.black,
    );

    AlertDialog alert = new AlertDialog(
        shape: Mystyle().RoundShape,
        title: Text(
          "હપ્તા ની પુષ્ટિ કરો",
          style: Mystyle().InputStyle,
        ),
        content: Text(
          "શું તમે આ રકમ જમા કરવાં કરવા માંગો છો?",
          style: Mystyle().subText,
        ),
        actions: [
          noBTn,
          yesBTn1,
        ],
      );
    // show the dialog
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  SearchFilter(String _searchTxt){
    print("enterd");
    setState(() {
      _list = _Fulllist.where((txn) => txn.from_name.toLowerCase().contains(_searchTxt.toLowerCase())).toList();

    });
    //print(_list);
  }
  RefreshData(){
    isLoading = false;
    GetTxnAPI().whenComplete(()
    {
      isLoading = true;
      _list = List.from(_Fulllist);

      AppController().setSelMY(month,year);
      if (_list != null && _list.length > 0) {
        Timer(Duration(seconds: 1), () {
          scrollTo(ScrIndex);
        });
      }
    });
  }

  void TxnDone(index){
    UpdateTxnAPI(_list[index].id,_list[index].date).whenComplete(()
    {
      //Navigator.pop(context);
      GetTxnAPI().whenComplete(()
      {
        isLoading = true;
        _list = List.from(_Fulllist);

        if (_list != null && _list.length > 0) {
          Timer(Duration(seconds: 1), () {
            scrollTo(ScrIndex);
          });
        }
      });
    });
  }
  Future<void> UpdateTxnAPI(String txnId, String date) async {
    isLoading = false;
    Response response;
    Dio dio = new Dio();


    var newDate = "";

    try {
      var queryParameters = {
        "txn_to":Constants.USERID,
        "txn_id":txnId,
        "date" : date
      };

      response = await dio.post(Constants.API_UPDATETXN, data: queryParameters).timeout(Constants.API_TIMEOUT);

      if (response != null && response.data != null) {
        var nodata = response.data["nodata"];
        var resCode = nodata["response_code"];
        //var msg = nodata["msg"];

        print("nodata is $nodata");
        if (resCode == Constants.CODE_SUCESS) {
          setState(() {
            //isLoading = true;
            //_btnController.success();
          });
        } else  {
          AppController().ShowToast(text: Constants.NO_REACHABILITY);
          setState(() {
            //isLoading = true;
          });
        }
      }
    } catch (e) {
      print("excep " + e.toString());
      AppController().ShowToast(text: Constants.NO_INTERNET);
    }
  }

  Future<void> GetTxnAPI() async {

    isLoading = false;
    _Fulllist = [];

    Response response;
    Dio dio = new Dio();

    try{
      var queryParameters;
      if(month != "0"){
        queryParameters = {'year': year, 'month' : month};
      }
      else{
        queryParameters = {'year': year};
      }
      print(queryParameters);

      response = await dio.post(Constants.API_GETTXN,data: queryParameters).timeout(Constants.API_TIMEOUT);

      if (response != null && response.data != null) {

        var nodata = response.data["nodata"];
        var resCode = nodata["response_code"];
        //var msg = nodata["msg"];

        print(nodata);

        if(resCode == Constants.CODE_SUCESS){

          var data = response.data["data"];
          ScrIndex = data.length - 1;
          setState(() {
            for(var element in data){
              _Fulllist.add(TxnList.fromJson(element));
            }

            _Fulllist.sort((a, b) => a.date.compareTo(b.date));

            int cnt = 0; bool chk = false;
            for(var element in _Fulllist){
              if(element.status == "0" && !chk){
                chk = true;
                print(ScrIndex);
                ScrIndex = cnt;
                break;
              }
              cnt++;
            }

            print(ScrIndex);
            isLoading =true;
          });
          //AppController().ShowToast(text: "${data.length} Loans Found");
        }
        else if(resCode == Constants.CODE_WRONG_INPUT){
          //AppController().ShowToast(text:msg,bgColor: Colors.red);
          setState(() {
            isLoading = true;
          });
        }
        else if(resCode == Constants.CODE_CONFLICT){
          //AppController().ShowToast(text:msg,bgColor: Colors.red);
          setState(() {
            isLoading = true;
          });
        }
        else if (resCode == Constants.CODE_UNREACHBLE) {
          //AppController().ShowToast(text: Constants.NO_REACHABILITY);
          setState(() {
            isLoading = true;
          });
        }
        else if (resCode == Constants.CODE_NULL) {
          //AppController().ShowToast(text: Constants.NO_DATA);
          setState(() {
            isLoading = true;
          });
        }
      }
    }
    catch(e){
      print("excep "+e.toString());
      AppController().ShowToast(text: Constants.NO_INTERNET);
    }
  }
}



