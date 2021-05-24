import 'dart:io';
import 'package:kkgroup/models/Constants.dart';
import 'package:kkgroup/models/models.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'AppController.dart';
class GetPDF{

  FileHeaderCellStyle(workbook){
    Style globalStyle = workbook.styles.add('titleStyle');
    globalStyle.fontSize = 18;
    globalStyle.bold = true;
    globalStyle.underline = true;
    globalStyle.wrapText = true;
    globalStyle.hAlign = HAlignType.center;
    globalStyle.vAlign = VAlignType.center;
    return globalStyle;
  }
  DetailsCellStyle(workbook){
    Style globalStyle = workbook.styles.add('detailStyle');
    globalStyle.fontSize = 16;
    globalStyle.bold = false;
    globalStyle.underline = false;
    globalStyle.wrapText = true;
    globalStyle.hAlign = HAlignType.center;
    globalStyle.vAlign = VAlignType.center;
    return globalStyle;
  }
  TableHeaderCellStyle(workbook){
    Style globalStyle = workbook.styles.add('headerStyle');
    globalStyle.fontSize = 14;
    globalStyle.bold = true;
    globalStyle.underline = false;
    globalStyle.wrapText = false;
    globalStyle.hAlign = HAlignType.center;
    globalStyle.vAlign = VAlignType.center;
    return globalStyle;
  }
  CommonCellStyle(workbook){
    Style globalStyle = workbook.styles.add('commonstyle');
    globalStyle.fontSize = 12;
    globalStyle.bold = false;
    globalStyle.underline = false;
    globalStyle.wrapText = false;
    globalStyle.hAlign = HAlignType.center;
    globalStyle.vAlign = VAlignType.center;
    return globalStyle;
  }

  setCellValue(sheet,style,range,value, {bool merge = false, bool autofit = true,isAmount = false}){

    print("range = $range, value = $value");
    if(isAmount){
      value = double.parse(value);
    }

    Range cell = sheet.getRangeByName(range);
    cell.cellStyle = style;
    cell.setValue(value);
    if(autofit)cell.autoFit();
    if(merge){cell.merge();}
  }
  setCellFormula(sheet,style,range,value, {bool merge = false, bool autofit = true}){
    Range cell = sheet.getRangeByName(range);
    cell.cellStyle = style;
    cell.setFormula(value);
    if(autofit)cell.autoFit();
    if(merge){cell.merge();}
  }

