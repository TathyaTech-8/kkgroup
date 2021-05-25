import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:kkgroup/models/AppController.dart';
import 'package:kkgroup/models/Constants.dart';
import 'package:kkgroup/models/GetPDF.dart';
import 'package:kkgroup/models/models.dart';
import 'package:kkgroup/models/styles.dart';
import 'package:kkgroup/screens/menu_5_1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_select/smart_select.dart';

class BANK_TOTAL extends StatefulWidget {
  int PageIndex;
  int getMonth;
  int getYear;
  BANK_TOTAL({this.PageIndex,this.getMonth,this.getYear});

  @override
  _BANK_TOTALState createState() => _BANK_TOTALState(PageIndex: this.PageIndex,getMonth:this.getMonth,getYear:this.getYear);
}

class _BANK_TOTALState extends State<BANK_TOTAL> {

  final int PageIndex;
  final int getMonth;
  final int getYear;

  bool isLoading = true;

  String month = Constants.SelMonth;
  String year = Constants.SelYear ;

  //final _btnController = new RoundedLoadingButtonController();



  List <BankData> _Fulllist = [];
  List <BankData> _list =[];

  List<int> Income = [];
  List<int> Expense = [];
  List<int> Saving = [];

  int TotalInc = 0;
  int TotalExp = 0;
  int TotaSaving = 0;
  int TotalLoan = 0;
  int Opning = 0;
  int Closing = 0;

  _BANK_TOTALState({this.PageIndex,this.getMonth,this.getYear});


