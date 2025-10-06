import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/cubits/invoice_cubit/invoice_cubit.dart';
import 'package:finance/cubits/invoice_cubit/invoice_state.dart';
import 'package:finance/functions/printInvoice.dart';
import 'package:finance/res/color_app.dart';
import 'package:finance/res/sizes.dart';
import 'package:finance/views/widget/custom/customButton.dart';
import 'package:finance/views/widget/custom/customTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvoiceDialog extends StatefulWidget {
  const InvoiceDialog({super.key});

  @override
  State<InvoiceDialog> createState() => _InvoiceDialogState();
}

class _InvoiceDialogState extends State<InvoiceDialog> {
  final TextEditingController _invoiceNumberController =
      TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController(
    text: '0.00',
  );
  final TextEditingController _productNumberController =
      TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController(
    text: '1',
  );
  final TextEditingController _commissionController = TextEditingController(
    text: '0.00',
  ); // قيمة مبدئية
  final TextEditingController _notesController = TextEditingController();

  String _selectedCurrency = 'USD';
  String _selectedCategory = 'الإلكترونيات';

  final List<String> _categories = [
    'الألعاب ومتعلقات الأطفال',
    'الإكسسوارات والمجوهرات',
    'الإلكترونيات',
    'الكهربائيات',
    'الخردة المعدنية',
    'الأجهزة الرياضية',
    'الحقائب ومستلزمات التخييم',
    'الأثاث المنزلي والمكتبي',
    'أدوات المطبخ',
    'الكاميرات وأدوات التصوير',
    'الأنتيكات',
    'النظارات',
    'الخردة البلاستيكية',
    'الخردة الإلكترونية',
    'الخردة النحاس',
    'الخردة الحديد',
  ];

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDate(DateTime.now());
    _priceController.addListener(_updateCommission);
    _priceController.addListener(_updateCalculations);
    _quantityController.addListener(_updateCalculations);
    _fetchInvoiceNumber();
  }

  Future<void> _fetchInvoiceNumber() async {
    final cubit = context.read<InvoiceCubit>();
    final newNumber = await cubit.generateInvoiceNumber();
    if (mounted) {
      _invoiceNumberController.text = newNumber;
    }
  }

  void _updateCalculations() {
    final price = double.tryParse(_priceController.text) ?? 0;
    final quantity = double.tryParse(_quantityController.text) ?? 0;

    // 1. حساب الإجمالي
    final totalAmount = price * quantity;

    // 2. حساب العمولة
    final commission = totalAmount * 0.10;

    if (mounted) {
      setState(() {
        // تعبئة حقل الإجمالي
        _totalAmountController.text = totalAmount.toStringAsFixed(2);
        // تعبئة حقل العمولة
        _commissionController.text = commission.toStringAsFixed(2);
      });
    }
  }

  @override
  void dispose() {
    _priceController.removeListener(_updateCommission);
    _quantityController.removeListener(_updateCommission);
    _invoiceNumberController.dispose();
    _dateController.dispose();
    _clientNameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _commissionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // تنسيق التاريخ
  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  // حساب العمولة مؤقتًا
  void _updateCommission() {
    final price = double.tryParse(_priceController.text) ?? 0;
    final quantity = double.tryParse(_quantityController.text) ?? 0;
    final commission = price * quantity * 0.10;

    if (mounted) {
      setState(() {
        _commissionController.text = commission.toStringAsFixed(2);
      });
    }
  }

  void _saveInvoice({bool printAfterSave = false}) {
    if (_clientNameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _quantityController.text.isEmpty) {
      return;
    }

    final price = double.tryParse(_priceController.text) ?? 0;
    final quantity = double.tryParse(_quantityController.text) ?? 0;

    context.read<InvoiceCubit>().addInvoice(
      clientName: _clientNameController.text,
      category: _selectedCategory,
      price: price,
      quantity: quantity,
      currency: _selectedCurrency,
      notes: _notesController.text,
      date: _dateController.text,
      productNumber: _productNumberController.text,
    ).then((_) {
      if (printAfterSave) {
        printInvoice(
          invoiceNumber: _invoiceNumberController.text,
          date: _dateController.text,
          clientName: _clientNameController.text,
          category: _selectedCategory,
          currency: _selectedCurrency,
          price: _priceController.text,
          quantity: _quantityController.text,
          commission: _commissionController.text,
          notes: _notesController.text,
          productNumber: _productNumberController.text,
        );
      }
    });
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
          child: BlocConsumer<InvoiceCubit, InvoiceState>(
            listener: (context, state) {
              if (state is InvoiceSuccess) {
                Navigator.of(context).pop();
              } else if (state is InvoiceError) {
                print("Error: ${state.message}");
              }
            },
            builder: (context, state) {
              final isLoading = state is InvoiceLoading;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'إضافة فاتورة جديدة',
                          style: TextStyle(
                            fontSize: fSize * 0.9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    SizedBox(height: hScreen * 0.02),

                    CustomTextFormField(
                      hintText: "رقم الفاتورة",
                      suffixIcon: Icons.numbers,
                      obscureText: false,
                      keyboardType: TextInputType.text,
                      controller: _invoiceNumberController,
                      readOnly: true,
                      width: 0.5,
                      enabledBorderColor: MyColors.kmainColor,
                      focusedBorderColor: MyColors.kmainColor,
                      suffixIconColor: Colors.grey,
                    ),
                    SizedBox(height: hScreen * 0.02),

                    // التاريخ
                    CustomTextFormField(
                      hintText: "التاريخ",
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
                    SizedBox(height: hScreen * 0.02),

                    // العميل
                    CustomTextFormField(
                      hintText: "اسم العميل",
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
                    CustomTextFormField(
                      hintText: "رقم المنتج",
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
                    // الفئة
                    _buildCategoryDropdown(),
                    SizedBox(height: hScreen * 0.02),

                    // العملة
                    _buildCurrencyDropdown(),
                    SizedBox(height: hScreen * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            hintText: "السعر",
                            suffixIcon: Icons.monetization_on,
                            obscureText: false,
                            keyboardType: TextInputType.number,
                            controller: _priceController,
                            enabledBorderColor: MyColors.kmainColor,
                            focusedBorderColor: MyColors.kmainColor,
                            width: 0.5,
                          ),
                        ),
                        SizedBox(width: hScreen * 0.01),
                        Expanded(
                          child: CustomTextFormField(
                            hintText: "الكمية",
                            suffixIcon: Icons.numbers,
                            obscureText: false,
                            keyboardType: TextInputType.number,
                            controller: _quantityController,
                            enabledBorderColor: MyColors.kmainColor,
                            focusedBorderColor: MyColors.kmainColor,
                            width: 0.5,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: hScreen * 0.02,
                    ), // مسافة بعد صف السعر والكمية
                    SizedBox(height: hScreen * 0.02),

                    // العمولة (للعرض فقط)
                    CustomTextFormField(
                      hintText: "العمولة (10%)",
                      suffixIcon: Icons.percent,
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      controller: _commissionController,
                      readOnly: true,
                      width: 0.5,
                      enabledBorderColor: MyColors.kmainColor,
                      focusedBorderColor: MyColors.kmainColor,
                    ),
                    SizedBox(height: hScreen * 0.02),

                    // ملاحظات
                    CustomTextFormField(
                      hintText: "ملاحظات (اختياري)",
                      suffixIcon: Icons.note,
                      obscureText: false,
                      keyboardType: TextInputType.text,
                      controller: _notesController,
                      width: 0.5,
                      enabledBorderColor: MyColors.kmainColor,
                      focusedBorderColor: MyColors.kmainColor,
                    ),
                    SizedBox(height: hScreen * 0.03),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : CustomMaterialButton(
                                title: "حفظ",
                                vertical: hScreen * 0.01,
                                buttonColor: MyColors.kmainColor,
                                textColor: Colors.white,
                                borderWidth: 0.5,
                                borderColor: MyColors.kmainColor,
                                height: hScreen * 0.05,
                                width: wScreen * 0.25,
                                textsize: fSize * 0.9,
                                onPressed: _saveInvoice,
                              ),
                        SizedBox(height: hScreen * 0.02),
                        CustomMaterialButton(
                          title: "طباعة",
                          vertical: hScreen * 0.01,
                          buttonColor: MyColors.kmainColor,
                          textColor: Colors.white,
                          borderWidth: 0.5,
                          borderColor: MyColors.kmainColor,
                          height: hScreen * 0.05,
                          width: wScreen * 0.25,
                          textsize: fSize * 0.9,
                          onPressed: () {
                           _saveInvoice(printAfterSave: true);
                          },
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

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('الفئة', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          items: _categories
              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              .toList(),
          onChanged: (v) => setState(() => _selectedCategory = v!),
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget _buildCurrencyDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('العملة', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: _selectedCurrency,
          items: const [
            DropdownMenuItem(value: 'USD', child: Text('دولار أمريكي')),
            DropdownMenuItem(value: 'YER', child: Text('ريال يمني')),
            DropdownMenuItem(value: 'SAR', child: Text('ريال سعودي')),
          ],
          onChanged: (v) => setState(() => _selectedCurrency = v!),
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
      ],
    );
  }
}
