import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/transaction.dart';
import '../../providers/transaction_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TransactionType _selectedType = TransactionType.expense;
  String _selectedCategory = 'Makanan';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi'),
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF2F6FF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: Colors.white,
          elevation: 10,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildDropdownType(),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _titleController,
                    label: 'Judul Transaksi',
                    icon: Icons.edit_note_rounded,
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Judul tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _amountController,
                    label: 'Jumlah Uang',
                    icon: Icons.attach_money_rounded,
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Jumlah tidak boleh kosong';
                      if (double.tryParse(val) == null) return 'Masukkan angka yang valid';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildCategoryDropdown(),
                  const SizedBox(height: 20),
                  _buildDatePicker(context),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _noteController,
                    label: 'Catatan (opsional)',
                    icon: Icons.notes_rounded,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 30),
                  _buildSubmitButton(transactionProvider),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownType() {
    return DropdownButtonFormField<TransactionType>(
      initialValue: _selectedType,
      decoration: _inputDecoration(
        label: 'Jenis Transaksi',
        icon: _selectedType == TransactionType.income
            ? Icons.arrow_downward_rounded
            : Icons.arrow_upward_rounded,
        iconColor: _selectedType == TransactionType.income ? Colors.green : Colors.redAccent,
      ),
      items: TransactionType.values.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(
            type == TransactionType.income ? 'Pemasukan' : 'Pengeluaran',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) setState(() => _selectedType = value);
      },
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedCategory,
      decoration: _inputDecoration(label: 'Kategori', icon: Icons.category_rounded),
      items: const [
        DropdownMenuItem(value: 'Makanan', child: Text('Makanan')),
        DropdownMenuItem(value: 'Transportasi', child: Text('Transportasi')),
        DropdownMenuItem(value: 'Hiburan', child: Text('Hiburan')),
        DropdownMenuItem(value: 'Pendidikan', child: Text('Pendidikan')),
        DropdownMenuItem(value: 'Tabungan', child: Text('Tabungan')),
        DropdownMenuItem(value: 'Lainnya', child: Text('Lainnya')),
      ],
      onChanged: (value) {
        if (value != null) setState(() => _selectedCategory = value);
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      decoration: _inputDecoration(label: label, icon: icon),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Tanggal: ${DateFormat('dd MMM yyyy').format(_selectedDate)}',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.calendar_month_rounded),
          label: const Text('Pilih'),
          onPressed: () => _selectDate(context),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF1E88E5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(TransactionProvider provider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E88E5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: _isSubmitting
            ? null
            : () async {
                if (_formKey.currentState!.validate()) {
                  setState(() => _isSubmitting = true);

                  await Future.delayed(const Duration(milliseconds: 800)); // Simulasi loading

                  provider.addTransaction(
                    Transaction(
                      id: DateTime.now().toString(),
                      title: _titleController.text,
                      amount: double.parse(_amountController.text),
                      date: _selectedDate,
                      category: _selectedCategory,
                      type: _selectedType,
                      note: _noteController.text,
                    ),
                  );

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Transaksi berhasil disimpan!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  }
                }
              },
        icon: _isSubmitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : const Icon(Icons.check_circle_rounded, color: Colors.white),
        label: Text(
          _isSubmitting ? 'Menyimpan...' : 'Simpan Transaksi',
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Color iconColor = const Color(0xFF1E88E5),
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: iconColor),
      filled: true,
      fillColor: const Color(0xFFF0F4FA),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}
