import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order.dart';
import '../services/firebase_service.dart';
import '../widgets/receipt_widget.dart';
import '../utils/currency_formatter.dart';
import 'new_order_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order> _orders = [];
  bool _isLoading = true;
  OrderStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Pesanan'),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToNewOrder(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStatusFilter(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _orders.isEmpty
                    ? const Center(child: Text('Tidak ada pesanan'))
                    : ListView.builder(
                        itemCount: _orders.length,
                        itemBuilder: (context, index) {
                          final order = _orders[index];
                          // 🔥 kirim index ke card
                          return _buildOrderCard(order, index + 1);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildStatusChip('Semua', null),
            const SizedBox(width: 8),
            ...OrderStatus.values.map(
              (status) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildStatusChip(status.displayName, status),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, OrderStatus? status) {
    final isSelected = _selectedStatus == status;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedStatus = selected ? status : null);
        _loadOrders();
      },
    );
  }

  // 🔥 sekarang terima nomor urut (orderNumber)
  Widget _buildOrderCard(Order order, int orderNumber) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(order.status),
          child: Text(
            orderNumber.toString(), // tampilkan nomor urut
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        title: Text(order.customerName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(order.customerPhone),
            Text('Total: ${CurrencyFormatter.format(order.total)}'),
            Text('Status: ${order.status.displayName}'),
            Text('Waktu: ${DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt)}'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleOrderAction(order, value),
          itemBuilder: (context) => [
            if (order.paymentStatus == PaymentStatus.pending)
              const PopupMenuItem(
                value: 'confirm_payment',
                child: Row(
                  children: [
                    Icon(Icons.payment, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Konfirmasi Bayar'),
                  ],
                ),
              ),
            if (order.status == OrderStatus.pending)
              const PopupMenuItem(value: 'confirm', child: Text('Konfirmasi Pesanan')),
            if (order.status == OrderStatus.confirmed)
              const PopupMenuItem(value: 'prepare', child: Text('Mulai Proses')),
            if (order.status == OrderStatus.preparing)
              const PopupMenuItem(value: 'ready', child: Text('Siap')),
            if (order.status == OrderStatus.ready)
              const PopupMenuItem(value: 'complete', child: Text('Selesai')),
            if (order.status != OrderStatus.cancelled && order.status != OrderStatus.completed)
              const PopupMenuItem(value: 'cancel', child: Text('Batalkan')),
            const PopupMenuItem(value: 'receipt', child: Text('Cetak Struk')),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Detail Pesanan:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...order.items.map((item) => Padding(
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
                    Text(CurrencyFormatter.format(order.subtotal)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Pajak:'),
                    Text(CurrencyFormatter.format(order.tax)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(CurrencyFormatter.format(order.total),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Pembayaran:'),
                    Text(order.paymentMethod.displayName),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Status Bayar:'),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: order.paymentStatus == PaymentStatus.paid
                            ? Colors.green.shade100
                            : Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        order.paymentStatus.displayName,
                        style: TextStyle(
                          color: order.paymentStatus == PaymentStatus.paid
                              ? Colors.green.shade700
                              : Colors.orange.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                if (order.notes != null && order.notes!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('Catatan: ${order.notes}'),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _loadOrders() async {
    setState(() => _isLoading = true);
    try {
      final orders = await FirebaseService.getOrders(status: _selectedStatus);
      setState(() => _orders = orders);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _navigateToNewOrder() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewOrderScreen()),
    );
    if (result == true) {
      _loadOrders();
    }
  }

  void _handleOrderAction(Order order, String action) async {
    try {
      OrderStatus? newStatus;
      switch (action) {
        case 'confirm':
          newStatus = OrderStatus.confirmed;
          break;
        case 'prepare':
          newStatus = OrderStatus.preparing;
          break;
        case 'ready':
          newStatus = OrderStatus.ready;
          break;
        case 'complete':
          newStatus = OrderStatus.completed;
          break;
        case 'cancel':
          newStatus = OrderStatus.cancelled;
          break;
        case 'receipt':
          _printReceipt(order);
          return;
        case 'confirm_payment':
          await FirebaseService.updatePaymentStatus(order.id, PaymentStatus.paid);
          _loadOrders();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Pembayaran berhasil dikonfirmasi')),
            );
          }
          return;
      }

      if (newStatus != null) {
        await FirebaseService.updateOrderStatus(order.id, newStatus);
        _loadOrders();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Status pesanan berhasil diupdate')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _printReceipt(Order order) {
    showDialog(
      context: context,
      builder: (context) => ReceiptDialog(order: order),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.preparing:
        return Colors.purple;
      case OrderStatus.ready:
        return Colors.green;
      case OrderStatus.completed:
        return Colors.grey;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }
}
