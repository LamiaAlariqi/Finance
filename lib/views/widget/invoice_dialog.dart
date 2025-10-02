import 'package:finance/res/color_app.dart';
import 'package:finance/res/sizes.dart';
import 'package:finance/views/widget/custom/customButton.dart';
import 'package:flutter/material.dart';
import 'package:finance/views/widget/custom/customTextFormField.dart';

class InvoiceDialog extends StatefulWidget {
  const InvoiceDialog({super.key});

  @override
  State<InvoiceDialog> createState() => _InvoiceDialogState();
}

class _InvoiceDialogState extends State<InvoiceDialog> {
  final TextEditingController _invoiceNumberController = TextEditingController(text: 'INV-001');
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _commissionController = TextEditingController(text: '0');
  final TextEditingController _notesController = TextEditingController();
  final ProductItem _productItem = ProductItem();

  String _selectedCurrency = 'USD';

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDate(DateTime.now());
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  void dispose() {
    _invoiceNumberController.dispose();
    _dateController.dispose();
    _clientNameController.dispose();
    _commissionController.dispose();
    _notesController.dispose();
    _productItem.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          width: wScreen * 0.8,
          padding: EdgeInsets.all(hScreen * 0.02),
          color: MyColors.Cardcolor,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== العنوان =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'إضافة فاتورة جديدة',
                      style: TextStyle(fontSize: fSize * 0.9, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                Text('أدخل تفاصيل الفاتورة والمنتج', style: TextStyle(fontSize: fSize * 0.8)),
                SizedBox(height: hScreen * 0.03),

                // ===== رقم الفاتورة =====
                CustomTextFormField(
                  hintText: "رقم الفاتورة",
                  suffixIcon: Icons.numbers,
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  controller: _invoiceNumberController,
                  readOnly: true,
                  width: 1,
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
                      suffixIcon: Icons.calendar_today,
                      obscureText: false,
                      keyboardType: TextInputType.text,
                      controller: _dateController,
                      readOnly: true,
                      width: 1,
                      enabledBorderColor: MyColors.kmainColor,
                      focusedBorderColor: MyColors.kmainColor,
                      suffixIconColor: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: hScreen * 0.02),

                // ===== اسم العميل =====
                CustomTextFormField(
                  hintText: "اسم العميل",
                  suffixIcon: Icons.person,
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  controller: _clientNameController,
                  width: 1,
                  enabledBorderColor: MyColors.kmainColor,
                  focusedBorderColor: MyColors.kmainColor,
                  suffixIconColor: Colors.grey,
                ),
                SizedBox(height: hScreen * 0.02),

                // ===== العملة =====
                _buildCurrencyDropdown(),
                SizedBox(height: hScreen * 0.02),

                // ===== بيانات المنتج =====
                Text(
                  'تفاصيل المنتج',
                  style: TextStyle(fontSize: fSize * 0.9, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ProductItemWidget(
                  item: _productItem,
                  onChanged: () => setState(() {}),
                ),

                const SizedBox(height: 20),

                // ===== ملاحظات =====
                CustomTextFormField(
                  hintText: "ملاحظات (اختياري)",
                  suffixIcon: Icons.note,
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  controller: _notesController,
                  width: 1,
                  enabledBorderColor: MyColors.kmainColor,
                  focusedBorderColor: MyColors.kmainColor,
                  suffixIconColor: Colors.grey,
                ),
                SizedBox(height: hScreen * 0.02),

                // ===== زر الحفظ =====
                Align(
                  alignment: Alignment.bottomLeft,
                  child: CustomMaterialButton(
                    title: "حفظ",
                    vertical: hScreen * 0.01,
                    buttonColor: MyColors.kmainColor,
                    textColor: Colors.white,
                    borderWidth: 0.5,
                    borderColor: MyColors.kmainColor,
                    height: hScreen * 0.05,
                    width: wScreen * 0.25,
                    textsize: fSize * 0.9,
                    onPressed: () {
                      // منطق الحفظ
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
          items: [
            DropdownMenuItem(value: 'USD', child: Text('دولار أمريكي', style: TextStyle(fontSize: fSize * 0.8))),
            DropdownMenuItem(value: 'YER', child: Text('ريال يمني', style: TextStyle(fontSize: fSize * 0.8))),
            DropdownMenuItem(value: 'SAR', child: Text('ريال سعودي', style: TextStyle(fontSize: fSize * 0.8))),
          ],
          onChanged: (String? newValue) {
            setState(() {
              _selectedCurrency = newValue!;
            });
          },
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
        ),
      ],
    );
  }
}

// ======================== الكلاسات الخاصة بالمنتج ========================

class ProductItem {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController(text: '0');
  final TextEditingController quantityController = TextEditingController(text: '1');

  double get total {
    final price = double.tryParse(priceController.text) ?? 0.0;
    final quantity = int.tryParse(quantityController.text) ?? 0;
    return price * quantity;
  }

  void dispose() {
    nameController.dispose();
    priceController.dispose();
    quantityController.dispose();
  }
}

class ProductItemWidget extends StatefulWidget {
  final ProductItem item;
  final VoidCallback onChanged;

  const ProductItemWidget({
    super.key,
    required this.item,
    required this.onChanged,
  });

  @override
  State<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  @override
  void initState() {
    super.initState();
    widget.item.priceController.addListener(widget.onChanged);
    widget.item.quantityController.addListener(widget.onChanged);
  }

  @override
  void dispose() {
    widget.item.priceController.removeListener(widget.onChanged);
    widget.item.quantityController.removeListener(widget.onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ===== اسم المنتج =====
        CustomTextFormField(
          hintText: "اسم المنتج/الخدمة",
          suffixIcon: Icons.shopping_bag,
          obscureText: false,
          keyboardType: TextInputType.text,
          controller: widget.item.nameController,
          width: 1,
          enabledBorderColor: MyColors.kmainColor,
          focusedBorderColor: MyColors.kmainColor,
          suffixIconColor: Colors.grey,
        ),
        const SizedBox(height: 10),

        // ===== السعر والكمية والإجمالي =====
        Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                hintText: "السعر",
                suffixIcon: Icons.monetization_on,
                obscureText: false,
                keyboardType: TextInputType.number,
                controller: widget.item.priceController,
                width: 1,
                enabledBorderColor: MyColors.kmainColor,
                focusedBorderColor: MyColors.kmainColor,
                suffixIconColor: Colors.grey,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CustomTextFormField(
                hintText: "الكمية",
                suffixIcon: Icons.confirmation_number,
                obscureText: false,
                keyboardType: TextInputType.number,
                controller: widget.item.quantityController,
                width: 1,
                enabledBorderColor: MyColors.kmainColor,
                focusedBorderColor: MyColors.kmainColor,
                suffixIconColor: Colors.grey,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('الإجمالي', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.item.total.toStringAsFixed(2)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
