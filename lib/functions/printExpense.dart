import 'package:finance/res/images.dart';
import 'package:finance/res/sizes.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void printExpense({
  required String date,
  required String type,
  required double amount,
  required String currency,
  required String? description,
}) async {
  final pdf = pw.Document();

  final image = pw.MemoryImage(
    (await rootBundle.load(MyImages.shaqadef)).buffer.asUint8List(),
  );

  final pdfFont = await rootBundle.load("assets/fonts/cairo-2/Cairo-Regular.ttf");
  final ttf = pw.Font.ttf(pdfFont);
  final safeDescription = description ?? 'لا توجد ملاحظات'; 

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Padding(
            padding: pw.EdgeInsets.all(hScreen * 0.03),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(child: pw.Image(image, width: wScreen * 0.25, height: wScreen * 0.25)),
                pw.SizedBox(height: hScreen * 0.02),
                pw.Center(
                  child: pw.Text(
                    'مصروف',
                    style: pw.TextStyle(fontSize: hScreen * 0.04, fontWeight: pw.FontWeight.bold, font: ttf),
                  ),
                ),
                pw.SizedBox(height: hScreen * 0.02),
                pw.Text('التاريخ: $date', style: pw.TextStyle(font: ttf)),
                pw.Text('نوع المصروف: $type', style: pw.TextStyle(font: ttf)),
                pw.Text('المبلغ: $amount', style: pw.TextStyle(font: ttf)),
                pw.Text('العملة: $currency', style: pw.TextStyle(font: ttf)),
                pw.SizedBox(height: hScreen * 0.03),
                pw.Text('الوصف:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttf)),
                 pw.Text(safeDescription, style: pw.TextStyle(font: ttf)),
                pw.Spacer(),
                pw.Divider(),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text('إدارة شقادف', style: pw.TextStyle(fontSize: hScreen * 0.02, font: ttf)),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );

  await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
}