  getString(int num){
    final List<String> alphabets = ['0','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];

    if(num < 27)
    {
      return alphabets[num];
    }
    else{
      int prefix = num~/26;
      int suffix = num%26;
      String alpha = "${alphabets[prefix]}${alphabets[suffix]}";
      return alpha;
    }

  }
  getStringRange(int r,int c,[int lr = -1, int lc = -1]){
    String range = "A1";
    if(lr < 0 || lc < 0){
      range = "${getString(c)}$r";
    }
    else{
      range = "${getString(c)}$r:${getString(lc)}$lr";
    }
    return range;
  }

  getFile(String path) async {
    if(await File(path).exists()){
      File(path).delete();
    }
    return File(path).create();
  }

  getLogPDF(List<GetLog> _list) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    final Style FileHeaderStyle = FileHeaderCellStyle(workbook);
    //final Style DetailsStyle = DetailsCellStyle(workbook);
    final Style TableHeadertyle = TableHeaderCellStyle(workbook);
    final Style CommonStyle = CommonCellStyle(workbook);
    sheet.enableSheetCalculations();

    setCellValue(sheet, FileHeaderStyle, 'A1:F1', "લોગિન લોગ", autofit: false,merge: true);

    setCellValue(sheet, TableHeadertyle, getStringRange(4, 2), "ક્રમ");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 3), "નામ");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 5), "તારીખ અને સમય");

    int rowno = 6;
    for(var element in _list){

      setCellValue(sheet, CommonStyle, getStringRange(rowno, 2), rowno - 5);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 3), element.log_tm_name);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 5), element.log_time);

      rowno++;
    }

    for(int i = 1; i <= sheet.getLastColumn();i++){
      sheet.autoFitColumn(i);
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    DateTime now = new DateTime.now();
    String date = "${now.day}-${now.month}-${now.year}";

    final file = File('${Constants.DIR_PATH}/Login Log $date.xlsx');
    await file.writeAsBytes(await bytes).then((value) {AppController().showToast(text:"Sheet Created");});
  }
  getCustList(List<GetCustomer> _list) async {

    print("Entered");
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    final Style FileHeaderStyle = FileHeaderCellStyle(workbook);
    // final Style DetailsStyle = DetailsCellStyle(workbook);
    final Style TableHeadertyle = TableHeaderCellStyle(workbook);
    final Style CommonStyle = CommonCellStyle(workbook);
    sheet.enableSheetCalculations();

    setCellValue(sheet, FileHeaderStyle, 'A1:F1', "ગ્રાહક લિસ્ટ", autofit: false,merge: true);

    setCellValue(sheet, TableHeadertyle, getStringRange(4, 2), "ક્રમ");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 3), "નામ");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 4), "મોબાઇલ નં");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 5), "મોબાઇલ નં 2");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 6), "સરનામું");

    int rowno = 6;
    for(var element in _list){

      setCellValue(sheet, CommonStyle, getStringRange(rowno, 2), rowno - 5);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 3), element.cust_name);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 4), element.cust_mobile);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 5), element.cust_mobile2);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 6), element.cust_address);

      rowno++;
    }

    for(int i = 1; i <= sheet.getLastColumn();i++){
      sheet.autoFitColumn(i);
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

      final file = File('${Constants.DIR_PATH}/Customer List.xlsx');
      await file.writeAsBytes(await bytes).then((value) {AppController().showToast(text:"Sheet Created");});



  }
  getLoanOnId(GetCustomer _cust, GetLoans _loan, List<GetEmi> _emi,) async {

    int left_emi = 0;
    int left_amt = 0;
    int given_amt = 0;
    int pnlt = 0;

    int count = 0;
    for (var element in _emi) {
      if (element.status == "1") {
        count = count + 1;
        pnlt = pnlt + int.parse(element.pnlti);
      }
    }
    left_emi = _emi.length - count;
    left_amt = int.parse(_loan.amount) - (count * int.parse(_loan.emi_amount));
    given_amt = int.parse(_loan.amount) - int.parse(_loan.given_amount);

    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    final Style FileHeaderStyle = FileHeaderCellStyle(workbook);
    final Style DetailsStyle = DetailsCellStyle(workbook);
    final Style TableHeadertyle = TableHeaderCellStyle(workbook);
    final Style CommonStyle = CommonCellStyle(workbook);
    sheet.enableSheetCalculations();

    setCellValue(sheet, TableHeadertyle, 'A2', "નામ");
    setCellValue(sheet, FileHeaderStyle, 'B2:F2', _cust.cust_name, autofit: false,merge: true);
    setCellValue(sheet, TableHeadertyle, 'A3', "સરનામું");
    setCellValue(sheet, DetailsStyle, 'B3:F3',_cust.cust_address,autofit: false, merge: true);
    setCellValue(sheet, TableHeadertyle, 'A4', "મોબાઇલ નં");
    setCellValue(sheet, DetailsStyle, 'B4:C4',_cust.cust_mobile,autofit: false, merge: true);
    setCellValue(sheet, TableHeadertyle, 'D4', "મોબાઇલ 2 નં");
    setCellValue(sheet, DetailsStyle, 'E4:F4',_cust.cust_mobile2,autofit: false, merge: true);

    setCellValue(sheet, TableHeadertyle, 'A6', "ડાયરી નં");
    setCellValue(sheet, DetailsStyle, 'B6',_loan.id);
    setCellValue(sheet, TableHeadertyle, 'C6', "તારીખ");
    setCellValue(sheet, DetailsStyle, 'D6',_loan.date);
    setCellValue(sheet, TableHeadertyle, 'E6', "લોન ની રકમ");
    setCellValue(sheet, DetailsStyle, 'F6',_loan.amount);

    setCellValue(sheet, TableHeadertyle, 'A7', "આપેલ રકમ");
    setCellValue(sheet, DetailsStyle, 'B7',_loan.given_amount);
    setCellValue(sheet, TableHeadertyle, 'C7', "વ્યાજ કપાત");
    setCellValue(sheet, DetailsStyle, 'D7',given_amt);
    setCellValue(sheet, TableHeadertyle, 'E7', "હપ્તા ની રકમ");
    setCellValue(sheet, DetailsStyle, 'F7',_loan.emi_amount);

    setCellValue(sheet, TableHeadertyle, 'A8', "હપ્તા ના દિવસ");
    setCellValue(sheet, DetailsStyle, 'B8',_loan.emi_day);
    setCellValue(sheet, TableHeadertyle, 'C8', "કુલ હપ્તા");
    setCellValue(sheet, DetailsStyle, 'D8',_loan.total_emi);
    setCellValue(sheet, TableHeadertyle, 'E8', "બાકી હપ્તા");
    setCellValue(sheet, DetailsStyle, 'F8',left_emi);

    setCellValue(sheet, TableHeadertyle, 'A9', "બાકી મુદ્દલ");
    setCellValue(sheet, DetailsStyle, 'B9',left_amt);
    setCellValue(sheet, TableHeadertyle, 'C9', "જમા પેનલ્ટી");
    setCellValue(sheet, DetailsStyle, 'D9',pnlt);


    setCellValue(sheet, TableHeadertyle, getStringRange(11, 1), "ક્રમ");
    setCellValue(sheet, TableHeadertyle, getStringRange(11, 2), "તારીખ");
    setCellValue(sheet, TableHeadertyle, getStringRange(11, 3), "જમા રકમ");
    setCellValue(sheet, TableHeadertyle, getStringRange(11, 4), "પેનલ્ટી");
    setCellValue(sheet, TableHeadertyle, getStringRange(11, 5), "આવેલ હપ્તા ની તારીખ");
    setCellValue(sheet, TableHeadertyle, getStringRange(11, 6), "જમા લેનાર");

    int rowno = 13;
    for(var element in _emi){
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 1), rowno - 12);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 2), element.date);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 3), element.rcvd??"0",isAmount: true);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 4), element.pnlti??"0",isAmount: true);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 5), element.rcvd_date??"");
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 6), element.rcvd_by??"");

      rowno++;
    }

    for(int i = 1; i <= sheet.getLastColumn();i++){
      sheet.autoFitColumn(i);
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final file = File('${Constants.DIR_LOAN}/ડાયરી નં ${_loan.id}.xlsx');
    await file.writeAsBytes(await bytes).then((value) {AppController().showToast(text:"Sheet Created");});
  }
  getTodayList(List<CollectionList> _list, String title,bool isPending) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    final Style FileHeaderStyle = FileHeaderCellStyle(workbook);
    // final Style DetailsStyle = DetailsCellStyle(workbook);
    final Style TableHeadertyle = TableHeaderCellStyle(workbook);
    final Style CommonStyle = CommonCellStyle(workbook);
    sheet.enableSheetCalculations();

    setCellValue(sheet, FileHeaderStyle, 'A1:F1', "$title કલેક્શન લિસ્ટ", autofit: false,merge: true);

    setCellValue(sheet, TableHeadertyle, getStringRange(4, 2), "ડાયરી નં");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 3), "તારીખ");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 4), "નામ");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 5), "મોબાઇલ નં");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 6), "મોબાઇલ નં 2");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 7), "રકમ");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 8), "જમા લેનાર");

    int rowno = 6;
    int start = rowno;
    for(var element in _list){

      setCellValue(sheet, CommonStyle, getStringRange(rowno, 2), element.loan_id);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 3), element.emi_date);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 4), element.cust_name);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 5), element.cust_mobile);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 6), element.cust_mobile2);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 7), element.emi_amount,isAmount: true);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 8), element.emi_rcvd_by??"");

      rowno++;
    }
    int end = rowno-1;

    setCellFormula(sheet, TableHeadertyle, getStringRange(rowno,7), "=SUM(${getStringRange(start, 7,end,7)})");

    for(int i = 1; i <= sheet.getLastColumn();i++){
      sheet.autoFitColumn(i);
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    DateTime now = new DateTime.now();
    String date = "${now.day}-${now.month}-${now.year}";

    final file = File('${Constants.DIR_LOAN}/${isPending? "Pending " : ""}Collection $date.xlsx');
    await file.writeAsBytes(await bytes).then((value) {AppController().showToast(text:"Sheet Created");});
  }
  getTxnList(List<TxnList> _list, String title) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    final Style FileHeaderStyle = FileHeaderCellStyle(workbook);
    // final Style DetailsStyle = DetailsCellStyle(workbook);
    final Style TableHeadertyle = TableHeaderCellStyle(workbook);
    final Style CommonStyle = CommonCellStyle(workbook);
    sheet.enableSheetCalculations();

    setCellValue(sheet, FileHeaderStyle, 'A1:F1', "$title પેઢી માં જમા લિસ્ટ", autofit: false,merge: true);

    setCellValue(sheet, TableHeadertyle, getStringRange(4, 2), "ક્રમ");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 3), "તારીખ");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 4), "જમા કરનાર");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 5), "હપ્તા ની રકમ");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 6), "પેનલ્ટી ની રકમ");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 7), "કુલ રકમ");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 8), "જમા તારીખ");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 9), "જમા લેનાર");

    int rowno = 6;
    int start = rowno;
    for(var element in _list){

      int totalAmt = int.parse(element.emi_amount) + int.parse(element.panalti_amount);


      setCellValue(sheet, CommonStyle, getStringRange(rowno, 2), rowno - 5);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 3), element.date);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 4), element.from_name);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 5), element.emi_amount,isAmount: true);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 6), element.panalti_amount,isAmount: true);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 7), totalAmt);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 8), element.receive_date);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 9), element.to_name);

      rowno++;
    }
    int end = rowno-1;

    setCellFormula(sheet, TableHeadertyle, getStringRange(rowno,5), "=SUM(${getStringRange(start, 5,end,5)})");
    setCellFormula(sheet, TableHeadertyle, getStringRange(rowno,6), "=SUM(${getStringRange(start, 6,end,6)})");
    setCellFormula(sheet, TableHeadertyle, getStringRange(rowno,7), "=SUM(${getStringRange(start, 7,end,7)})");

    for(int i = 1; i <= sheet.getLastColumn();i++){
      sheet.autoFitColumn(i);
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    DateTime now = new DateTime.now();
    String date = "${now.day}-${now.month}-${now.year}";

    final file = File('${Constants.DIR_LOAN}/Transaction List $date.xlsx');
    await file.writeAsBytes(await bytes).then((value) {AppController().showToast(text:"Sheet Created");});
  }
  getOthList(List<OthList> _list, String title) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    final Style FileHeaderStyle = FileHeaderCellStyle(workbook);
    // final Style DetailsStyle = DetailsCellStyle(workbook);
    final Style TableHeadertyle = TableHeaderCellStyle(workbook);
    final Style CommonStyle = CommonCellStyle(workbook);
    sheet.enableSheetCalculations();

    setCellValue(sheet, FileHeaderStyle, 'A1:F1', "$title અન્ય આવક/ખર્ચ લિસ્ટ", autofit: false,merge: true);

    setCellValue(sheet, TableHeadertyle, getStringRange(4, 2), "ક્રમ");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 3), "તારીખ");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 4), "આવક");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 5), "જાવક");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 6), "વિગત");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 7), "ખર્ચ કરનાર");

    int rowno = 6;
    int start = rowno;
    for(var element in _list){

      int col = element.type == "0" ? 4 : 5;
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 2), rowno - 5);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 3), element.date);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, col), element.amount,isAmount: true);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 6), element.detiles);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 7), element.to_name);

      rowno++;
    }
    int end = rowno-1;

    setCellFormula(sheet, TableHeadertyle, getStringRange(rowno,4), "=SUM(${getStringRange(start, 5,end,5)})");
    setCellFormula(sheet, TableHeadertyle, getStringRange(rowno,5), "=SUM(${getStringRange(start, 6,end,6)})");

    for(int i = 1; i <= sheet.getLastColumn();i++){
      sheet.autoFitColumn(i);
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    DateTime now = new DateTime.now();
    String date = "${now.day}-${now.month}-${now.year}";

    final file = File('${Constants.DIR_LOAN}/Other Data List $date.xlsx');
    await file.writeAsBytes(await bytes).then((value) {AppController().showToast(text:"Sheet Created");});
  }
  getTeamList(List<GetTeam> _list) async {

    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    final Style FileHeaderStyle = FileHeaderCellStyle(workbook);
    // final Style DetailsStyle = DetailsCellStyle(workbook);
    final Style TableHeadertyle = TableHeaderCellStyle(workbook);
    final Style CommonStyle = CommonCellStyle(workbook);
    sheet.enableSheetCalculations();

    setCellValue(sheet, FileHeaderStyle, 'A1:F1', "ગ્રાહક લિસ્ટ", autofit: false,merge: true);

    setCellValue(sheet, TableHeadertyle, getStringRange(4, 2), "ક્રમ");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 3), "નામ");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 4), "મોબાઇલ નં");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 5), "પાસવર્ડ");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 6), "સભ્ય નો પ્રકાર");

    int rowno = 6;
    for(var element in _list){

      setCellValue(sheet, CommonStyle, getStringRange(rowno, 2), rowno - 5);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 3), element.tm_name);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 4), element.tm_mobile);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 5), element.tm_pass);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 6), element.tm_type);

      rowno++;
    }

    for(int i = 1; i <= sheet.getLastColumn();i++){
      sheet.autoFitColumn(i);
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final file = File('${Constants.DIR_PATH}/Team List.xlsx');
    await file.writeAsBytes(await bytes).then((value) {AppController().showToast(text:"Sheet Created");});
  }
  getLoanList(int type, List<TotalList> _list) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    final Style FileHeaderStyle = FileHeaderCellStyle(workbook);
    final Style DetailsStyle = DetailsCellStyle(workbook);
    final Style TableHeadertyle = TableHeaderCellStyle(workbook);
    final Style CommonStyle = CommonCellStyle(workbook);
    sheet.enableSheetCalculations();

    if (type == 3) {
      setCellValue(sheet, FileHeaderStyle, 'A1:F1', "ડાયરી લીસ્ટ", autofit: false, merge: true);

    int rowno = 3;
    int currid = -1;

      setCellValue(sheet, TableHeadertyle, getStringRange(rowno, 2), "ડાયરી નં");
      setCellValue(sheet, TableHeadertyle, getStringRange(rowno, 3), "લોન ની તારીખ");
      setCellValue(sheet, TableHeadertyle, getStringRange(rowno, 4), "લોન ની રકમ");
      setCellValue(sheet, TableHeadertyle, getStringRange(rowno, 5), "આપેલ રકમ");
      setCellValue(sheet, TableHeadertyle, getStringRange(rowno, 6), "વ્યાજ કપાત");
      setCellValue(sheet, TableHeadertyle, getStringRange(rowno, 7), "હપ્તા ના દિવસ");
      setCellValue(sheet, TableHeadertyle, getStringRange(rowno, 8), "હપ્તા ની રકમ");
      setCellValue(sheet, TableHeadertyle, getStringRange(rowno, 9), "કુલ હપ્તા");
      setCellValue(sheet, TableHeadertyle, getStringRange(rowno, 10), "બાકી હપ્તા");
      setCellValue(sheet, TableHeadertyle, getStringRange(rowno, 11), "બાકી મુદ્દલ");
      rowno++;

      int start = rowno,end = rowno;
    for (var element in _list) {
      int left_emi = int.parse(element.loan_total_emi) - int.parse(element.loan_coumtemi);
      int left_amt = left_emi*(int.parse(element.loan_emi_amount));
      int given_amt = int.parse(element.loan_amount) - int.parse(element.loan_given_amount);
      if (currid == int.parse(element.cust_id)) {
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 2), element.loan_id,autofit: false);
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 3), element.loan_date,autofit: false);
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 4), element.loan_amount,autofit: false,isAmount: true);
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 5), element.loan_given_amount,autofit: false,isAmount: true);
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 6), given_amt,autofit: false);
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 7), element.loan_emi_day,autofit: false);
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 8), element.loan_emi_amount,autofit: false,isAmount: true);
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 9), element.loan_total_emi,autofit: false);
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 10), left_emi,autofit: false);
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 11), left_amt,autofit: false);

        rowno++;
      }
      else {
        currid = int.parse(element.cust_id);
        rowno++;
        setCellValue(sheet, DetailsStyle, getStringRange(rowno, 1), "નામ ",autofit: false);
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 2), element.cust_name,autofit: false);
        rowno++;
        setCellValue(sheet, DetailsStyle, getStringRange(rowno, 1), "મોબાઇલ નં.",autofit: false);
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 2), element.cust_mobile,autofit: false);
        rowno++;

        setCellValue(sheet, CommonStyle, getStringRange(rowno, 2), element.loan_id,autofit: false);
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 3), element.loan_date,autofit: false);
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 4), element.loan_amount,autofit: false,isAmount: true);
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 5), element.loan_given_amount,autofit: false,isAmount: true);
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 6), given_amt,autofit: false);
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 7), element.loan_emi_day,autofit: false);
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 8), element.loan_emi_amount,autofit: false,isAmount: true);
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 9), element.loan_total_emi,autofit: false);
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 10), left_emi,autofit: false);
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 11), left_amt,autofit: false);
        rowno++;

      }
    }
    end = rowno;
    rowno++;
    setCellFormula(sheet, TableHeadertyle, getStringRange(rowno,4), "=SUM(${getStringRange(start, 4,end,4)})");
    setCellFormula(sheet, TableHeadertyle, getStringRange(rowno,5), "=SUM(${getStringRange(start, 5,end,5)})");
    setCellFormula(sheet, TableHeadertyle, getStringRange(rowno,6), "=SUM(${getStringRange(start, 6,end,6)})");
    setCellFormula(sheet, TableHeadertyle, getStringRange(rowno,10), "=SUM(${getStringRange(start, 10,end,10)})");
    setCellFormula(sheet, TableHeadertyle, getStringRange(rowno,11), "=SUM(${getStringRange(start, 11,end,11)})");

      for(int i = 1; i <= sheet.getLastColumn();i++){
        sheet.autoFitColumn(i);
      }

      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      DateTime now = new DateTime.now();
      String date = "${now.day}-${now.month}-${now.year}";

      final file = File('${Constants.DIR_LOAN}/LoanList ${date}.xlsx');
      await file.writeAsBytes(await bytes).then((value) {AppController().showToast(text:"Sheet Created");});
  }
    else if(type == 4){
      setCellValue(sheet, FileHeaderStyle, 'A1:F1', "ચાલુ ડાયરી લીસ્ટ", autofit: false, merge: true);

      setCellValue(sheet, TableHeadertyle, getStringRange(3, 2), "ડાયરી નં");
      setCellValue(sheet, TableHeadertyle, getStringRange(3, 3), "લોન ની તારીખ");
      setCellValue(sheet, TableHeadertyle, getStringRange(3, 4), "નામ");
      setCellValue(sheet, TableHeadertyle, getStringRange(3, 5), "મોબાઇલ નં");
      setCellValue(sheet, TableHeadertyle, getStringRange(3, 6), "લોન ની રકમ");
      setCellValue(sheet, TableHeadertyle, getStringRange(3, 7), "આપેલ રકમ");
      setCellValue(sheet, TableHeadertyle, getStringRange(3, 8), "વ્યાજ કપાત");
      setCellValue(sheet, TableHeadertyle, getStringRange(3, 9), "હપ્તા ના દિવસ");
      setCellValue(sheet, TableHeadertyle, getStringRange(3, 10), "હપ્તા ની રકમ");
      setCellValue(sheet, TableHeadertyle, getStringRange(3, 11), "કુલ હપ્તા");
      setCellValue(sheet, TableHeadertyle, getStringRange(3, 12), "બાકી હપ્તા");
      setCellValue(sheet, TableHeadertyle, getStringRange(3, 13), "બાકી મુદ્દલ");

      int rowno = 5;
      int start = rowno,end = rowno;
      for(var element in _list){
        if(element.loan_status == "0"){
          int left_emi = int.parse(element.loan_total_emi) - int.parse(element.loan_coumtemi);
          int left_amt = left_emi*(int.parse(element.loan_emi_amount));
          int given_amt = int.parse(element.loan_amount) - int.parse(element.loan_given_amount);

          setCellValue(sheet, CommonStyle, getStringRange(rowno, 2), element.loan_id,autofit: false);
          setCellValue(sheet, CommonStyle, getStringRange(rowno, 3), element.loan_date,autofit: false);
          setCellValue(sheet, CommonStyle, getStringRange(rowno, 4), element.cust_name);
          setCellValue(sheet, CommonStyle, getStringRange(rowno, 5), element.cust_mobile,autofit: false);
          setCellValue(sheet, CommonStyle, getStringRange(rowno, 6), element.loan_amount,autofit: false);
          setCellValue(sheet, CommonStyle, getStringRange(rowno, 7), element.loan_given_amount,autofit: false);
          setCellValue(sheet, CommonStyle, getStringRange(rowno, 8), given_amt,autofit: false);
          setCellValue(sheet, CommonStyle, getStringRange(rowno, 9), element.loan_emi_day,autofit: false);
          setCellValue(sheet, CommonStyle, getStringRange(rowno, 10), element.loan_emi_amount,autofit: false);
          setCellValue(sheet, CommonStyle, getStringRange(rowno, 11), element.loan_total_emi,autofit: false);
          setCellValue(sheet, CommonStyle, getStringRange(rowno, 12), left_emi,autofit: false);
          setCellValue(sheet, CommonStyle, getStringRange(rowno, 13), left_amt,autofit: false);


          rowno++;
        }
      }
      end = rowno;
      setCellFormula(sheet, TableHeadertyle, getStringRange(rowno,6), "=SUM(${getStringRange(start, 6,end,6)})");
      setCellFormula(sheet, TableHeadertyle, getStringRange(rowno,7), "=SUM(${getStringRange(start, 7,end,7)})");
      setCellFormula(sheet, TableHeadertyle, getStringRange(rowno,8), "=SUM(${getStringRange(start, 8,end,8)})");
      setCellFormula(sheet, TableHeadertyle, getStringRange(rowno,12), "=SUM(${getStringRange(start, 12,end,12)})");
      setCellFormula(sheet, TableHeadertyle, getStringRange(rowno,13), "=SUM(${getStringRange(start, 13,end,13)})");


      for(int i = 1; i <= sheet.getLastColumn();i++){
        sheet.autoFitColumn(i);
      }

      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      DateTime now = new DateTime.now();
      String date = "${now.day}-${now.month}-${now.year}";

      final file = File('${Constants.DIR_LOAN}/Open LoanList ${date}.xlsx');
      await file.writeAsBytes(await bytes).then((value) {AppController().showToast(text:"Sheet Created");});
    }
  }
  getHisabPDF(List<BankData> list, String title) async {
    // Create a new Excel Document.
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    final Style FileHeaderStyle = FileHeaderCellStyle(workbook);
    //final Style DetailsStyle = DetailsCellStyle(workbook);
    final Style TableHeadertyle = TableHeaderCellStyle(workbook);
    final Style CommonStyle = CommonCellStyle(workbook);
    sheet.enableSheetCalculations();

    setCellValue(sheet, FileHeaderStyle, 'A1:F1', "હિસાબ $title", autofit: false, merge: true);


    setCellValue(sheet, TableHeadertyle, getStringRange(3, 2), "તારીખ");
    setCellValue(sheet, TableHeadertyle, getStringRange(3, 3), "ઓપેનિંગ બેલન્સ");
    setCellValue(sheet, TableHeadertyle, getStringRange(3, 4), "બહાર થી લાવેલ");
    setCellValue(sheet, TableHeadertyle, getStringRange(3, 5), "હપ્તા ની આવક");
    setCellValue(sheet, TableHeadertyle, getStringRange(3, 6), "પેનલ્ટી ની આવક");
    setCellValue(sheet, TableHeadertyle, getStringRange(3, 7), "અન્ય આવક");
    setCellValue(sheet, TableHeadertyle, getStringRange(3, 8), "કુલ બચત");
    setCellValue(sheet, TableHeadertyle, getStringRange(3, 9), "વ્યાજ ભરેલ");
    setCellValue(sheet, TableHeadertyle, getStringRange(3, 10), "ડાયરી ખર્ચ");
    setCellValue(sheet, TableHeadertyle, getStringRange(3, 11), "અન્ય ખર્ચ");
    setCellValue(sheet, TableHeadertyle, getStringRange(3, 12), "ક્લોસિંગ બેલેન્સ");

    int rowno = 5;
    int start = rowno,end = rowno;
    for(var element in list){

        setCellValue(sheet, CommonStyle, getStringRange(rowno, 2), element.bl_date,autofit: false);
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 3), element.bl_open,autofit: false,isAmount: true);
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 4), element.bl_loan_amt,autofit: false,isAmount: true);
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 5), element.bl_emi_amount,isAmount: true);
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 6), element.bl_penlti_amount,autofit: false,isAmount: true);
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 7), element.bl_penlti_amount,autofit: false,isAmount: true);
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 8), element.bl_saving,autofit: false,isAmount: true);
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 9), element.bl_loan_expance,autofit: false,isAmount: true);
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 10), element.bl_loan_given,autofit: false,isAmount: true);
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 11), element.bl_other_expance,autofit: false,isAmount: true);
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 12), element.bl_cloas,autofit: false,isAmount: true);

        rowno++;
    }
    end = rowno-1;
    setCellFormula(sheet, TableHeadertyle, getStringRange(rowno,4), "=SUM(${getStringRange(start, 4,end,4)})");
    setCellFormula(sheet, TableHeadertyle, getStringRange(rowno,5), "=SUM(${getStringRange(start, 5,end,5)})");
    setCellFormula(sheet, TableHeadertyle, getStringRange(rowno,6), "=SUM(${getStringRange(start, 6,end,6)})");
    setCellFormula(sheet, TableHeadertyle, getStringRange(rowno,7), "=SUM(${getStringRange(start, 7,end,7)})");
    setCellFormula(sheet, TableHeadertyle, getStringRange(rowno,8), "=SUM(${getStringRange(start, 8,end,8)})");
    setCellFormula(sheet, TableHeadertyle, getStringRange(rowno,9), "=SUM(${getStringRange(start, 9,end,9)})");
    setCellFormula(sheet, TableHeadertyle, getStringRange(rowno,10), "=SUM(${getStringRange(start, 10,end,10)})");
    setCellFormula(sheet, TableHeadertyle, getStringRange(rowno,11), "=SUM(${getStringRange(start, 11,end,11)})");


    for(int i = 1; i <= sheet.getLastColumn();i++){
      sheet.autoFitColumn(i);
    }

