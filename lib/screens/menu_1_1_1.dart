import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:kkgroup/models/AppController.dart';
import 'package:kkgroup/models/Constants.dart';
import 'package:kkgroup/models/GetPDF.dart';
import 'package:kkgroup/models/models.dart';
import 'package:kkgroup/models/styles.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';


class EMILIST extends StatefulWidget {
  int PageIndex;
  GetCustomer customer;
  GetLoans loan;

  EMILIST({this.PageIndex, this.customer, this.loan});

  @override
  _EMILISTState createState() => _EMILISTState(
      PageIndex: this.PageIndex, customer: this.customer, loan: this.loan);
}

class _EMILISTState extends State<EMILIST> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  int ScrIndex = 0;
  final int PageIndex;
  final GetCustomer customer;
  final GetLoans loan;
  bool isLoading = false;

  int left_emi = 0;
  int left_amt = 0;
  int given_amt = 0;
  int pnlt = 0;
  int scr_index = 0;

  final _amtPenController = new TextEditingController();
  final _btnController = new RoundedLoadingButtonController();
  final _btnController2 = new RoundedLoadingButtonController();
  final _formKey = GlobalKey<FormState>();

  List<GetEmi> _list = List<GetEmi>();
  GetEmi GetEmiModel = new GetEmi();

  void initState() {
    super.initState();

    print("dest chk ${customer.cust_id} -- ${loan.id}");

    GetEmiAPI(loan.id).whenComplete(() {
      int count = 0;
      for (var element in _list) {
        if (element.status == "1") {
          count = count + 1;
          pnlt = pnlt + int.parse(element.pnlti);
        }
      }
      left_emi = _list.length - count;
      left_amt = int.parse(loan.amount) - (count * int.parse(loan.emi_amount));
      given_amt = int.parse(loan.amount) - int.parse(loan.given_amount);
      isLoading = true;

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
      GetPDF().getLoanOnId(customer, loan, _list);
    }
    else{
      AppController().ShowToast(text: Constants.NO_DATA);
    }
  }

  Future<bool> _onWillPop() async {
    return isLoading;
  }

  _EMILISTState({this.PageIndex, this.customer, this.loan});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: GFAppBar(actions: [
            GFIconButton(
                color: Colors.lightGreen,
                splashColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 20),
                iconSize: 25,
                icon: Icon(Icons.print_rounded,size: 30,color: Colors.black,),
                onPressed: getPDF
            )
          ],
            title: Text("ડાયરી ${loan?.id ?? ""}"),
            searchBar: false,
          ),
          body:Container(
            //margin: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MainCard(),
                isLoading
                    ? EMILIST != null && _list.length > 0
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
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: ListTile(
                    //trailing: _list[index].status == "0" ? Icon(Icons.done,color: Colors.green,size: 40,):Container(),
                    title: Text(
                      "${index + 1}  | તારીખ : ${_list[index].date}",
                      style: _list[index].status == "0"
                          ? Mystyle().InputStyle
                          : new TextStyle(fontSize: 20),
                    ),
                    subtitle: _list[index].status == "1"
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 27,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "| આવેલ તારીખ : ${_list[index].rcvd_date}",
                                        style: new TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        "| પેનલ્ટી : ${_list[index].pnlti}\t\t\tજમા હપ્તો : ${_list[index].rcvd}",
                                        style: new TextStyle(fontSize: 18),
                                      ),
                                      //Text("| જમા હપ્તો : ${_list[index].rcvd}",style: new TextStyle(fontSize: 20),),
                                      Text(
                                        "| જમા લેનાર : ${_list[index].rcvd_by}",
                                        style: new TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          )
                        : InkWell(
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
                                  bool flag = AppController.GetDateDiff(
                                      _list[index]?.date ?? "");
                                  ConfirmEMI(index, flag);
                                },
                              ),
                            ),
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
            Text(
              "${customer.cust_name}",
              style: Mystyle().InputStyle,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: SingleChildScrollView(
                //clipBehavior: Clip.antiAlias,
                //scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("તારીખ : ${loan.date}", style: Mystyle().subText,),
                        SizedBox(height: 5,),
                        Text("આપેલ રકમ : ${loan.given_amount}", style: Mystyle().subText,), SizedBox(height: 5,), Text("હપ્તો : ${loan.emi_amount}", style: Mystyle().subText,), SizedBox(height: 5,),
                        Text("કુલ હપ્તા : ${loan.total_emi}", style: Mystyle().subText,), SizedBox(height: 5,),
                        Text("બાકી મુદ્દલ : ${left_amt}", style: Mystyle().subText,),
                      ],
                    ),
                    //SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("રકમ : ${loan.amount}", style: Mystyle().subText,),
                        SizedBox(height: 5,),
                        Text("વ્યાજ કપાત : ${given_amt}", style: Mystyle().subText,),
                        SizedBox(height: 5,),
                        Text("હપ્તા દિવસ : ${loan.emi_day}", style: Mystyle().subText,),
                        SizedBox(height: 5,),
                        Text("બાકી હપ્તા : ${left_emi}", style: Mystyle().subText,),
                        SizedBox(height: 5,),
                        Text("પેનલ્ટી : ${pnlt}", style: Mystyle().subText,),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  child: SizedBox(
                    width: 50, height: 50,
                    child: Icon(Icons.call_rounded, size: 35, color: Colors.green,),
                  ),
                  onTap: () => AppController().CallDialog(context, [customer.cust_mobile, customer.cust_mobile2]),
                ),
                SizedBox(width: 10,),
                if (Constants.USER_TYPE == "1" && _list.length == left_emi && isLoading)
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

  ConfirmDelete() {
    Widget ys = RoundedLoadingButton(
      child: Text('હાં, કાઢી નાખો', style: TextStyle(color: Colors.red,fontSize: 20)),
      controller: _btnController2,
      onPressed: (){
        DeleteLoanAPI(loan.id).whenComplete(() {
          Navigator.of(context).pop(customer);
        });
      },
      //width: MediaQuery.of(context).size.width*0.2,
      color: Colors.white,
      elevation: 0.0,
      successColor: Colors.green,
      valueColor: Colors.black,
    );
    Widget no = RoundedLoadingButton(
      child: Text('ના, રાખો', style: TextStyle(color: Colors.green,fontSize: 20)),
      animateOnTap: false,
      elevation: 0.0,
      onPressed: (){
        Navigator.pop(context);
      },
      //width: MediaQuery.of(context).size.width*0.2,
      color: Colors.white,
      valueColor: Colors.black,
    );
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(
        "ના, રાખો",

        style: new TextStyle(color: Colors.green, fontSize: 20),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "હાં, કાઢી નાખો",
        style: new TextStyle(color: Colors.red, fontSize: 20),
      ),
      onPressed: () {
        DeleteLoanAPI(loan.id).whenComplete(() {
          Navigator.of(context).pop(customer);
        });
        //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LOANLIST(customer: customer,)));
        //RouteController().GoTo(context, Constants.LOAN_LIST_SCREEN, customer);
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
        no,ys
        //cancelButton,
        //continueButton,
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

  ConfirmEMI(index, bool flag) {

    //TODO : Easy EMI Update
    EmiDOne(index);
    return;
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
    Widget yesBTn = Padding(
      padding: EdgeInsets.all(10),
      child: RoundedLoadingButton(
        child: Text('હાં', style: TextStyle(color: Colors.green, fontSize: 20)),
        controller: _btnController,
        onPressed: () => _doSomething(index),
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

    if(_amtPenController != null){
      _amtPenController.text = "";
    }
    AlertDialog alert;
    if (flag) {
      alert = new AlertDialog(
        shape: Mystyle().RoundShape,
        title: Text(
          "હપ્તા ની પુષ્ટિ કરો",
          style: Mystyle().InputStyle,
        ),
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "હપ્તા ની મુદ્દત પૂરી થઈ ગયેલ છે. કૃપા કરી પેનલ્ટી દાખલ કરો.",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Mystyle().subText,
              ),
              SizedBox(
                height: 10,
              ),
              Form(
                  key: _formKey,
                  child: TextFormField(
                    decoration: new InputDecoration(
                      counterText: "",
                      border: new OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                    ),
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    controller: _amtPenController,
                    style: Mystyle().InputStyle,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    maxLengthEnforced: true,
                    validator: (value) {
                      if (value.isEmpty)
                        return "પેનલ્ટી ની રકમ નાખો";
                      else if (value.isNotEmpty &&
                          int.parse(value.trim()) < 50) {
                        if (Constants.USER_TYPE == "1")
                          return null;
                        else
                          return "50 થી ઓછી રકમ માન્ય નથી";
                      } else
                        return null;
                    },
                  ))
            ],
          ),
        ),
        actions: [
          noBTn,
          yesBTn,
        ],
      );
    } else {
      alert = new AlertDialog(
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
    }
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
    AppController.showLoader(context); //TODO : Change When REmove Ease Emi
    UpdateEmiAPI(_list[index].id,loan.id,_list[index].date).whenComplete(()
    {
      isLoading = false;
      Navigator.pop(context);
      GetEmiAPI(loan.id).whenComplete(()
      {
        int count = 0;
        for (var element in _list) {
          if (element.status == "0") {
            count = count + 1;
          }
        }
        left_emi = count;
        left_amt = count * int.parse(loan.emi_amount);
        given_amt = int.parse(loan.amount) - int.parse(loan.given_amount);
        isLoading = true;

        if (_list != null && _list.length > 0) {
          Timer(Duration(seconds: 1), () {
            scrollTo(ScrIndex);
          });
        }
      });
    });
  }

  void _doSomething(int index) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      EmiDOne(index);
    } else {
      _btnController.reset();
    }
  }

  Future<void> UpdateEmiAPI(String emiId,String loanId,date) async {
    isLoading = false;
    Response response;
    Dio dio = new Dio();

    int panelty = int.parse(_amtPenController.text != "" ? _amtPenController.text : "0");
    int rcvd_amt = panelty + int.parse(loan.emi_amount);

    var inputFormat = DateFormat("dd/MM/yyyy");
    var date1 = inputFormat.parse(date);

    var outputFormat = DateFormat("yyyy-MM-dd");
    var date2 = outputFormat.parse("$date1");

    print(date2);
    try {
      var queryParameters = {
        "emi_pnalt": panelty,
        "rcvd_amount": rcvd_amt,
        "tm_id": Constants.USERID,
        "emi_id": emiId,
        "emi_status": "1",
        "loan_id" : loanId,
        "date" : "${date2.year}-${date2.month}-${date2.day}"
      };
      print(queryParameters);

      response = await dio
          .post(Constants.API_UPDATEEMI, data: queryParameters)
          .timeout(Constants.API_TIMEOUT);

      if (response != null && response.data != null) {
        var nodata = response.data["nodata"];
        var resCode = nodata["response_code"];
        //var msg = nodata["msg"];

        if (resCode == Constants.CODE_SUCESS) {
          setState(() {
            //_btnController.success(); TODO: CHange IT
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
          ////AppController().ShowToast(text: Constants.NO_REACHABILITY);
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
      print(queryParameters);

      response = await dio
          .post(Constants.API_DELETELOAN, data: queryParameters)
          .timeout(Constants.API_TIMEOUT);

      if (response != null && response.data != null) {
        var nodata = response.data["nodata"];
        var resCode = nodata["response_code"];
        //var msg = nodata["msg"];

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

  Future<void> GetEmiAPI(String loanId) async {
    _list = [];

    Response response;
    Dio dio = new Dio();

    try {
      var queryParameters = {
        'loan_id': loanId,
      };

      response = await dio
          .post(Constants.API_GETEMIS, data: queryParameters)
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
              _list.add(GetEmi.fromJson(element));

              if(element["emi_status"] == "0" && !chk){
                chk = true;
                ScrIndex = cnt;
              }
              cnt++;
            }
            isLoading = true;
          });
          AppController().ShowToast(text: "${data.length} EMI Found");
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