  /*loadPrevMY() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if(!prefs.containsKey("M5_M")){
        month = getMonth.toString();
        year = getYear.toString();

        prefs.setString("M5_M", month);
        prefs.setString("M5_Y", year);
      }
      else{
        month = prefs.getString("M5_M");
        year = prefs.getString("M5_Y");
      }
    });

    print("in load $month $year");
  }*/
  setMYPref(year, month) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("M5_M", month);
    prefs.setString("M5_Y", year);
  }

  void initState(){
    super.initState();

    GetBankAPI().whenComplete(() {
      isLoading = true;
      _list = List.from(_Fulllist);
      if(_list.length > 0){CalculateValues();}
    });
  }

  CalculateValues(){
    Income = [];
    Expense = [];
    Saving = [];

    TotalInc = 0;
    TotalExp = 0;
    TotaSaving = 0;
    TotalLoan = 0;
    Opning = int.parse(_list[0].bl_open);
    Closing = int.parse(_list[_list.length-1].bl_cloas);

    print("$Opning    $Closing");

    for(var element in _list){
      int Inc = int.parse(element.bl_loan_amt) + int.parse(element.bl_emi_amount) + int.parse(element.bl_penlti_amount) + int.parse(element.bl_other_income??"0");
      //int Exp = int.parse(element.bl_loan_expance) + int.parse(element.bl_loan_given) + int.parse(element.bl_other_expance);
      int Exp = int.parse(element.bl_loan_expance) + int.parse(element.bl_other_expance);
      int Sav = int.parse(element.bl_saving) - int.parse(element.bl_other_expance) - int.parse(element.bl_loan_expance);

      Income.add(Inc);
      Expense.add(Exp);
      Saving.add(Sav);

      TotalLoan = TotalLoan + int.parse(element.bl_loan_given);
      TotalInc = TotalInc + Inc;
      TotalExp = TotalExp + Exp;
      TotaSaving = TotaSaving + Sav;
    }
    
  }
  Future<bool> _onWillPop() async {
    return isLoading;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child:Scaffold(
      resizeToAvoidBottomInset: true,
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
        searchBar: false,
      ),
      drawer: MyDrawer(PageIndex),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MainCard(),
            isLoading ? _list.length > 0 ?  ListCard() : Center(child: Text(Constants.NO_DATA,style: Mystyle().subText,),) : Center(child: CircularProgressIndicator())
          ],
        ),
      ),
    ),onWillPop: _onWillPop,);
  }
  MainCard() {
    List<S2Choice<String>> years = [];
    int cyear = DateTime.now().year;
    for(int i = cyear;i >2018;i--){
      years.add(new S2Choice(value: "$i", title: "$i"));
    }
    List<S2Choice<String>> months = [];
    for(int i = 0; i < 13; i++){
      months.add(new S2Choice(value: "$i", title: Constants.Months[i]));
    }
    return Column(children: [
      Container(
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
                            setMYPref(year, month);
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
                            setMYPref(year, month);
                            RefreshData();
                          })
                      ),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      isLoading && _list.length > 0 ? month=="0"?
      MainCard2(year):MainCard2("${Constants.Months[int.parse(month)]} $year") :
      Container()
    ],);
  }
  RefreshData(){
    isLoading = false;
    GetBankAPI().whenComplete(() {
      AppController().setSelMY(month,year);
      isLoading = true;
      _list = List.from(_Fulllist);
      if(_list.length > 0){ CalculateValues();}
    });
  }
  MainCard2(String title) {
    return Card(
      shape: Mystyle().RoundShape,
      margin: EdgeInsets.all(15),
      child: InkWell(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${title}", style: Mystyle().InputStyle,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("આવક : $TotalInc", style: Mystyle().subText,),
                        Text("ખર્ચ : $TotalExp", style: Mystyle().subText,),
                        Text("બચત : $TotaSaving", style: Mystyle().subText,),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ડાયરી ખર્ચ : $TotalLoan", style: Mystyle().subText,),
                        Text("ઓપનિંગ : $Opning", style: Mystyle().subText,),
                        Text("ક્લોસિંગ : $Closing", style: Mystyle().subText,),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        onTap: (){

          if(month == "0"){
            String dateToPAss = "01/01/${year}";
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DailyTotal(date: dateToPAss,type: 1,)));
          }
          else{
            String dateToPAss = "01/${month.toString().padLeft(2,"0")}/${year}";
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DailyTotal(date: dateToPAss,type: 2,)));
          }
        },
      ),
    );
  }
  getTitle(date){
    final f = new DateFormat('dd/MM/yyyy').parse(date);
    String title = "${Constants.Months[f.month]} ${f.year}";
    return title;
  }
  ListCard(){

    if(month == "0"){
      print(_list.length);
      return Expanded(child:  ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
        itemCount: _list.length,
        itemBuilder: (context,index){
          return Card(
            color: index%2 == 0 ? Colors.grey[200]:Colors.white,
            shape: Mystyle().RoundShape,
            margin: EdgeInsets.symmetric(vertical: 5),
            child: ListTile(
              onTap: (){
                  final f = new DateFormat('dd/MM/yyyy').parse(_list[index].bl_date);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => BANK_TOTAL(PageIndex: 5,getMonth: f.month,getYear: f.year,)));
                },
              title: Text("${getTitle(_list[index].bl_date)}", style: Mystyle().InputStyle),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("  આવક : ${Income[index]}",style: Mystyle().subText,),
                  Text("  ખર્ચ : ${Expense[index]}",style: Mystyle().subText,),
                  Text("  બચત : ${Saving[index]}",style: Mystyle().subText,)
                ],
              ),
            ),
          );
        },
      ));

    }
    else{
      return Expanded(child: ListView.builder(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
          shrinkWrap: true,
          itemCount: _list.length,//DaysInMOnth(),
          itemBuilder: (context,index) {
            return Card(
              color: index%2 == 0 ? Colors.grey[200]:Colors.white,
              shape: Mystyle().RoundShape,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                onTap: () {
                  //DateTime date = DateTime.parse(_list[index].bl_date);
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DailyTotal(date: _list[index].bl_date,type: 3,)));
                },
                title: Text(
                    _list[index].bl_date,
                    style: Mystyle().InputStyle
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("  આવક : ${Income[index]}",style: Mystyle().subText,),
                    Text("  ખર્ચ : ${Expense[index]}",style: Mystyle().subText,),
                    Text("  બચત : ${Saving[index]}",style: Mystyle().subText,)
                  ],
                ),
              ),
            );
          }
      ));
    }
  }


  getPDF(){
    GetPDF().getHisabPDF(_list,month=="0"? year.toString() : "${Constants.Months[int.parse(month)]} $year");
  }
  Future<void> GetBankAPI() async {
    isLoading = false;
    _Fulllist = [];
    _list = [];
    Response response;
    Dio dio = new Dio();
    try {
      var queryParameters = {"year":year,"month":month == "0" ? "" : month };
      print(queryParameters);

      response = await dio.post(Constants.API_BANKDATA, data: queryParameters).timeout(Constants.API_TIMEOUT);
      if (response != null && response.data != null) {
        var nodata = response.data["nodata"];
        var resCode = nodata["response_code"];
        //var msg = nodata["msg"];

        if (nodata["response_code"] == Constants.CODE_SUCESS) {
          var data = response.data["data"];
          setState(() {
            for (var element in data) {
              _Fulllist.add(BankData.fromJson(element));
            }
            SortArray();
            isLoading = true;
          });
          //AppController().ShowToast(text: "${data.length} Customer Found");
        }
        else if (resCode == Constants.CODE_WRONG_INPUT) {
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
          AppController().showToast(text: Constants.NO_DATA);
          setState(() {
            isLoading = true;
          });
        }
        else {
          //AppController().ShowToast(text: Constants.NO_REACHABILITY);
          setState(() {
            isLoading = true;
          });
        }
        print("GEtData Response : ${response.data}");
      }
    }
    catch(e){
      print(e.toString());
      AppController().showToast(text: Constants.NO_INTERNET);
      setState(() {
        isLoading = true;
      });
    }
  }

  void SortArray() {

    _Fulllist.sort((a,b) {
        final f1 = new DateFormat('dd/MM/yyyy').parse(a.bl_date);
        String dateToPass = "${f1.year}${f1.month.toString().padLeft(2,"0")}${f1.day.toString().padLeft(2,"0")}";
        int date1 = int.parse(dateToPass);

        final f2 = new DateFormat('dd/MM/yyyy').parse(b.bl_date);
        String dateToPass2 = "${f2.year}${f2.month.toString().padLeft(2,"0")}${f2.day.toString().padLeft(2,"0")}";
        int date2 = int.parse(dateToPass2);

        return date1.compareTo(date2);
    });
  }
}
