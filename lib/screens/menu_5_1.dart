import 'package:date_util/date_util.dart';
import 'package:dio/dio.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:intl/intl.dart';
import 'package:kkgroup/models/AppController.dart';
import 'package:kkgroup/models/Constants.dart';
import 'package:kkgroup/models/GetPDF.dart';
import 'package:kkgroup/models/models.dart';
import 'package:kkgroup/models/styles.dart';
import 'package:sticky_headers/sticky_headers.dart';

class DailyTotal extends StatefulWidget {
  String date;
  int type;

  DailyTotal({this.date,this.type});
  @override
  _DailyTotalState createState() => _DailyTotalState(date: this.date,type:this.type);
}

class _DailyTotalState extends State<DailyTotal> {

  final String date;
  final int type;
  _DailyTotalState({this.date,this.type});

  bool isLoading = false;
  var _panelKey = GlobalKey();

  String title = "-";


  List<AllData> _loandata = [];
  List<AllData> _tloandata = [];
  List<AllData> _emidata = [];
  List<AllData> _temidata = [];
  List<AllData> _otinc = [];
  List<AllData> _otexp = [];

  @override
  void initState(){
    super.initState();

    final f = new DateFormat('dd/MM/yyyy').parse(date);

    if(type == 1){
      title = f.year.toString();
      String dateToPass = "${f.year}0101";
      String dateToPass2 = "${f.year}1231";
      getDataApi(dateToPass,dateToPass2).whenComplete(() {
        setState(() {
          isLoading = true;
        });
      } );
    }
    else if(type == 2){
      title = "${Constants.Months[f.month]} ${f.year}";
      var dateUtility = DateUtil();
      String dateToPass = "${f.year}${f.month.toString().padLeft(2,"0")}01";
      String dateToPass2 = "${f.year}${f.month.toString().padLeft(2,"0")}${dateUtility.daysInMonth(f.month,f.year)}";
      getDataApi(dateToPass,dateToPass2).whenComplete(() {
        setState(() {
          isLoading = true;
        });
      } );
    }
    else{
      title = date;
      String dateToPass = "${f.year}${f.month.toString().padLeft(2,"0")}${f.day.toString().padLeft(2,"0")}";
      getDataApi(dateToPass).whenComplete(() {
        setState(() {
          isLoading = true;
        });
      } );
    }
  }

