import 'package:finance/data/models/receipts_data.dart';
import 'package:finance/data/services/receipts_services.dart';
import 'package:finance/functions/printReceipt.dart';
import 'package:finance/views/widget/currency_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:finance/res/color_app.dart';
import 'package:finance/res/sizes.dart';
import 'package:finance/views/widget/custom/customButton.dart';
import 'package:finance/views/widget/custom/custom_text.dart';
import 'package:finance/views/widget/invoiceCard.dart';
import 'package:finance/views/dialogs/receipt_dialog.dart';
import 'package:finance/views/widget/summarybox.dart';

class ReceiptsBody extends StatefulWidget {
 const ReceiptsBody({super.key});

 @override
 State<ReceiptsBody> createState() => _ReceiptsBodyState();
}

class _ReceiptsBodyState extends State<ReceiptsBody> {
 
 String? _selectedMonth;
 int? _selectedYear; 
  
 late final List<int> _years;
 String? _selectedCurrency; 
 
 late Stream<List<ReceiptData>> _receiptsStream;

 final ReceiptService _receiptService = ReceiptService();

 final List<String> months = [
  "يناير",
  "فبراير",
  "مارس",
  "أبريل",
  "مايو",
  "يونيو",
  "يوليو",
  "أغسطس",
  "سبتمبر",
  "أكتوبر",
  "نوفمبر",
  "ديسمبر",
 ];

 final Map<String, String> monthMap = {
  "يناير": "January",
  "فبراير": "February",
  "مارس": "March",
  "أبريل": "April",
  "مايو": "May",
  "يونيو": "June",
  "يوليو": "July",
  "أغسطس": "August",
  "سبتمبر": "September",
  "أكتوبر": "October",
  "نوفمبر": "November",
  "ديسمبر": "December",
 };

 @override
 void initState() {
  super.initState();
    final now = DateTime.now();
    final currentYear = now.year;
    
    _years = List.generate(5, (index) => currentYear - index);

  final currentMonthArabic = months[now.month - 1];
  _selectedMonth = currentMonthArabic;
    _selectedYear = currentYear;
     _selectedCurrency = 'SAR';

  _receiptsStream = Stream.value([]); 
    _updateReceiptsStream();
 }
 
  void _updateReceiptsStream() {
    final monthArabic = _selectedMonth;
    final selectedYear = _selectedYear;

    if (monthArabic != null && selectedYear != null && _selectedCurrency != null) {
      final englishMonth = monthMap[monthArabic];
      if (englishMonth != null) {
        setState(() {
          _receiptsStream = _receiptService.fetchAllReceiptsForMonth(
            englishMonth,
            selectedYear, 
            _selectedCurrency!
          );
        });
      }
    } else {
      setState(() {
        _receiptsStream = Stream.value([]);
      });
    }
  }

