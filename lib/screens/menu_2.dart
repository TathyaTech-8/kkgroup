import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:kkgroup/models/AppController.dart';
import 'package:kkgroup/models/Constants.dart';
import 'package:kkgroup/models/GetPDF.dart';
import 'package:kkgroup/models/models.dart';
import 'package:kkgroup/models/styles.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';


class TODAY_COLL extends StatefulWidget {
  int PageIndex;
  TODAY_COLL({this.PageIndex});

  @override
  _TODAY_COLLState createState() => _TODAY_COLLState(PageIndex: this.PageIndex);
}
class _TODAY_COLLState extends State<TODAY_COLL> {

  final int PageIndex;
  bool isLoading = false;

  int ScrIndex = 0;
  int TotalAmt = 0;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  final _searchController = new TextEditingController();
  final _btnController = new RoundedLoadingButtonController();

  final _formKey = GlobalKey<FormState>();

  List <CollectionList> _Fulllist = [];
  List <CollectionList> _list = [];
  GetCustomer customer = new GetCustomer();
  GetLoans loan = new GetLoans();

  GetCustomer CustRegModel = new GetCustomer();

  void initState(){
    super.initState();
    GetEmiOnDateAPI().whenComplete(() {
      isLoading = true;
      _list = List.from(_Fulllist);

      TotalAmt = 0;
      for(var element in _Fulllist){
        TotalAmt = TotalAmt + int.parse(element.emi_amount);
      }

      if (_list != null && _list.length > 0) {
        Timer(Duration(seconds: 1), () {
          scrollTo(ScrIndex);
        });
      }

    });
  }

  getPDF(){
    if(isLoading && _list.length > 0){
      DateTime now = new DateTime.now();
      String date = "${now.day}-${now.month}-${now.year}";
      GetPDF().getTodayList(_list, date, false);
    }
    else{
      AppController().showToast(text: Constants.NO_DATA);
    }
  }

