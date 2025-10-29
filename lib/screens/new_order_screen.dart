import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../services/firebase_service.dart';
import '../utils/currency_formatter.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({super.key});

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _notesController = TextEditingController();
  
  List<Product> _products = [];
  List<OrderItem> _orderItems = [];
  final PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesanan Baru'),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _orderItems.isNotEmpty ? _saveOrder : null,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildCustomerInfo(),
                _buildProductList(),
                _buildOrderSummary(),
              ],
            ),
    );
  }

  Widget _buildCustomerInfo() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Informasi Pelanggan', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _customerNameController,
              decoration: const InputDecoration(
                labelText: 'Nama Pelanggan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _customerPhoneController,
              decoration: const InputDecoration(
                labelText: 'No. Telepon',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.payments, color: Colors.green),
                  const SizedBox(width: 12),
                  const Text(
                    'Metode Pembayaran: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Tunai 💵',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return Expanded(
      flex: 2,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Pilih Produk', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return _buildProductTile(product);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductTile(Product product) {
    final existingItem = _orderItems.firstWhere(
      (item) => item.productId == product.id,
      orElse: () => OrderItem(
        productId: '',
        productName: '',
        productPrice: 0,
        quantity: 0,
        subtotal: 0,
      ),
    );
    final quantity = existingItem.productId.isNotEmpty ? existingItem.quantity : 0;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getCategoryColor(product.category),
        child: Text(
          product.category.emoji,
          style: const TextStyle(fontSize: 16),
        ),
      ),
      title: Text(product.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(CurrencyFormatter.format(product.price)),
          Text('Stok: ${product.stock}'),
        ],
      ),
      trailing: product.stock > 0
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: quantity > 0 ? () => _updateQuantity(product, quantity - 1) : null,
                ),
                Text('$quantity'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: quantity < product.stock ? () => _updateQuantity(product, quantity + 1) : null,
                ),
              ],
            )
          : const Text('Habis', style: TextStyle(color: Colors.red)),
    );
  }

  Widget _buildOrderSummary() {
    final subtotal = _orderItems.fold<double>(0, (sum, item) => sum + item.subtotal);
    final tax = subtotal * 0.1; // 10% tax
    final total = subtotal + tax;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ringkasan Pesanan', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (_orderItems.isNotEmpty) ...[
              ..._orderItems.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('${item.productName} x${item.quantity}')),
                    Text(CurrencyFormatter.format(item.subtotal)),
                  ],
                ),
              )),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Subtotal:'),
                  Text(CurrencyFormatter.format(subtotal)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Pajak (10%):'),
                  Text(CurrencyFormatter.format(tax)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(CurrencyFormatter.format(total), style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Catatan (opsional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveOrder,
                  child: _isSaving
                      ? const CircularProgressIndicator()
                      : const Text('Simpan Pesanan'),
                ),
              ),
            ] else
              const Text('Belum ada item dipilih'),
          ],
        ),
      ),
    );
  }

  void _loadProducts() async {
    try {
      final products = await FirebaseService.getProducts();
      setState(() {
        _products = products.where((p) => p.isAvailable && p.stock > 0).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _updateQuantity(Product product, int quantity) {
    setState(() {
      if (quantity == 0) {
        _orderItems.removeWhere((item) => item.productId == product.id);
      } else {
        final existingIndex = _orderItems.indexWhere((item) => item.productId == product.id);
        final newItem = OrderItem.fromProduct(product, quantity);
        
        if (existingIndex >= 0) {
          _orderItems[existingIndex] = newItem;
        } else {
          _orderItems.add(newItem);
        }
      }
    });
  }

  void _saveOrder() async {
    if (_customerNameController.text.isEmpty || _orderItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon isi nama pelanggan dan pilih minimal 1 produk')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final subtotal = _orderItems.fold<double>(0, (sum, item) => sum + item.subtotal);
      final tax = subtotal * 0.1;
      final total = subtotal + tax;

      final order = Order(
        id: const Uuid().v4(),
        customerId: 'admin', // Admin creates order for walk-in customers
        customerName: _customerNameController.text,
        customerPhone: _customerPhoneController.text,
        items: _orderItems,
        subtotal: subtotal,
        tax: tax,
        total: total,
        status: OrderStatus.pending,
        paymentMethod: _selectedPaymentMethod,
        paymentStatus: PaymentStatus.pending,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      await FirebaseService.addOrder(order);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pesanan berhasil disimpan')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Color _getCategoryColor(ProductCategory category) {
    switch (category) {
      case ProductCategory.makananUtama:
        return Colors.red;
      case ProductCategory.appetizer:
        return Colors.orange;
      case ProductCategory.minuman:
        return Colors.blue;
    }
  }
}
