import 'dart:async';

import 'package:date_util/date_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:kkgroup/models/AppController.dart';
import 'package:kkgroup/models/Constants.dart';
import 'package:kkgroup/models/GetPDF.dart';
import 'package:kkgroup/models/InputFields.dart';
import 'package:kkgroup/models/models.dart';
import 'package:kkgroup/models/styles.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class TEMILIST extends StatefulWidget {
  int PageIndex;
  GetTLoan loan;

  TEMILIST({this.PageIndex, this.loan});

  @override
  _TEMILISTState createState() => _TEMILISTState(PageIndex: this.PageIndex,  loan: this.loan);
}

class _TEMILISTState extends State<TEMILIST> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  int ScrIndex = 0;
  final int PageIndex;
  final GetTLoan loan;
  bool isLoading = false;

  int left_emi = 0;
  int left_amt = 0;
  int given_amt = 0;
  int scr_index = 0;

  final _phoneController = new TextEditingController();
  final _nameController = new TextEditingController();
  final _btnController2 = new RoundedLoadingButtonController();

  final _amtPenController = new TextEditingController();
  final _btnController = new RoundedLoadingButtonController();
  final _formKey = GlobalKey<FormState>();

  bool is1Pressed = false;
  bool is2Pressed = false;

  List<GetTEmi> _list = List<GetTEmi>();
  GetTEmi GetTEmiModel = new GetTEmi();

  void initState() {
    super.initState();

    GetTEmiAPI(loan.tl_id).whenComplete(() {
      int count = 0;
      for (var element in _list) {
        if (element.temi_status == "1") {
          count = count + 1;
        }
      }
      left_emi = _list.length - count;
      given_amt = int.parse(loan.tl_amount) - int.parse(loan.tl_advace);
      left_amt = count * int.parse(loan.tl_emi) + given_amt;
      isLoading = true;

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
    GetPDF().getTLoanDetailList(loan,_list);
  }

  _TEMILISTState({this.PageIndex, this.loan});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
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
            title: Text("લોન ની વિગત"),
            searchBar: false,
          ),
          body: Container(
            //margin: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MainCard(),
                isLoading
                    ? TEMILIST != null && _list.length > 0
                        ? ListCard()
                        : Center(child: Text(Constants.NO_DATA,style: Mystyle().subText,),)
                    : Center(child: CircularProgressIndicator())
              ],
            ),
          ),
        ),
        onWillPop: _onWillPop);
  }

  void scrollTo(int index) {
    print("scroll called");
    itemScrollController.scrollTo(
        index: index,
        duration: Duration(seconds: 1),
        curve: Curves.easeInOutCubic,
        alignment: 0);
  }

  ListCard() {
    return Expanded(
        child: ScrollablePositionedList.builder(
            itemCount: _list.length,
            itemBuilder: (context, index) => Card(
                  color: index % 2 == 0 ? Colors.grey[200] : Colors.white,
                  shape: Mystyle().RoundShape,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: ListTile(
                    title: Text(
                      "${index + 1}  | તારીખ : ${_list[index].temi_date}",
                      style: _list[index].temi_status == "0"
                          ? Mystyle().InputStyle
                          : new TextStyle(fontSize: 20),
                    ),
                    subtitle: _list[index].temi_status == "1"
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: 27,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("| આપેલ હપ્તા ની તારીખ : ${_list[index].temi_given_date}", style: new TextStyle(fontSize: 20),),
                                      Text("| જમા હપ્તો : ${_list[index].temi_amount}", style: new TextStyle(fontSize: 20),),
                                      //Text("| જમા હપ્તો : ${_list[index].rcvd}",style: new TextStyle(fontSize: 20),),
                                      Text("| જમા કરનાર : ${_list[index].tm_name}", style: new TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          )
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("\t\t\t\t\t | હપ્તો : ${_list[index].temi_amount}", style: new TextStyle(fontSize: 20),),
                              InkWell(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(child: SizedBox(
                                      width: 50, height: 50,
                                      child: Icon(Icons.done, size: 35, color: Colors.blue,),
                                    ),
                                    onTap: () {
                                      ConfirmEMI(index);
                                    },
                                  ),
                                ),
                              )
                            ],
                    ),
                  ),
                ),
            itemScrollController: itemScrollController,
            itemPositionsListener: itemPositionsListener,
            scrollDirection: Axis.vertical)

        /*ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
      itemCount: _list.length,
      itemBuilder: (context, index) => Card(
        color: index%2 == 0 ? Colors.grey[200]:Colors.white,
        shape: Mystyle().RoundShape,
        margin: EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          //trailing: _list[index].status == "0" ? Icon(Icons.done,color: Colors.green,size: 40,):Container(),
          title: Text("${index+1}  | તારીખ : ${_list[index].date}",style: _list[index].status == "0" ? Mystyle().InputStyle : new  TextStyle(fontSize: 20),),
          subtitle: _list[index].status == "1" ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(width: 27,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("| આવેલ હપ્તા ની તારીખ : ${_list[index].rcvd_date}",style: new TextStyle(fontSize: 20),),
                      Text("| પેનલ્ટી : ${_list[index].pnlti}\t\t          જમા હપ્તો : ${_list[index].rcvd}",style: new TextStyle(fontSize: 20),),
                      //Text("| જમા હપ્તો : ${_list[index].rcvd}",style: new TextStyle(fontSize: 20),),
                      Text("| જમા લેનાર : ${_list[index].rcvd_by}",style: new TextStyle(fontSize: 20),),
                    ],
                  )
                ],
              )
            ],
          ) : InkWell(
            child: Align(
              alignment: Alignment.centerRight,
              child:  InkWell(
                child: SizedBox(width: 50,height: 50,child: Icon(Icons.done,size: 35,color: Colors.blue,),),
                onTap: () {
                   bool flag = AppController.GetDateDiff(_list[index]?.date??"");
                   ConfirmEMI(index,flag);
                },
              ),
            ),
          ),
        ),
      ),
    )*/

        );
  }

  MainCard() {
    return Card(
      shape: Mystyle().RoundShape,
      margin: EdgeInsets.all(15),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${loan.tl_name}", style: Mystyle().InputStyle,),
            Padding(
              padding: EdgeInsets.fromLTRB(10,10,0,0),
              child:Text("તારીખ : ${loan.tl_date}", style: Mystyle().subText,),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("રકમ : ${loan.tl_amount}", style: Mystyle().subText,),
                      Text("કુલ હપ્તા : ${loan.tl_month}", style: Mystyle().subText,),
                      Text("બાકી મુદ્દલ : ${left_amt}", style: Mystyle().subText,),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("એડવાન્સ : ${loan.tl_advace}", style: Mystyle().subText,),
                      Text("વ્યાજ દર : ${loan.tl_irate}", style: Mystyle().subText,),
                      Text("બાકી હપ્તા : ${left_emi}", style: Mystyle().subText,),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10,5,0,0),
              child:Text("મોબાઇલ નં : ${loan.tl_mobile}", style: Mystyle().subText,),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  child: SizedBox(
                    width: 50, height: 50,
                    child: Icon(Icons.call_rounded, size: 35, color: Colors.green,),
                  ),
                  onTap: () => AppController().CallDialog(context, [loan.tl_mobile]),
                ),
                SizedBox(width: 10,),
                InkWell(
                  child: SizedBox(
                    width: 50, height: 50,
                    child: Icon(Icons.edit_rounded, size: 35, color: Colors.deepPurple,),
                  ),
                  onTap: UpdateData,
                ),
                SizedBox(width: 10,),
                if (Constants.USER_TYPE == "1"  && _list.length == left_emi && isLoading)
                  InkWell(
                    child: SizedBox(
                      width: 50, height: 50,
                      child: Icon(Icons.delete_forever, size: 35, color: Colors.red,),
                    ),
                    onTap: () => ConfirmDelete(),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  UpdateData(){
    _nameController.text = loan.tl_name;
    _phoneController.text = loan.tl_mobile;
    is2Pressed = false;

    return showDialog(context: context,barrierDismissible: false,builder: (context)
    {
      return Dialog(
        shape: Mystyle().RoundShape,
        backgroundColor: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height:18),
                  InputFieldArea2(hint: "નામ",icon: Icons.person_rounded,errorTxt: "નામ દાખલ કરો",maxLen: 10,controller: _nameController,),
                  SizedBox(height:18),
                  InputFieldArea2(hint: "મોબાઈલ નં.",icon: Icons.phone_android,errorTxt: "મોબાઈલ નં. દાખલ કરો",maxLen: 10,controller: _phoneController,keyBoard:TextInputType.number,),
                  SizedBox(height:18),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: SizedBox(
                      width: double.infinity, //Full width
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RoundedLoadingButton(
                            child: Text('સુધારો', style: TextStyle(color: Colors.black,fontSize: 20)),
                            controller: _btnController2,
                            onPressed: _doSomething,
                            width: MediaQuery.of(context).size.width*0.3,
                            color: Mystyle().BtnColor,
                            successColor: Colors.green,
                            valueColor: Colors.black,
                          ),
                          SizedBox(width: 20,),
                          RoundedLoadingButton(
                            animateOnTap: false,
                            child: Text('બંધ કરો', style: TextStyle(color: Colors.black,fontSize: 20)),
                            onPressed: () {
                              if(!is2Pressed){
                                Navigator.of(context).pop();
                              }
                            },
                            width: MediaQuery.of(context).size.width*0.3,
                            color: Colors.grey[200],
                          )
                        ],
                      ),
                    ),)
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  ConfirmDelete() {

    bool isPressed= false;
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "ના, રાખો",
        style: new TextStyle(color: Colors.green, fontSize: 20),
      ),
      onPressed: () {
        if(!isPressed){
          Navigator.pop(context);
        }
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "હાં, કાઢી નાખો",
        style: new TextStyle(color: Colors.red, fontSize: 20),
      ),
      onPressed: () {
        if(!isPressed){
          isPressed = true;
          DeleteLoanAPI(loan.tl_id).whenComplete(() {
            Navigator.of(context).pop();
          });
        }
        //RouteController().GoTo(context, Constants.TLOAN_SCREEN);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: Mystyle().RoundShape,
      title: Text(
        "ડિલીટ ની પુષ્ટિ કરો",
        style: Mystyle().InputStyle,
      ),
      content: Text(
          "શું તમે આ લોન અને તેના હપ્તા ડિલીટ કરવા માંગો છો?\nઆ ડેટા પાછો લાવી સકાશે નહીં"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  ConfirmEMI(index) {
    is1Pressed = false;
    // set up the buttons
    Widget yesBTn1 = Padding(
      padding: EdgeInsets.all(10),
      child: RoundedLoadingButton(
        child: Text('હાં', style: TextStyle(color: Colors.green, fontSize: 20)),
        controller: _btnController,
        onPressed: () => EmiDOne(index),
        width: 80,
        color: Colors.grey[200],
        successColor: Colors.green,
        valueColor: Colors.black,
      ),
    );
    Widget noBTn = RoundedLoadingButton(
      child: Text('નાં', style: TextStyle(color: Colors.red, fontSize: 20)),
      onPressed: () {
       if(!is1Pressed){ Navigator.pop(context);}
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
          "શું તમે આ હપ્તો જમા કરવાં કરવા માંગો છો?",
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

  void EmiDOne(index){
    if(is1Pressed){return;};
    is1Pressed = true;
    UpdateEmiAPI(_list[index].temi_id,_list[index].temi_amount).whenComplete(()
    {
      GetTEmiAPI(loan.tl_id).whenComplete(()
      {
        int count = 0;
        for (var element in _list) {
          if (element.temi_status == "0") {
            count = count + 1;
          }
        }
        left_emi = count;
        given_amt = int.parse(loan.tl_amount) - int.parse(loan.tl_advace);
        left_amt = count * int.parse(loan.tl_emi) + given_amt;

        isLoading = true;

        if (_list != null && _list.length > 0) {
          Timer(Duration(seconds: 1), () {
            scrollTo(ScrIndex);
          });
        }
        Navigator.pop(context);
      });
    });
  }

  void _doSomething() async {
    if(is2Pressed) {return;}
    if (_formKey.currentState.validate()) {
      is2Pressed = true;
      _formKey.currentState.save();
      UpdateDataAPI();
    } else {
      _btnController.reset();
    }
  }
  UpdateDataAPI() async {
    Response response;
    Dio dio = new Dio();


    try {
      var queryParameters = {
        "tl_id":loan.tl_id,
        "tl_name":_nameController.text,
        "tl_mobile":_phoneController.text
        //"date": date
      };
      print(queryParameters);

      response = await dio.post(Constants.API_UPDATETLAON, data: queryParameters).timeout(Constants.API_TIMEOUT);

      if (response != null && response.data != null) {
        var nodata = response.data["nodata"];
        var resCode = nodata["response_code"];

        if (resCode == Constants.CODE_SUCESS) {
          setState(() {
            _btnController2.success();
            loan.tl_name = _nameController.text;
            loan.tl_mobile = _phoneController.text;
            Navigator.of(context).pop();
          });
          return;
        } else {
          _btnController2.reset();
          //AppController().ShowToast(text: Constants.NO_DATA);
        }
        print("$response");
      }
    } catch (e) {
      _btnController2.reset();
      print("excep " + e.toString());
      AppController().ShowToast(text: Constants.NO_INTERNET);
    }
  }
  Future<void> UpdateEmiAPI(String emiId,String emi) async {
    isLoading = false;
    Response response;
    Dio dio = new Dio();


    DateTime now = new DateTime.now();
    var date = "${now.day}-${now.month}-${now.year}";
    try {
      var queryParameters = {
        "tm_id":Constants.USERID,
        "tlemi_id":emiId,
        "tlemi_amount":emi,
        //"date": date
      };
      print(queryParameters);

      response = await dio
          .post(Constants.API_UPDATETEMI, data: queryParameters)
          .timeout(Constants.API_TIMEOUT);

      if (response != null && response.data != null) {
        var nodata = response.data["nodata"];
        var resCode = nodata["response_code"];

        if (resCode == Constants.CODE_SUCESS) {
          setState(() {
            _btnController.success();
          });
        } else if (resCode == Constants.CODE_WRONG_INPUT) {
          //AppController().ShowToast(text: msg, bgColor: Colors.red);
          setState(() {
            isLoading = true;
          });
        } else if (resCode == Constants.CODE_CONFLICT) {
          //AppController().ShowToast(text: msg, bgColor: Colors.red);
          setState(() {
            isLoading = true;
          });
        } else if (resCode == Constants.CODE_UNREACHBLE) {
          //AppController().ShowToast(text: Constants.NO_REACHABILITY);
          setState(() {
            isLoading = true;
          });
        } else if (resCode == Constants.CODE_NULL) {
          //AppController().ShowToast(text: Constants.NO_DATA);
          setState(() {
            isLoading = true;
          });
        }
      }
    } catch (e) {
      print("excep " + e.toString());
      AppController().ShowToast(text: Constants.NO_INTERNET);
    }
  }

  Future<void> DeleteLoanAPI(String loanId) async {
    Response response;
    Dio dio = new Dio();

    try {
      var queryParameters = {
        'loan_id': loanId,
      };

      response = await dio.post(Constants.API_DELETETLOAN, data: queryParameters).timeout(Constants.API_TIMEOUT);

      if (response != null && response.data != null) {
        var nodata = response.data["nodata"];
        var resCode = nodata["response_code"];

        if (resCode == Constants.CODE_SUCESS) {
          setState(() {
            Navigator.pop(context);
          });
        } else if (resCode == Constants.CODE_WRONG_INPUT) {
          //AppController().ShowToast(text: msg, bgColor: Colors.red);
          setState(() {
            isLoading = true;
          });
        } else if (resCode == Constants.CODE_CONFLICT) {
          //AppController().ShowToast(text: msg, bgColor: Colors.red);
          setState(() {
            isLoading = true;
          });
        } else if (resCode == Constants.CODE_UNREACHBLE) {
          //AppController().ShowToast(text: Constants.NO_REACHABILITY);
          setState(() {
            isLoading = true;
          });
        } else if (resCode == Constants.CODE_NULL) {
          AppController().ShowToast(text: Constants.NO_DATA);
          setState(() {
            isLoading = true;
          });
        }
      }
    } catch (e) {
      print("excep " + e.toString());
      AppController().ShowToast(text: Constants.NO_INTERNET);
    }
  }

  Future<void> GetTEmiAPI(String loanId) async {
    _list = [];

    Response response;
    Dio dio = new Dio();

    try {
      var queryParameters = {
        'tl_loan_id': loanId,
      };

      response = await dio
          .post(Constants.API_GETTEMI, data: queryParameters)
          .timeout(Constants.API_TIMEOUT);

      if (response != null && response.data != null) {
        var nodata = response.data["nodata"];
        var resCode = nodata["response_code"];
        var msg = nodata["msg"];

        if (resCode == Constants.CODE_SUCESS) {
          var data = response.data["data"];
          ScrIndex = data.length - 1;
          setState(() {
            int cnt = 0; bool chk = false;
            for (var element in data) {
              _list.add(GetTEmi.fromJson(element));

              if(element["temi_status"] == "0" && !chk){
                chk = true;
                ScrIndex = cnt;
              }
              cnt++;
            }
            isLoading = true;
          });
          //AppController().ShowToast(text: "${data.length} EMI Found");
        } else if (resCode == Constants.CODE_WRONG_INPUT) {
          AppController().ShowToast(text: msg, bgColor: Colors.red);
          setState(() {
            isLoading = true;
          });
        } else if (resCode == Constants.CODE_CONFLICT) {
          AppController().ShowToast(text: msg, bgColor: Colors.red);
          setState(() {
            isLoading = true;
          });
        } else if (resCode == Constants.CODE_UNREACHBLE) {
          //AppController().ShowToast(text: Constants.NO_REACHABILITY);
          setState(() {
            isLoading = true;
          });
        } else if (resCode == Constants.CODE_NULL) {
          AppController().ShowToast(text: Constants.NO_DATA);
          setState(() {
            isLoading = true;
          });
        }
      }
    } catch (e) {
      print("excep " + e.toString());
      AppController().ShowToast(text: Constants.NO_INTERNET);
    }
  }
}
