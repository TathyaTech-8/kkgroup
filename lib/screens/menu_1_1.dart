import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:kkgroup/models/AppController.dart';
import 'package:kkgroup/models/Constants.dart';
import 'package:kkgroup/models/models.dart';
import 'package:kkgroup/models/styles.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../models/InputFields.dart';
import 'menu_1_1_1.dart';

class LOANLIST extends StatefulWidget {
  int PageIndex;
  GetCustomer customer;
  
  LOANLIST({this.PageIndex,this.customer});
  @override
  _LOANLISTState createState() => _LOANLISTState(PageIndex: this.PageIndex,customer : this.customer);
}

class _LOANLISTState extends State<LOANLIST> {

  final int PageIndex;
  final GetCustomer customer;
  bool isLoading=false;

  final _nameController = new TextEditingController();
  final _phoneController = new TextEditingController();
  final _phone2Controller = new TextEditingController();
  final _addressController = new TextEditingController();

  final _amtLoanController = new TextEditingController();
  final _amtGivenController = new TextEditingController();
  final _emiTotalController = new TextEditingController();
  final _emiDayController = new TextEditingController();
  final _amtIntController = new TextEditingController();
  final _amtEmiController = new TextEditingController();
  final _dateController = new TextEditingController();
  final _btnController = new RoundedLoadingButtonController();

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  List <GetLoans> LoanList = [];
  GetLoans GetLoansModel = new GetLoans();
  LoanReg LoanRegModel = new LoanReg();

  void initState(){
    super.initState();
    _amtLoanController.text = "0";
    _amtGivenController.text = "0";
    _emiTotalController.text = "0";
    print("cust id = ${customer.cust_id}");
    _dateController.text = DateTime.now().toString();

    GetLoansAPI(customer.cust_id).whenComplete(() => {
      isLoading = true
    });

  }

  FutureOr onBack(){
    print("Yooooo I m BAck");
    setState(() {
      isLoading = false;
    });
    GetLoansAPI(customer.cust_id).whenComplete(()  {
      print(LoanList.length);
      isLoading = true;
    });
  }

