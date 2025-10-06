import 'package:finance/data/models/invoice_data.dart';
import 'package:finance/data/services/invoice_service.dart';
import 'package:finance/res/color_app.dart';
import 'package:finance/res/sizes.dart';
import 'package:finance/views/widget/custom/customButton.dart';
import 'package:finance/views/widget/custom/custom_text.dart';
import 'package:finance/views/widget/invoiceCard.dart';
import 'package:finance/views/dialogs/invoice_dialog.dart';
import 'package:finance/views/widget/summarybox.dart';
import 'package:flutter/material.dart';


class SalesBody extends StatefulWidget {
  const SalesBody({super.key});

  @override
  State<SalesBody> createState() => _SalesBodyState();
}

class _SalesBodyState extends State<SalesBody> {
  // متغيرات الحالة (State) للفلترة والـ Stream
  String? _selectedMonth;
  // **جديد:** متغير للسنة المختارة
  int? _selectedYear; 
  
  late Stream<List<InvoiceData>> _invoicesStream;
  final InvoiceService _invoiceService = InvoiceService();
  
  
  late final List<int> _years;

  final List<String> months = [
    "يناير", "فبراير", "مارس", "أبريل", "مايو", "يونيو", 
    "يوليو", "أغسطس", "سبتمبر", "أكتوبر", "نوفمبر", "ديسمبر",
  ];
  
  final Map<String, String> monthMap = {
    "يناير": "January", "فبراير": "February", "مارس": "March", 
    "أبريل": "April", "مايو": "May", "يونيو": "June", 
    "يوليو": "July", "أغسطس": "August", "سبتمبر": "September", 
    "أكتوبر": "October", "نوفمبر": "November", "ديسمبر": "December",
  };

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final currentYear = now.year;
    
    // إعداد قائمة السنوات (آخر 5 سنوات حتى السنة الحالية)
    // List.generate(5, (index) => currentYear - index)
    _years = List.generate(5, (index) => currentYear - index);
    
    // تعيين الشهر والسنة الحاليين كقيمة افتراضية
    final currentMonthArabic = months[now.month - 1];
    _selectedMonth = currentMonthArabic;
    _selectedYear = currentYear;
    
    // تهيئة Stream الأولي
    _invoicesStream = Stream.value([]); // Stream فارغ مبدئياً لتجنب الخطأ
    _updateInvoicesStream();
  }

  // دالة موحدة لمعالجة تغيير الشهر أو السنة وتحديث الـ Stream
  void _updateInvoicesStream() {
    final monthArabic = _selectedMonth;
    final selectedYear = _selectedYear;

    if (monthArabic != null && selectedYear != null) {
      final englishMonth = monthMap[monthArabic];
      if (englishMonth != null) {
        // تحديث Stream لتشغيل جلب بيانات جديدة من Firestore بناءً على الشهر والسنة
        setState(() {
          _invoicesStream = _invoiceService.fetchAllInvoicesForMonth(
            englishMonth,
            selectedYear,
          );
        });
      }
    } else {
      // إرجاع Stream فارغ إذا لم يتم اختيار الشهر أو السنة
      setState(() {
        _invoicesStream = Stream.value([]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // =========================================================
        // العنوان والزر
        // =========================================================
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: hScreen * 0.03),
                CustomText(
                  text: "المبيعات والفواتير",
                  fontSize: fSize * 0.9,
                  fontWeight: FontWeight.bold,
                  color: MyColors.appTextColorPrimary,
                ),
                CustomText(
                  text: "إدارة جميع الفواتير والمبيعات",
                  fontSize: fSize * 0.8,
                  fontWeight: FontWeight.normal,
                  color: MyColors.appTextColorPrimary,
                ),
              ],
            ),
            CustomMaterialButton(
              title: "فاتورة جديدة",
              vertical: hScreen * 0.01,
              buttonColor: Colors.blue[100]!,
              textColor: MyColors.appTextColorPrimary,
              borderWidth: 0.5,
              borderColor: Colors.blue[100]!,
              height: hScreen * 0.06,
              width: wScreen * 0.25,
              textsize: fSize * 0.8,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const InvoiceDialog();
                  },
                );
              },
            ),
          ],
        ),

        SizedBox(height: hScreen * 0.03),

        // =========================================================
        // قائمة الفلترة (Dropdowns - Month & Year)
        // =========================================================
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hScreen * 0.02),
          child: Row(
            children: [
              // قائمة الشهور
              Expanded(
                child: DropdownButtonFormField<String>(
                  hint: const Text("اختر الشهر"),
                  value: _selectedMonth,
                  items: months.map((String month) {
                    return DropdownMenuItem<String>(value: month, child: Text(month));
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedMonth = newValue;
                    });
                    _updateInvoicesStream(); // تحديث الـ Stream
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

              // قائمة السنوات (جديد)
              Expanded(
                child: DropdownButtonFormField<int>(
                  hint: const Text("اختر السنة"),
                  value: _selectedYear,
                  items: _years.map((int year) {
                    return DropdownMenuItem<int>(value: year, child: Text(year.toString()));
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      _selectedYear = newValue;
                    });
                    _updateInvoicesStream(); // تحديث الـ Stream
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

        // =========================================================
        // StreamBuilder لعرض البيانات في الوقت الفعلي
        // =========================================================
        StreamBuilder<List<InvoiceData>>(
          stream: _invoicesStream,
          builder: (context, snapshot) {
            // حالة التحميل
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            // حالة الخطأ
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

            // حالة وجود بيانات
            final invoices = snapshot.data ?? [];
            final totalCount = invoices.length;
            
            // حساب القيمة الإجمالية (بفرض أن amount قابل للتحويل إلى double)
            // يتم التحويل من String إلى double لتجميع المبالغ
            final totalAmount = invoices.fold<double>(
              0, (sum, item) => sum + (double.tryParse(item.amount) ?? 0));


            // ملخص الإجمالي
            final summary = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CustomText(
                    text: "اجمالي الفواتير",
                    fontSize: fSize * 0.8,
                    fontWeight: FontWeight.normal,
                    color: MyColors.appTextColorPrimary,
                  ),
                ),
                Container(
                   padding: EdgeInsets.symmetric(horizontal: wScreen*0.02),
            width: wScreen*1,
                  child: SummaryBox(
                    color: Colors.blue[100],
                    icon: Icons.description,
                    label: ' فاتورة ',
                    value: totalCount.toString(),
                  ),
                ),
              ],
            );

            // حالة عدم وجود بيانات
            if (invoices.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  summary,
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: CustomText(
                        text: "لا توجد فواتير لهذا الشهر والسنة المحددين.",
                        fontSize: fSize * 0.9,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              );
            }

            // عرض الملخص وقائمة الفواتير
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                summary,
                
                // عرض الفواتير
                ...invoices.map(
                  (invoice) => InvoiceCard(
                    invoiceNumber: invoice.invoiceNumber,
                    date: invoice.date,
                    clientName: invoice.clientName,
                    currency: invoice.currency,
                    amount: invoice.amount,
                    productnumber: invoice.productNumber,
                  ),
                ).toList(),
              ],
            );
          },
        ),
      ],
    );
  }
}