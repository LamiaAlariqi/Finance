import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/cubits/invoice_cubit/invoice_cubit.dart';
import 'package:finance/functions/printInvoice.dart';
import 'package:finance/res/color_app.dart';
import 'package:finance/res/sizes.dart';
import 'package:finance/views/widget/currency_drop_down.dart';
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
  final TextEditingController _productNumberController =
      TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController(
    text: '1',
  );
  final TextEditingController _commissionController = TextEditingController(
    text: '0.00',
  );
  final TextEditingController _notesController = TextEditingController();

  String _selectedCurrency = 'USD';
  String _selectedCategory = 'الإلكترونيات';
  bool _includeCommission = false;
  bool _isLoading = false;

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
    _fetchInvoiceNumber();

    _priceController.addListener(_updateCommission);
    _quantityController.addListener(_updateCommission);
  }

  Future<void> _fetchInvoiceNumber() async {
    final cubit = context.read<InvoiceCubit>();
    final newNumber = await cubit.generateInvoiceNumber();
    if (mounted) _invoiceNumberController.text = newNumber;
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  void _updateCommission() {
    final cubit = context.read<InvoiceCubit>();
    final price = double.tryParse(_priceController.text) ?? 0;
    final quantity = double.tryParse(_quantityController.text) ?? 0;

    if (_includeCommission) {
      final commission = cubit.calculateCommission(price, quantity);
      setState(() {
        _commissionController.text = commission.toStringAsFixed(2);
      });
    } else {
      setState(() {
        _commissionController.text = '0.00';
      });
    }
  }

  void _saveInvoice({bool printAfterSave = false}) async {
    if (_clientNameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _quantityController.text.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final cubit = context.read<InvoiceCubit>();
    final price = double.tryParse(_priceController.text) ?? 0;
    final quantity = double.tryParse(_quantityController.text) ?? 0;

    final invoiceData = {
      'clientName': _clientNameController.text,
      'category': _selectedCategory,
      'price': price,
      'quantity': quantity,
      'currency': _selectedCurrency,
      'notes': _notesController.text,
      'date': _dateController.text,
      'productNumber': _productNumberController.text,
      'includeCommission': _includeCommission,
    };

    if (_includeCommission) {
      await cubit.addInvoice(
        clientName: invoiceData['clientName'] as String,
        category: invoiceData['category'] as String,
        price: invoiceData['price'] as double,
        quantity: invoiceData['quantity'] as double,
        currency: invoiceData['currency'] as String,
        notes: invoiceData['notes'] as String,
        date: invoiceData['date'] as String,
        productNumber: invoiceData['productNumber'] as String,
      );
    } else {
      final received = cubit.calculateTotal(price, quantity);
      await cubit.addInvoiceWithoutCommission(
        clientName: invoiceData['clientName'] as String,
        category: invoiceData['category'] as String,
        price: invoiceData['price'] as double,
        quantity: invoiceData['quantity'] as double,
        currency: invoiceData['currency'] as String,
        notes: invoiceData['notes'] as String,
        date: invoiceData['date'] as String,
        productNumber: invoiceData['productNumber'] as String,
        receivedAmount: received,
      );
    }

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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم حفظ الفاتورة بنجاح!'),
        duration: const Duration(seconds: 2),
      ),
    );

    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          width: wScreen * 0.8,
          padding: EdgeInsets.all(hScreen * 0.02),
          color: MyColors.Cardcolor,
          child: SingleChildScrollView(
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
                  controller: _invoiceNumberController,
                  readOnly: true,
                  width: 0.5,
                  enabledBorderColor: MyColors.kmainColor,
                  focusedBorderColor: MyColors.kmainColor,
                  obscureText: false,
                  keyboardType: TextInputType.numberWithOptions(),
                ),
                SizedBox(height: hScreen * 0.02),
                CustomTextFormField(
                  hintText: "التاريخ",
                  suffixIcon: Icons.calendar_today,
                  controller: _dateController,
                  readOnly: true,
                  width: 0.5,
                  enabledBorderColor: MyColors.kmainColor,
                  focusedBorderColor: MyColors.kmainColor,
                  obscureText: false,
                  keyboardType: TextInputType.datetime,
                ),
                SizedBox(height: hScreen * 0.02),
                CustomTextFormField(
                  hintText: "اسم العميل",
                  suffixIcon: Icons.person,
                  controller: _clientNameController,
                  width: 0.5,
                  enabledBorderColor: MyColors.kmainColor,
                  focusedBorderColor: MyColors.kmainColor,
                  obscureText: false,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: hScreen * 0.02),
                CustomTextFormField(
                  hintText: "رقم المنتج",
                  suffixIcon: Icons.qr_code,
                  keyboardType: TextInputType.number,
                  controller: _productNumberController,
                  width: 0.5,
                  enabledBorderColor: MyColors.kmainColor,
                  focusedBorderColor: MyColors.kmainColor,
                  obscureText: false,
                ),
                SizedBox(height: hScreen * 0.02),
                Row(
                  children: [
                    Checkbox(
                      value: _includeCommission,
                      onChanged: (v) {
                        setState(() {
                          _includeCommission = v!;
                        });
                        _updateCommission();
                      },
                    ),
                    const Text("مع العمولة"),
                  ],
                ),
                SizedBox(height: hScreen * 0.02),
                _buildCategoryDropdown(),
                SizedBox(height: hScreen * 0.02),
                CurrencyDropdown(
                  selectedCurrency: _selectedCurrency,
                  onCurrencyChanged: (newValue) {
                    setState(() {
                      _selectedCurrency = newValue!;
                    });
                  },
                ),
                SizedBox(height: hScreen * 0.02),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        hintText: "السعر",
                        width: 0.5,
                        suffixIcon: Icons.monetization_on,
                        keyboardType: TextInputType.number,
                        controller: _priceController,
                        enabledBorderColor: MyColors.kmainColor,
                        focusedBorderColor: MyColors.kmainColor,
                        obscureText: false,
                      ),
                    ),
                    SizedBox(width: hScreen * 0.01),
                    Expanded(
                      child: CustomTextFormField(
                        hintText: "الكمية",
                        width: 0.5,
                        suffixIcon: Icons.numbers,
                        keyboardType: TextInputType.number,
                        controller: _quantityController,
                        enabledBorderColor: MyColors.kmainColor,
                        focusedBorderColor: MyColors.kmainColor,
                        obscureText: false,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: hScreen * 0.02),
                if (_includeCommission)
                  CustomTextFormField(
                    hintText: "العمولة (10%)",
                    suffixIcon: Icons.percent,
                    controller: _commissionController,
                    readOnly: true,
                    width: 0.5,
                    enabledBorderColor: MyColors.kmainColor,
                    focusedBorderColor: MyColors.kmainColor,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                  ),
                SizedBox(height: hScreen * 0.02),
                CustomTextFormField(
                  hintText: "ملاحظات (اختياري)",
                  suffixIcon: Icons.note,
                  controller: _notesController,
                  width: 0.5,
                  enabledBorderColor: MyColors.kmainColor,
                  focusedBorderColor: MyColors.kmainColor,
                  obscureText: false,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: hScreen * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_isLoading)
                      SizedBox(
                        height: hScreen * 0.05,
                        width: wScreen * 0.25,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: MyColors.kmainColor,
                            strokeWidth: 3,
                          ),
                        ),
                      )
                    else
                      CustomMaterialButton(
                        title: "حفظ",
                        buttonColor: MyColors.kmainColor,
                        textColor: Colors.white,
                        onPressed: _saveInvoice,
                        height: hScreen * 0.05,
                        width: wScreen * 0.25,
                        borderColor: MyColors.kmainColor,
                        borderWidth: 0.5,
                        vertical: hScreen * 0.01,
                      ),
                    if (!_isLoading)
                      CustomMaterialButton(
                        title: "طباعة",
                        buttonColor: MyColors.kmainColor,
                        textColor: Colors.white,
                        onPressed: () => _saveInvoice(printAfterSave: true),
                        height: hScreen * 0.05,
                        width: wScreen * 0.25,
                        borderColor: MyColors.kmainColor,
                        borderWidth: 0.5,
                        vertical: hScreen * 0.01,
                      ),
                  ],
                ),
              ],
            ),
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
}