  Future<bool> _onWillPop() async {
    return isLoading;
  }
  _LOANLISTState({this.PageIndex,this.customer});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: GFAppBar(
        title: Text("ગ્રાહક ની વિગત"),
        searchBar: false,
      ),
      //drawer: MyDrawer(PageIndex),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddLoan(),
        child: Icon(Icons.add,size: 30,),
      ),
      body: Container(
        //margin: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              margin: EdgeInsets.all(15),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.customer?.cust_name,style: Mystyle().InputStyle,),
                    Text("મોબાઇલ નં : ${widget.customer.cust_mobile}",style: Mystyle().subText,),
                    customer.cust_mobile2!="" && customer.cust_mobile2!="0"?Text("મોબાઇલ ૨ નં : ${widget.customer.cust_mobile2}",style: Mystyle().subText,):Container(),
                    Text("સરનામું : ${widget.customer.cust_address}",style: Mystyle().subText,maxLines: 3,),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          child: SizedBox(width: 50,height: 50,child: Icon(Icons.call_rounded,size: 35,color: Colors.green,),),
                          onTap: ()=>AppController().CallDialog(context, [customer.cust_mobile,customer.cust_mobile2]),
                        ),
                        SizedBox(width: 10,),
                        InkWell(
                          child: SizedBox(width: 50,height: 50,child: Icon(Icons.edit_rounded,size: 35,color: Colors.blue,),),
                          onTap: ()=> {EditCustomer()},
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            isLoading ?
            LoanList!=null && LoanList.length>0 ? Expanded(child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
              itemCount: LoanList.length,
              itemBuilder: (context,index){
                return Card(
                  color: index%2 == 0 ? Colors.grey[200]:Colors.white,
                  shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    trailing: Icon(Icons.album,color: LoanList[index].status == "0" ? Colors.green : Colors.red,size: 40,),
                    title: Text("ડાયરી નં : ${LoanList[index].id}",style: Mystyle().InputStyle,),
                    subtitle:Text("રકમ : ${LoanList[index].amount} \t\t\t\t હપ્તા : ${LoanList[index].total_emi}",style: new TextStyle(fontSize: 20),),
                    onTap: () {
                      //RouteController().GoTo(context, Constants.EMI_LIST_SCREEN,customer,LoanList[index]);
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => EMILIST(customer: customer,loan: LoanList[index],))).then((value) => onBack());
                    },
                  ),
                );
              },
            )) : Center(child: Text(Constants.NO_DATA,style: Mystyle().subText,),) :

            Center(child: CircularProgressIndicator())
          ],
        ),
      ),
    ), onWillPop: _onWillPop);
  }

  EditCustomer(){
    _nameController.text = customer.cust_name;
    _phoneController.text = customer.cust_mobile;
    _phone2Controller.text = customer.cust_mobile2;
    _addressController.text = customer.cust_address;

    return showDialog(context: context,barrierDismissible: false,builder: (context)
    {
      return Dialog(
        shape: Mystyle().RoundShape,
        backgroundColor: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //Text("નવો ગ્રાહક ઉમેરો",style: new TextStyle(fontSize: 35,),),
                  InputFieldArea2(hint: "ગ્રાહક નું નામ",icon: Icons.person,obscure: false,errorTxt: "ગ્રાહક નું નામ દાખલ કરો",controller: _nameController,),
                  SizedBox(height: 18,),
                  InputFieldArea2(hint: "મોબાઇલ નંબર",icon: Icons.phone_android_outlined,obscure: false,errorTxt: "મોબાઇલ નંબર દાખલ કરો",maxLen: 10,controller: _phoneController,keyBoard: TextInputType.phone,),
                  SizedBox(height: 18,),
                  InputFieldArea2(hint: "મોબાઇલ નંબર",icon: Icons.phone_android_outlined,obscure: false,errorTxt: "મોબાઇલ નંબર દાખલ કરો",maxLen: 10,controller: _phone2Controller,keyBoard: TextInputType.phone,required: false,),
                  SizedBox(height: 18,),
                  InputFieldArea2(hint: "સરનામું",icon: Icons.location_on,obscure: false,errorTxt: "સરનામું દાખલ કરો",controller: _addressController,required: false,),
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
                              controller: _btnController,
                              onPressed: _doSomething2,
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
                                Navigator.of(context).pop();
                              },
                              width: MediaQuery.of(context).size.width*0.3,
                              color: Colors.grey[200],
                            )
                          ],
                        )
                    ),)
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
  void _doSomething2() async {
    if (_formKey2.currentState.validate()) {
      _formKey2.currentState.save();
      CustRegAPI().whenComplete(() {
        setState(() {
          customer.cust_name = _nameController.text;
          customer.cust_mobile = _phoneController.text;
          customer.cust_mobile2 = _phone2Controller.text;
          customer.cust_address = _addressController.text;
        });
        Navigator.of(context).pop();
      });
    }
    else{
      _btnController.reset();
      //AppController().ShowToast(text: "કૃપા કરી નામ / મોબાઇલ નંબર નાખો");
    }
  }
  Future CustRegAPI() async {
    Response response;
    Dio dio = new Dio();

    var queryParameters = {
      'cust_name': _nameController.text,
      'cust_mobile': _phoneController.text,
      'cust_mobile2': _phone2Controller.text,
      'cust_address': _addressController.text,
      'cust_id': customer.cust_id,
    };

    //var json = jsonEncode(CustRegModel);

    try{
      response = await dio.post(Constants.API_ADDCUST, data: queryParameters).timeout(Constants.API_TIMEOUT);

      if (response != null && response.data != null) {

        var nodata = response.data["nodata"];
        var resCode = nodata["response_code"];
        //var msg = nodata["msg"];

        if(resCode == Constants.CODE_SUCESS){
          _btnController.success();
        }
        else if(resCode == Constants.CODE_WRONG_INPUT){
          //AppController().ShowToast(text:msg,bgColor: Colors.red);
          _btnController.reset();
        }
        else if(resCode == Constants.CODE_CONFLICT){
          //AppController().ShowToast(text:Constants.MOBILE_EXIST,bgColor: Colors.red);
          _phoneController.text = "";
          _btnController.reset();
        }
        else if (resCode == Constants.CODE_UNREACHBLE) {
          //AppController().ShowToast(text: Constants.NO_REACHABILITY);
          _btnController.reset();
        }
        else if (resCode == Constants.CODE_NULL) {
          //AppController().ShowToast(text: Constants.NO_DATA);
          _btnController.reset();
        }
      }
    }
    catch(e){
      print(e.toString());
      AppController().showToast(text: Constants.NO_INTERNET);
      _btnController.reset();
    }

    print("Response:- " + response.data.toString());
  }


  CalculateValues(){
    int Loan = 0,TotalEmi = 1,Given = 0;
    if(_amtLoanController.text.isNotEmpty && _amtLoanController.text.length > 0){
      Loan = int.parse(_amtLoanController.text);
    }
    if(_amtGivenController.text.isNotEmpty && _amtGivenController.text.length > 0){
      Given = int.parse(_amtGivenController.text);
    }
    if(_emiTotalController.text.isNotEmpty && _emiTotalController.text.length > 0){
      TotalEmi = int.parse(_emiTotalController.text);
    }

    int intrst = Loan - Given;
    double emi = Loan / TotalEmi;

    setState(() {
      _amtIntController.text = intrst.toString();
      _amtEmiController.text = emi.toString();
    });

  }
  AddLoan(){
    _amtLoanController.text = "";
    _amtGivenController.text = "";
    _emiTotalController.text = "";
    _emiDayController.text = "";
    _amtIntController.text = "";
    _amtEmiController.text = "";



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
                  AppController().DatePicker(_dateController),
                  //Text("નવો ગ્રાહક ઉમેરો",style: new TextStyle(fontSize: 35,),),
                  InputFieldArea2(hint: "લોન ની રકમ",icon: Icons.monetization_on_rounded,obscure: false,errorTxt: "લોન ની રકમ દાખલ કરો",controller: _amtLoanController,keyBoard: TextInputType.number,onChanged: (value) {
                    CalculateValues();
                  },),
                  SizedBox(height: 18,),
                  InputFieldArea2(hint: "આપેલ રકમ",icon: Icons.money,errorTxt: "આપેલ રકમ દાખલ કરો",maxLen: 10,controller: _amtGivenController,keyBoard: TextInputType.number,onChanged: (value) {
                    CalculateValues();
                  },),
                  SizedBox(height: 18,),
                  InputFieldArea2(hint: "કુલ હપ્તા",icon: Icons.lock_clock,errorTxt: "કુલ હપ્તા દાખલ કરો",maxLen: 10,controller: _emiTotalController,keyBoard: TextInputType.number,onChanged: (value) {
                    CalculateValues();
                  },),
                  SizedBox(height: 18,),
                  InputFieldArea2(hint: "હપ્તા ના દિવસ",icon: Icons.date_range,errorTxt: "હપ્તા ના દિવસ દાખલ કરો",controller: _emiDayController,keyBoard: TextInputType.number,),
                  SizedBox(height: 18,),
                  InputFieldArea2(hint: "વ્યાજ કપાત",icon: Icons.money_off,errorTxt: "મોબાઇલ નંબર દાખલ કરો",maxLen: 10,controller: _amtIntController,keyBoard: TextInputType.number,enable: false,),
                  SizedBox(height: 18,),
                  InputFieldArea2(hint: "હપ્તા ની રકમ",icon: Icons.attach_money,errorTxt: "મોબાઇલ નંબર દાખલ કરો",maxLen: 10,controller: _amtEmiController,keyBoard: TextInputType.number,enable: false,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: SizedBox(
                      width: double.infinity, //Full width
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RoundedLoadingButton(
                            child: Text('ડાયરી ઉમેરો', style: TextStyle(color: Colors.black,fontSize: 20)),
                            controller: _btnController,
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
                              print(_dateController.text);
                              Navigator.of(context).pop();
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
  void _doSomething() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      LoanRegAPI().whenComplete(() {
        Navigator.of(context).pop();
        isLoading = false;
        GetLoansAPI(customer.cust_id);
      });
    }
    else{
      _btnController.reset();
      //AppController().ShowToast(text: "કૃપા કરી નામ / મોબાઇલ નંબર નાખો");
    }
  }
  Future LoanRegAPI() async {

    Response response;
    Dio dio = new Dio();

    var queryParameters = {
      'cust_id': customer.cust_id,
      'loan_amount': _amtLoanController.text,
      'givan_amount': _amtGivenController.text,
      'emi_amount': _amtEmiController.text,
      'total_emi': _emiTotalController.text,
      'emi_day': _emiDayController.text,
      'issue_by': Constants.USERID,
      'date' : _dateController.text
    };

    try{
      response = await dio.post(Constants.API_ADDLOAN, data: queryParameters).timeout(Constants.API_TIMEOUT);

      if (response != null && response.data != null) {

        var nodata = response.data["nodata"];
        var resCode = nodata["response_code"];
        //var msg = nodata["msg"];

        if(resCode == Constants.CODE_SUCESS){

          _btnController.success();
          //AppController().ShowToast(text: "${data.length} Loan Found");
        }
        else if(resCode == Constants.CODE_WRONG_INPUT){
          //AppController().ShowToast(text:msg,bgColor: Colors.red);
          _btnController.reset();
        }
        else if(resCode == Constants.CODE_CONFLICT){
          //AppController().ShowToast(text:Constants.MOBILE_EXIST,bgColor: Colors.red);
          _btnController.reset();
        }
        else if (resCode == Constants.CODE_UNREACHBLE) {
          //AppController().ShowToast(text: Constants.NO_REACHABILITY);
          _btnController.reset();
        }
        else if (resCode == Constants.CODE_NULL) {
          //AppController().ShowToast(text: Constants.NO_DATA);
          _btnController.reset();
        }
      }
    }
    catch(e){
      print(e.toString());
      AppController().showToast(text: Constants.NO_INTERNET);
      _btnController.reset();
    }
    print("Response:- " + response.data.toString());
  }
  Future<void> GetLoansAPI(String CustId) async {

    LoanList = [];

    Response response;
    Dio dio = new Dio();

    try{
      var queryParameters = {'cust_id': CustId,};

      response = await dio.post(Constants.API_GETLOANS,data: queryParameters).timeout(Constants.API_TIMEOUT);

      if (response != null && response.data != null) {

        var nodata = response.data["nodata"];
        var resCode = nodata["response_code"];
        //var msg = nodata["msg"];

        print(nodata);

        if(resCode == Constants.CODE_SUCESS){

          var data = response.data["data"];
          setState(() {
            for(var element in data){
              LoanList.add(GetLoans.fromJson(element));
            }
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
      AppController().showToast(text: Constants.NO_INTERNET);
    }
  }

}