 @override
 Widget build(BuildContext context) {
  return ListView(
   padding: EdgeInsets.all(wScreen * 0.02),
   children: [
    Row(
     mainAxisAlignment: MainAxisAlignment.spaceBetween,
     children: [
      Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        SizedBox(height: hScreen * 0.03),
        CustomText(
         text: "سندات القبض",
         fontSize: fSize * 0.9,
         fontWeight: FontWeight.bold,
         color: MyColors.appTextColorPrimary,
        ),
        CustomText(
         text: "إدارة جميع سندات القبض",
         fontSize: fSize * 0.8,
         fontWeight: FontWeight.normal,
         color: MyColors.appTextColorPrimary,
        ),
       ],
      ),
      CustomMaterialButton(
       title: "سند قبض جديد",
       vertical: hScreen * 0.01,
       buttonColor: Colors.green[100]!,
       textColor: MyColors.appTextColorPrimary,
       borderWidth: 0.5,
       borderColor: Colors.green[100]!,
       height: hScreen * 0.06,
       width: wScreen * 0.25,
       textsize: fSize * 0.8,
       onPressed: () {
        showDialog(
         context: context,
         builder: (BuildContext context) {
          return const ReceiptDialog();
         },
        );
       },
      ),
     ],
    ),

    SizedBox(height: hScreen * 0.03),
        
    Padding(
     padding: EdgeInsets.symmetric(horizontal: hScreen * 0.02),
     child: Row(
            children: [
              
              Expanded(
                child: DropdownButtonFormField<String>(
                  hint: const Text("اختر الشهر"),
                  value: _selectedMonth,
                  items: months.map((String month) {
                    return DropdownMenuItem<String>(value: month, child: Text(month));
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedMonth = newValue;
                      });
                      _updateReceiptsStream();
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  dropdownColor: MyColors.Cardcolor,
                ),
              ),

              SizedBox(width: wScreen * 0.05),

              
              Expanded(
                child: DropdownButtonFormField<int>(
                  hint: const Text("اختر السنة"),
                  value: _selectedYear,
                  items: _years.map((int year) {
                    return DropdownMenuItem<int>(value: year, child: Text(year.toString()));
                  }).toList(),
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedYear = newValue;
                      });
                      _updateReceiptsStream();
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  dropdownColor: MyColors.Cardcolor,
                ),
              ),
            ],
          ),
    ),
    
   SizedBox(height: hScreen * 0.03),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hScreen * 0.02),
          child: CurrencyDropdown(
            selectedCurrency: _selectedCurrency ?? 'SAR',
            onCurrencyChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedCurrency = newValue;
                });
                _updateReceiptsStream();
              }
            },
          ),
        ),
    SizedBox(height: hScreen * 0.03),

    StreamBuilder<List<ReceiptData>>(
     stream: _receiptsStream,
     builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
       return Center(
        child: Padding(
         padding: EdgeInsets.all(hScreen * 0.02),
         child: CircularProgressIndicator(),
        ),
       );
      }

      if (snapshot.hasError) {
       return Center(
        child: Padding(
         padding: const EdgeInsets.all(20.0),
         child: CustomText(
          text: "حدث خطأ في جلب البيانات: ${snapshot.error}",
          fontSize: fSize * 0.8,
          fontWeight: FontWeight.normal,
          color: Colors.red,
         ),
        ),
       );
      }

      
      final receipts = snapshot.data ?? [];
      final totalCount = receipts.length;
      final totalAmount = receipts.fold<double>(
       0,
       (sum, item) => sum + item.amount,
      );

      if (receipts.isEmpty) {
       return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Container(
          padding: EdgeInsets.symmetric(horizontal: wScreen * 0.02),
          width: wScreen * 1,
          child: SummaryBox(
           color: Colors.green[100],
           icon: Icons.description,
           label: 'سند',
           value: totalCount.toString(),
          ),
         ),
         Center(
          child: Padding(
           padding: const EdgeInsets.only(top: 40.0),
           child: CustomText(
            text: "لا توجد سندات قبض لهذا الشهر والسنة المحددين.",
            fontSize: fSize * 0.9,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
           ),
          ),
         ),
        ],
       );
      }

      return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        Container(
         padding: EdgeInsets.symmetric(horizontal: wScreen * 0.02),
         width: wScreen * 1,
         child: SummaryBox(
          color: Colors.green[100],
          icon: Icons.description,
          label: 'سند',
          value: totalCount.toString(),
         ),
        ),

        
        ...receipts
          .map(
           (receipt) => GestureDetector(
            onTap: (){
              printReceipt(
                receiptNumber: receipt.receiptNumber, 
                date: receipt.date, clientName: receipt.clientName, 
                amount: (receipt.amount).toString(), currency: receipt.currency,
                 productNumber: receipt.productNumber, 
                 notes: receipt.notes);
            },
             child: InvoiceCard(
              invoiceNumber: receipt.receiptNumber,
              date: receipt.date,
              clientName: receipt.clientName,
              currency: receipt.currency,
              amount: (receipt.amount).toString(),
              productnumber: receipt.productNumber,
             ),
           ),
          )
          .toList(),
       ],
      );
     },
    ),
   ],
  );
 }
}