// Save and dispose the document.
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final file = File('${Constants.DIR_HISAB}/Hisab $title.xlsx');
    await file.writeAsBytes(await bytes).then((value) {AppController().showToast(text:"Sheet Created");});

    //File('Output.xlsx').writeAsBytes(bytes);
  }
  getDetailHisab(List<AllData> _loandata, List<AllData> _tloandata,List<AllData> _emidata,List<AllData> _temidata,List<AllData> _otinc,List<AllData> _otexp,String title) async {

    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    final Style FileHeaderStyle = FileHeaderCellStyle(workbook);
    final Style DetailsStyle = DetailsCellStyle(workbook);
    final Style TableHeadertyle = TableHeaderCellStyle(workbook);
    final Style CommonStyle = CommonCellStyle(workbook);
    sheet.enableSheetCalculations();

    setCellValue(sheet, FileHeaderStyle, 'A1:F1', "$title હિસાબ", autofit: false,merge: true);

    int rowno = 3;
    List<List<AllData>> lists = [_loandata,_emidata,_tloandata,_temidata,_otexp,_otinc];
    List<String> tablename = ["ડાયરી ની વિગત","હપ્તા ની વિગત","બહાર ની લોન ની વિગત","હપ્તા ચુકવ્યા ની વિગત","અન્ય ખર્ચ ની વિગત","અન્ય આવક ની વિગત"];
    List<int> totalCell = [0,0,0,0,0,0];
    for(int i = 0; i < 6; i++){

      setCellValue(sheet, DetailsStyle, getStringRange(rowno, 1, rowno, 5), tablename[i], autofit: false,merge: true);
      rowno++;

      setCellValue(sheet, TableHeadertyle, getStringRange(rowno, 1), "ક્રમ");
      setCellValue(sheet, TableHeadertyle, getStringRange(rowno, 2), "નામ");
      setCellValue(sheet, TableHeadertyle, getStringRange(rowno, 3), "તારીખ");
      setCellValue(sheet, TableHeadertyle, getStringRange(rowno, 4), "વિગત");
      setCellValue(sheet, TableHeadertyle, getStringRange(rowno, 5), "રકમ");
      rowno++;

      int start = rowno, end = rowno;

      for(int j = 0; j < lists[i].length;j++){
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 1), "${j+1}",autofit: false);
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 2), lists[i][j].name.trim());
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 3), lists[i][j].date.trim());
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 4), lists[i][j].details.trim());
        setCellValue(sheet, CommonStyle, getStringRange(rowno, 5), lists[i][j].amount.trim(),isAmount: true);

        end = rowno;
        rowno++;
      }

      setCellValue(sheet, TableHeadertyle, getStringRange(rowno, 4), "ટોટલ");
      setCellFormula(sheet, TableHeadertyle, getStringRange(rowno, 5), "=SUM(${getStringRange(start, 5,end,5)})");

      totalCell[i] = rowno;
      rowno = rowno + 2;
    }

    String getcell = "=SUM(${getStringRange(totalCell[1], 5)}, ${getStringRange(totalCell[2], 5)}, ${getStringRange(totalCell[5], 5)}, )";
    setCellValue(sheet, TableHeadertyle, getStringRange(rowno, 4), "ટોટલ આવક");
    setCellFormula(sheet, TableHeadertyle, getStringRange(rowno, 5), getcell);

    rowno++;
    String getcell2 = "=SUM(${getStringRange(totalCell[0], 5)},${getStringRange(totalCell[3], 5)}, ${getStringRange(totalCell[4], 5)},)";
    setCellValue(sheet, TableHeadertyle, getStringRange(rowno, 4), "ટોટલ ખર્ચ");
    setCellFormula(sheet, TableHeadertyle, getStringRange(rowno, 5), getcell2);


    for(int i = 1; i <= sheet.getLastColumn();i++){
      sheet.autoFitColumn(i);
    }
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    DateTime now = new DateTime.now();
    String date = "${now.day}-${now.month}-${now.year}";

    final file = File('${Constants.DIR_HISAB}/Hisab_${date}.xlsx');
    await file.writeAsBytes(await bytes).then((value) {AppController().showToast(text:"Sheet Created");});
  }

  getTLoanList(List<GetTLoan> list) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    final Style FileHeaderStyle = FileHeaderCellStyle(workbook);
    //final Style DetailsStyle = DetailsCellStyle(workbook);
    final Style TableHeadertyle = TableHeaderCellStyle(workbook);
    final Style CommonStyle = CommonCellStyle(workbook);
    sheet.enableSheetCalculations();

    setCellValue(sheet, FileHeaderStyle, 'A1:F1', "બહાર થી લાવેલ લોન", autofit: false,merge: true);

    setCellValue(sheet, TableHeadertyle, getStringRange(4, 2), "ક્રમ");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 3), "તારીખ");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 4), "નામ");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 5), "મોબાઇલ નં");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 6), "લોન ની રકમ");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 7), "એડવાન્સ");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 8), "વ્યાજ દર");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 9), "હપ્તા ની રકમ");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 10), "મુદ્દત");

    int rowno = 6;
    for(var element in list){

      setCellValue(sheet, CommonStyle, getStringRange(rowno, 2), rowno - 5);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 3), element.tl_date);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 4), element.tl_name);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 5), element.tl_mobile);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 6), element.tl_amount);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 7), element.tl_advace);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 8), element.tl_irate);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 9), element.tl_emi);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 10), element.tl_month);

      rowno++;
    }

    for(int i = 1; i <= sheet.getLastColumn();i++){
      sheet.autoFitColumn(i);
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final file = File('${Constants.DIR_INVESTOR}/ Investor List.xlsx');
    await file.writeAsBytes(await bytes).then((value) {AppController().showToast(text:"Sheet Created");});
  }

  getTLoanDetailList(GetTLoan loan,List<GetTEmi> list) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    final Style FileHeaderStyle = FileHeaderCellStyle(workbook);
    //final Style DetailsStyle = DetailsCellStyle(workbook);
    final Style TableHeadertyle = TableHeaderCellStyle(workbook);
    final Style CommonStyle = CommonCellStyle(workbook);
    sheet.enableSheetCalculations();

    setCellValue(sheet, FileHeaderStyle, 'A1:F1', "${loan.tl_name} ની વિગત", autofit: false,merge: true);

    setCellValue(sheet, TableHeadertyle, getStringRange(3, 1), "તારીખ");
    setCellValue(sheet, TableHeadertyle, getStringRange(3, 3), "નામ");
    setCellValue(sheet, TableHeadertyle, getStringRange(3, 5), "મોબાઇલ નં");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 1), "લોન ની રકમ");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 3), "એડવાન્સ");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 5), "વ્યાજ દર");
    setCellValue(sheet, TableHeadertyle, getStringRange(5, 3), "હપ્તા ની રકમ");
    setCellValue(sheet, TableHeadertyle, getStringRange(5, 5), "મુદ્દત");

    setCellValue(sheet, CommonStyle, getStringRange(3, 2), loan.tl_date);
    setCellValue(sheet, CommonStyle, getStringRange(3, 4), loan.tl_name);
    setCellValue(sheet, CommonStyle, getStringRange(3, 6), loan.tl_mobile);
    setCellValue(sheet, CommonStyle, getStringRange(4, 2), loan.tl_amount);
    setCellValue(sheet, CommonStyle, getStringRange(4, 4), loan.tl_advace);
    setCellValue(sheet, CommonStyle, getStringRange(4, 6), loan.tl_irate);
    setCellValue(sheet, CommonStyle, getStringRange(5, 4), loan.tl_emi);
    setCellValue(sheet, CommonStyle, getStringRange(5, 6), loan.tl_month);


    setCellValue(sheet, TableHeadertyle, getStringRange(7, 2), "ક્રમ");
    setCellValue(sheet, TableHeadertyle, getStringRange(7, 3), "તારીખ");
    setCellValue(sheet, TableHeadertyle, getStringRange(7, 4), "રકમ");
    setCellValue(sheet, TableHeadertyle, getStringRange(7, 5), "જમા કરનાર");
    setCellValue(sheet, TableHeadertyle, getStringRange(7, 6), "જમા કર્યા ની તારીખ");

    int rowno = 8;
    for(var element in list){

      setCellValue(sheet, CommonStyle, getStringRange(rowno, 2), rowno - 7);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 3), element.temi_date);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 4), element.temi_amount);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 5), element.tm_name);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 6), element.temi_given_date);


      rowno++;
    }

    for(int i = 1; i <= sheet.getLastColumn();i++){
      sheet.autoFitColumn(i);
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    DateTime now = new DateTime.now();
    String date = "${now.day}-${now.month}-${now.year}";

    final file = File('${Constants.DIR_INVESTOR}/ ${loan.tl_name} ${loan.tl_amount} ${date} List.xlsx');
    await file.writeAsBytes(await bytes).then((value) {AppController().showToast(text:"Sheet Created");});
  }

  getTEminList(List<GivenList> list) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    final Style FileHeaderStyle = FileHeaderCellStyle(workbook);
    //final Style DetailsStyle = DetailsCellStyle(workbook);
    final Style TableHeadertyle = TableHeaderCellStyle(workbook);
    final Style CommonStyle = CommonCellStyle(workbook);
    sheet.enableSheetCalculations();

    setCellValue(sheet, FileHeaderStyle, 'A1:F1', "બહાર થી લાવેલ લોન", autofit: false,merge: true);

    setCellValue(sheet, TableHeadertyle, getStringRange(4, 2), "ક્રમ");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 3), "તારીખ");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 4), "નામ");
    setCellValue(sheet, TableHeadertyle, getStringRange(4, 5), "હપ્તા ની રકમ");

    int rowno = 6;
    for(var element in list){

      setCellValue(sheet, CommonStyle, getStringRange(rowno, 2), rowno - 5);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 3), element.temi_date);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 4), element.name);
      setCellValue(sheet, CommonStyle, getStringRange(rowno, 5), element.temi_amount);


      rowno++;
    }

    for(int i = 1; i <= sheet.getLastColumn();i++){
      sheet.autoFitColumn(i);
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    DateTime now = new DateTime.now();
    String date = "${now.day}-${now.month}-${now.year}";

    final file = File('${Constants.DIR_INVESTOR}/ Repayment ${date}.xlsx');
    await file.writeAsBytes(await bytes).then((value) {AppController().showToast(text:"Sheet Created");});
  }
}