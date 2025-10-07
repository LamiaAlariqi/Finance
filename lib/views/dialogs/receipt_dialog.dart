import 'package:finance/cubits/receipt_cubit/receipt_cubit.dart';
import 'package:finance/cubits/receipt_cubit/receipt_state.dart';
import 'package:finance/functions/printReceipt.dart';
import 'package:finance/res/color_app.dart';
import 'package:finance/res/sizes.dart';
import 'package:finance/views/widget/currency_drop_down.dart';
import 'package:finance/views/widget/custom/customButton.dart';
import 'package:flutter/material.dart';
import 'package:finance/views/widget/custom/customTextFormField.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReceiptDialog extends StatefulWidget {
  const ReceiptDialog({super.key});

  @override
  State<ReceiptDialog> createState() => _ReceiptDialogState();
}

class _ReceiptDialogState extends State<ReceiptDialog> {
  final TextEditingController _receiptNumberController = TextEditingController(
    text: 'RCPT-001',
  );
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _productNumberController =
      TextEditingController();

  String _selectedCurrency = 'SAR';

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDate(DateTime.now());
    _fetchReceiptNumber();
  }

  Future<void> _fetchReceiptNumber() async {
    final cubit = context.read<ReceiptCubit>();
    final newNumber = await cubit.generateReceiptNumber();
    if (mounted) _receiptNumberController.text = newNumber;
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  void dispose() {
    _receiptNumberController.dispose();
    _dateController.dispose();
    _clientNameController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    _productNumberController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = _formatDate(picked);
      });
    }
  }

  void _saveReceipt({bool printAfterSave = false}) async {
    if (_clientNameController.text.isEmpty || _amountController.text.isEmpty) {
      return;
    }

    final amount = double.tryParse(_amountController.text) ?? 0.0;
    await context.read<ReceiptCubit>().addReceipt(
      clientName: _clientNameController.text,
      amount: amount,
      currency: _selectedCurrency,
      notes: _notesController.text,
      date: _dateController.text,
      productNumber: _productNumberController.text,
    );

    if (printAfterSave) {
      printReceipt(
        receiptNumber: _receiptNumberController.text,
        date: _dateController.text,
        clientName: _clientNameController.text,
        amount: _amountController.text,
        currency: _selectedCurrency,
        productNumber: _productNumberController.text,
        notes: _notesController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: wScreen * 0.8,
          padding: EdgeInsets.all(hScreen * 0.02),
          color: MyColors.Cardcolor,
          child: BlocConsumer<ReceiptCubit, ReceiptState>(
            listener: (context, state) {
              if (state is ReceiptSuccess) {
                _fetchReceiptNumber();
                Navigator.of(context).pop();
              } else if (state is ReceiptError) {}
            },
            builder: (context, state) {
              final isLoading = state is ReceiptLoading;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'إضافة سند قبض جديد',
                          style: TextStyle(
                            fontSize: fSize * 0.9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    Text(
                      'أدخل تفاصيل السند',
                      style: TextStyle(fontSize: fSize * 0.8),
                    ),
                    SizedBox(height: hScreen * 0.03),

                    // ===== رقم السند (مقفل) =====
                    CustomTextFormField(
                      hintText: "رقم السند",
                      fontsize: fSize * 0.85,
                      suffixIcon: Icons.numbers,
                      obscureText: false,
                      keyboardType: TextInputType.text,
                      controller: _receiptNumberController,
                      readOnly: true,
                      width: 0.5,
                      enabledBorderColor: MyColors.kmainColor,
                      focusedBorderColor: MyColors.kmainColor,
                      suffixIconColor: Colors.grey,
                    ),
                    SizedBox(height: hScreen * 0.02),

                    // ===== التاريخ =====
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: CustomTextFormField(
                          hintText: "التاريخ",
                          fontsize: fSize * 0.85,
                          suffixIcon: Icons.calendar_today,
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          controller: _dateController,
                          readOnly: true,
                          width: 0.5,
                          enabledBorderColor: MyColors.kmainColor,
                          focusedBorderColor: MyColors.kmainColor,
                          suffixIconColor: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: hScreen * 0.02),

                    // ===== المبلغ والعملة =====
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            hintText: "المبلغ",
                            fontsize: fSize * 0.85,
                            suffixIcon: Icons.attach_money,
                            obscureText: false,
                            keyboardType: TextInputType.number,
                            controller: _amountController,
                            width: 0.5,
                            enabledBorderColor: MyColors.kmainColor,
                            focusedBorderColor: MyColors.kmainColor,
                            suffixIconColor: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CurrencyDropdown(
                            selectedCurrency: _selectedCurrency,
                            onCurrencyChanged: (newValue) {
                              setState(() {
                                _selectedCurrency =
                                    newValue!; 

                                  
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: hScreen * 0.02),

                    // ===== اسم العميل =====
                    CustomTextFormField(
                      hintText: "اسم العميل",
                      fontsize: fSize * 0.85,
                      suffixIcon: Icons.person,
                      obscureText: false,
                      keyboardType: TextInputType.text,
                      controller: _clientNameController,
                      width: 0.5,
                      enabledBorderColor: MyColors.kmainColor,
                      focusedBorderColor: MyColors.kmainColor,
                      suffixIconColor: Colors.grey,
                    ),
                    SizedBox(height: hScreen * 0.02),

                    // ===== رقم القطعة =====
                    CustomTextFormField(
                      hintText: "رقم القطعة",
                      fontsize: fSize * 0.85,
                      suffixIcon: Icons.qr_code,
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      controller: _productNumberController,
                      width: 0.5,
                      enabledBorderColor: MyColors.kmainColor,
                      focusedBorderColor: MyColors.kmainColor,
                      suffixIconColor: Colors.grey,
                    ),
                    SizedBox(height: hScreen * 0.02),

                    // ===== ملاحظات =====
                    CustomTextFormField(
                      hintText: "ملاحظات (اختياري)",
                      suffixIcon: Icons.note,
                      obscureText: false,
                      fontsize: fSize * 0.8,
                      keyboardType: TextInputType.text,
                      controller: _notesController,
                      width: 0.5,
                      enabledBorderColor: MyColors.kmainColor,
                      focusedBorderColor: MyColors.kmainColor,
                      suffixIconColor: Colors.grey,
                    ),
                    SizedBox(height: hScreen * 0.02),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        isLoading
                            ? const CircularProgressIndicator()
                            : CustomMaterialButton(
                                title: "حفظ",
                                buttonColor: MyColors.kmainColor,
                                textColor: Colors.white,
                                onPressed: _saveReceipt, // حفظ فقط
                                height: hScreen * 0.05,
                                width: wScreen * 0.25,
                                borderColor: MyColors.kmainColor,
                                borderWidth: 0.5,
                                vertical: hScreen * 0.01,
                                textsize: fSize * 0.9,
                              ),

                        // زر الطباعة (حفظ وطباعة)
                        CustomMaterialButton(
                          title: "حفظ وطباعة",
                          buttonColor: MyColors.kmainColor,
                          textColor: Colors.white,
                          onPressed: isLoading
                              ? null
                              : () => _saveReceipt(
                                  printAfterSave: true,
                                ), // حفظ وطباعة
                          height: hScreen * 0.05,
                          width: wScreen * 0.35,
                          borderColor: MyColors.kmainColor,
                          borderWidth: 0.5,
                          vertical: hScreen * 0.01,
                          textsize: fSize * 0.9,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