  Future<bool> _onWillPop() async {
    return isLoading;
  }
  _TODAY_COLLState({this.PageIndex});
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
        //margin: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MainCard(),
              isLoading ? _list != null && _list.length > 0 ?
              ListCard() : Center(child: Text(Constants.NO_DATA,style: Mystyle().subText,),) : Center(child: CircularProgressIndicator())
            ],
          )
      ),
    ), onWillPop: _onWillPop);
  }
  void scrollTo(int index) {
    print("scroll called");
    itemScrollController.scrollTo(
        index: index,
        duration: Duration(seconds: 1),
        curve: Curves.easeInOutCubic,
        alignment: 0);
  }

  ListCard(){
    return Expanded(child: ScrollablePositionedList.builder(
        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
        itemCount: _list.length,
        itemScrollController: itemScrollController,
        itemPositionsListener: itemPositionsListener,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) => Card(
        color: index%2 == 0 ? Colors.grey[200]:Colors.white,
        shape: Mystyle().RoundShape,
        margin: EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          onTap: (){

            AppController.showLoader(context);
            GoToLoanPage(context,index);

            },
          title: Text(_list[index].cust_name,style:Mystyle().InputStyle,),
          subtitle:_list[index].emi_status == "0" ?Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("ડાયરી નં : ${_list[index].loan_id}",style: new TextStyle(fontSize: 20),),
              Text("હપ્તો : ${_list[index].emi_amount}",style: new TextStyle(fontSize: 20),),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.call_rounded,
                        size: 35,
                        color: Colors.green,
                      ),
                    ),
                    onTap: () => AppController().CallDialog(
                        context, [_list[index].cust_mobile, _list[index].cust_mobile2]),
                  ),
                  SizedBox(width: 5,),
                  InkWell(
                    child: SizedBox(width: 50,height: 50,child: Icon(Icons.done,size: 35,color: Colors.pink,),),
                    onTap: () {
                      bool flag = AppController.GetDateDiff(_list[index]?.emi_date??"");
                      ConfirmEMI(index,flag);
                    },
                  ),

                ],
              ),
            ],
          ) :
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("ડાયરી નં : ${_list[index].loan_id}",style: new TextStyle(fontSize: 20),),
              Text("જમા હપ્તો : ${_list[index].emi_amount}",style: new TextStyle(fontSize: 20),),
              Text("જમા લેનાર : ${_list[index].emi_rcvd_by}",style: new TextStyle(fontSize: 20),),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.call_rounded,
                        size: 35,
                        color: Colors.green,
                      ),
                    ),
                    onTap: () => AppController().CallDialog(
                        context, [_list[index].cust_mobile, _list[index].cust_mobile2]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }

  ConfirmEMI(index, bool flag){
    // set up the buttons
    Widget yesBTn =  Padding(padding: EdgeInsets.all(10),child: RoundedLoadingButton(
      child: Text('હાં', style: TextStyle(color: Colors.green,fontSize: 20)),
      controller: _btnController,
      onPressed: () => UpdateEmiAPI(_list[index].emi_id,index).whenComplete(() {
        isLoading = false;
        Navigator.pop(context);
        GetEmiOnDateAPI().whenComplete(() {
          isLoading = true;
          _list = List.from(_Fulllist);

          TotalAmt = 0;
          for(var element in _Fulllist){
            TotalAmt = TotalAmt + int.parse(element.emi_amount);
          }
        });
      }),
      width: 80,
      color: Colors.grey[200],
      successColor: Colors.green,
      valueColor: Colors.black,
    ),);
    Widget noBTn =  RoundedLoadingButton(
      child: Text('નાં', style: TextStyle(color: Colors.red,fontSize: 20)),
      onPressed: () {Navigator.pop(context);},
      width: 80,
      animateOnTap: false,
      color: Colors.grey[200],
      successColor: Colors.green,
      valueColor: Colors.black,
    );

    AlertDialog alert = new AlertDialog(
        shape: Mystyle().RoundShape,
        title: Text("હપ્તા ની પુષ્ટિ કરો",style: Mystyle().InputStyle,),
        content: Text("શું તમે આ હપ્તો જમા કરવાં કરવા માંગો છો?",style: Mystyle().subText,),
        actions: [
          noBTn,
          yesBTn,
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
      _list = _Fulllist.where((customer) => customer.cust_name.toLowerCase().contains(_searchTxt.toLowerCase())).toList();
    });
    //print(_list);
  }
  void _doSomething(index) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

    }
    else{
      _btnController.reset();
      //AppController().ShowToast(text: "કૃપા કરી નામ / મોબાઇલ નંબર નાખો");
    }
  }

  Future<void> UpdateEmiAPI(String emiId,int index) async {
    //isLoading = false;
    Response response;
    Dio dio = new Dio();

    //int panelty = int.parse(_amtPenController.text);
    int rcvd_amt = int.parse(_list[index].emi_amount);

    try{
      var queryParameters = {"emi_pnalt":"0",
        "rcvd_amount":rcvd_amt,
        "tm_id":Constants.USERID,
        "emi_id":emiId,
        "emi_status":"1",
        "loan_id" : _list[index].loan_id
      };

      response = await dio.post(Constants.API_UPDATEEMI,data: queryParameters).timeout(Constants.API_TIMEOUT);

      if (response != null && response.data != null) {

        var nodata = response.data["nodata"];
        var resCode = nodata["response_code"];
        //var msg = nodata["msg"];

        if(resCode == Constants.CODE_SUCESS){
          setState(() {
            _btnController.success();
          });
        }
        else if(resCode == Constants.CODE_WRONG_INPUT){
          //AppController().ShowToast(text:msg,bgColor: Colors.red);
        }
        else if(resCode == Constants.CODE_CONFLICT){
          //AppController().ShowToast(text:msg,bgColor: Colors.red);
        }
        else if (resCode == Constants.CODE_UNREACHBLE) {
          //AppController().ShowToast(text: Constants.NO_REACHABILITY);
        }
        else if (resCode == Constants.CODE_NULL) {
          //AppController().ShowToast(text: Constants.NO_DATA);
        }
      }
    }
    catch(e){
      print("excep "+e.toString());
      AppController().showToast(text: Constants.NO_INTERNET);
    }
  }
  Future<void> GetEmiOnDateAPI() async {

    _Fulllist = [];
    _list = [];
    Response response;
    Dio dio = new Dio();

    try{
      var queryParameters = {'emi_list': "today",};

      response = await dio.post(Constants.API_GETEMIONDATE,data: queryParameters).timeout(Constants.API_TIMEOUT);

      if (response != null && response.data != null) {

        var nodata = response.data["nodata"];
        var resCode = nodata["response_code"];
        //var msg = nodata["msg"];

        print(nodata);

        if(resCode == Constants.CODE_SUCESS){

          var data = response.data["data"];
          ScrIndex = data.length - 1;
          setState(() {
            int cnt = 0; bool chk = false;
            for(var element in data){
              _Fulllist.add(CollectionList.fromJson(element));
              if(element["emi_status"] == "0" && !chk){
                chk = true;
                ScrIndex = cnt;
              }
              cnt++;
            }
            isLoading =true;
          });
          //AppController().ShowToast(text: "${data.length} EMI Found");
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
      AppController().showToast(text: Constants.NO_INTERNET);
    }
  }
  Future<void> GetCustAPI(String id) async {
    Response response;
    Dio dio = new Dio();

    try{
      var queryParameters = {"cust_id": id,};
      print(queryParameters);
      response = await dio.post(Constants.API_GETCUST,data: queryParameters).timeout(Constants.API_TIMEOUT);
      if (response != null && response.data != null) {

        var nodata = response.data["nodata"];
        if(nodata["response_code"] == Constants.CODE_SUCESS){

          var data = response.data["data"];
          setState(() {
              customer = GetCustomer.fromJson(data[0]);
          });
          print("cst data chk = ${customer.cust_id} ${data.length}");
        }
        else if(nodata["response_code"] == Constants.CODE_NULL){
          AppController().showToast(text: Constants.NO_DATA);
        }
      }
      else {
        //AppController().ShowToast(text: Constants.NO_REACHABILITY);
      }
      //print("GEtData Response : ${response.data}");
    }
    catch(e){
      print(e.toString());
      AppController().showToast(text: Constants.NO_INTERNET);
    }
  }
  Future<void> GetLoansAPI(String cust_id,String loan_id) async {

    Response response;
    Dio dio = new Dio();

    try{
      var queryParameters = {"cust_id":cust_id, "loan_id":loan_id};

      response = await dio.post(Constants.API_GETLOANS,data: queryParameters).timeout(Constants.API_TIMEOUT);

      if (response != null && response.data != null) {

        var nodata = response.data["nodata"];
        var resCode = nodata["response_code"];
        //var msg = nodata["msg"];

        print(nodata);

        if(resCode == Constants.CODE_SUCESS){

          var data = response.data["data"];

          setState(() {
              loan = GetLoans.fromJson(data[0]);
              print("data chk = ${loan.id} ${data.length}");
          });
        }
        else if (resCode == Constants.CODE_UNREACHBLE) {
          //AppController().ShowToast(text: Constants.NO_REACHABILITY);
        }
        else if (resCode == Constants.CODE_NULL) {
          AppController().showToast(text: Constants.NO_DATA);
        }
      }
    }
    catch(e){
      print("excep "+e.toString());
      AppController().showToast(text: Constants.NO_INTERNET);
    }
  }
  MainCard(){
    return Card(
      margin: EdgeInsets.all(15),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("કુલ રકમ : $TotalAmt",style: Mystyle().InputStyle,),
          ],
        ),
      ),
    );
  }
  void GoToLoanPage(BuildContext context,int index) {
    try{
      GetCustAPI(_list[index].cust_id).whenComplete((){
        GetLoansAPI(_list[index].cust_id, _list[index].loan_id).whenComplete(() {
          Navigator.pop(context);
          RouteController().GoTo(context,Constants.EMI_LIST_SCREEN,cust : customer,loan : loan);
        });
      });
    }
    catch(e){
      print(e.toString());
    }
  }
}