  PrintData(){

    GetPDF().getDetailHisab(_loandata, _tloandata, _emidata, _temidata, _otinc, _otexp,title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: Text("${title} ની વિગત"),
        searchBar: false,
        actions: [
          isLoading ? GFIconButton(
              color: Colors.lightGreen,
              splashColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 20),
              iconSize: 25,
              icon: Icon(Icons.print_rounded,size: 30,color: Colors.black,),
              onPressed: PrintData
          ) : Container()
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: isLoading ? ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: [
              getStickeyList("હપ્તા ની વિગત", _emidata),
              getStickeyList("ડાયરી ની વિગત", _loandata),
              getStickeyList("બહાર ની લોન ની વિગત", _tloandata),
              getStickeyList("હપ્તા ચુકવ્યા ની વિગત", _temidata),
              getStickeyList("અન્ય ખર્ચ ની વિગત", _otexp),
              getStickeyList("અન્ય આવક ની વિગત",_otinc ),
            ],
          )
         : Center(child: CircularProgressIndicator(),)
      ),
    );
  }

  getStickeyList(String header,List<AllData> _list){

    double Total = 0;
    for(var element in _list){
      Total = Total + double.parse(element.amount);
    }

    return _list.length > 0 ? StickyHeader(
      header: Container(
        height: 50.0,
        color: Colors.grey[400],
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        alignment: Alignment.centerLeft,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$header', style: const TextStyle(fontSize: 28,color: Colors.black, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
              Text('$Total', style: const TextStyle(fontSize: 28,color: Colors.black,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
            ],
          )
        ),
      ),
      content: Column(
        children: List.generate(_list.length, (index) => ListCard(_list[index], index)),
      ),
    ) : Container();
  }
  ListCard(AllData _list,index){
    return Card(
      elevation: 0.0,
      color: index%2 == 0 ? Colors.grey[200]:Colors.white,
      shape: Mystyle().RoundShape,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        trailing: Text(_list.amount??"-", style: Mystyle().InputStyle),
        title: Text(_list.name??"-", style: Mystyle().InputStyle),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("વિગત : ${_list.details}",style: Mystyle().subText,),
            Text("તારીખ : ${_list.date}",style: Mystyle().subText,),
          ],
        ),
      ),
    );
  }

  getTileCard(String header,List<AllData> _list){
    return (_list.length > 0 || true) ? ExpansionTileCard(
      elevation: 0,animateTrailing: true,
      contentPadding: EdgeInsets.symmetric(vertical: 10),
      title: Text(header,style: Mystyle().InputStyle,),
      children: List<Widget>.generate(_list.length, (index) {
        return ListCard(_list[index],index,);
      }),
    ) : Container();
  }
  Future getDataApi(dateFind,[dateFind2])async {
    isLoading = false;
    Response response;
    Dio dio = new Dio();

    try {
      var queryParameters;
      if(type == 3){
        queryParameters= {"sdate":"$dateFind"};
      }
      else{
        queryParameters= {"sdate":"$dateFind","enddate":"$dateFind2"};
      }

      print(queryParameters);

      response = await dio.post(Constants.API_ALLDATA,data: queryParameters);

      if (response != null && response.data != null) {
        var loandata = response.data["loandata"];
        if(loandata.length > 0){
          for(var element in loandata){
            _loandata.add(storeData(element,1));
          }
        }
        var tloandata = response.data["tloandata"];
        if(tloandata.length > 0){
          for(var element in tloandata){
            _tloandata.add(storeData(element,2));
          }
        }
        var emidata = response.data["emidata"];
        if(emidata.length > 0){
          for(var element in emidata){
            _emidata.add(storeData(element,3));
          }
        }
        var temidata = response.data["temidata"];
        if(temidata.length > 0){
          for(var element in temidata){
            _temidata.add(storeData(element,4));
          }
        }
        var oth_incom = response.data["oth_incom"];
        if(oth_incom.length > 0){
          for(var element in oth_incom){
            _otinc.add(storeData(element,5));
          }
        }
        var oth_expance = response.data["oth_expance"];
        if(oth_expance.length > 0){
          for(var element in oth_expance){
            _otexp.add(storeData(element,6));
          }
        }
      }
      print("GEtData Response : ${response.data}");
    }
    catch (e) {
      print(e.toString());
      AppController().showToast(text: Constants.NO_INTERNET);
    }
  }
  storeData(element,int index){
    print("\n$element");
    AllData data = new AllData();
    if(index == 1){
      data.name = element["loan_cust_name"];
      data.amount = element["loan_given_amount"];
      data.details = "ડાયરી નં. - ${element["loan_id"]}";
      data.date = element["loan_date"];
    }
    else if(index == 2){
      double amount = double.parse(element["tl_amount"]) - double.parse(element["tl_advace"]);

      data.name = element["tl_name"];
      data.amount = amount.toString();
      data.details = "${element["tl_irate"]}% દરે ${element["tl_month"]} મહિના";
      data.date = element["tl_date"];
    }
    else if(index == 3){
      data.name = element["emi_cust_name"];
      data.amount = element["emi_rcvd"];
      data.details = "ડાયરી નં. - ${element["loan_id"]} \t પેનલ્ટી - ${element["emi_pnlti"]}";
      data.date = element["emi_rcvd_date"];
    }
    else if(index == 4){
      data.name = element["tl_name"];
      data.amount = element["temi_amount"];
      data.details = "હપ્તો ચૂકવ્યો";
      data.date = element["temi_given_date"];
    }
    else if(index == 5){
      data.name = element["oth_from_name"];
      data.amount = element["oth_amount"];
      data.details = "${element["oth_detiles"]}";
      data.date = element["oth_date"];
    }
    else if(index == 6){
      data.name = element["oth_to_name"];
      data.amount = element["oth_amount"];
      data.details = "${element["oth_detiles"]}";
      data.date = element["oth_date"];
    }
    return data;
  }
}
