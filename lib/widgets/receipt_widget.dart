import 'package:flutter/material.dart';
import '../models/order.dart';
import '../utils/currency_formatter.dart';

class ReceiptWidget extends StatelessWidget {
  final Order order;

  const ReceiptWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          const Text(
            'DAPUR BUNDA BAHAGIA',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const Text(
            'Jl. Rawageni, Depok. Jawa Barat',
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const Text(
            'Telp: 089506333811',
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          // Divider
          Container(
            height: 1,
            color: Colors.grey.shade400,
            margin: const EdgeInsets.symmetric(vertical: 8),
          ),
          
          // Order Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('No. Pesanan:', style: TextStyle(fontSize: 12)),
              Text('#${order.id.substring(0, 8)}', style: const TextStyle(fontSize: 12)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tanggal:', style: TextStyle(fontSize: 12)),
              Text(DateFormatter.formatDateTime(order.createdAt), style: const TextStyle(fontSize: 12)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Pelanggan:', style: TextStyle(fontSize: 12)),
              Text(order.customerName, style: const TextStyle(fontSize: 12)),
            ],
          ),
          if (order.customerPhone.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Telepon:', style: TextStyle(fontSize: 12)),
                Text(order.customerPhone, style: const TextStyle(fontSize: 12)),
              ],
            ),
          
          const SizedBox(height: 16),
          
          // Items
          Container(
            height: 1,
            color: Colors.grey.shade400,
            margin: const EdgeInsets.symmetric(vertical: 8),
          ),
          
          ...order.items.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.productName,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Text(
                      CurrencyFormatter.format(item.productPrice),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '  ${item.quantity} x ${CurrencyFormatter.format(item.productPrice)}',
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                    ),
                    Text(
                      CurrencyFormatter.format(item.subtotal),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          )),
          
          // Totals
          Container(
            height: 1,
            color: Colors.grey.shade400,
            margin: const EdgeInsets.symmetric(vertical: 8),
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal:', style: TextStyle(fontSize: 12)),
              Text(CurrencyFormatter.format(order.subtotal), style: const TextStyle(fontSize: 12)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Pajak (10%):', style: TextStyle(fontSize: 12)),
              Text(CurrencyFormatter.format(order.tax), style: const TextStyle(fontSize: 12)),
            ],
          ),
          Container(
            height: 1,
            color: Colors.grey.shade400,
            margin: const EdgeInsets.symmetric(vertical: 4),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('TOTAL:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Text(
                CurrencyFormatter.format(order.total),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Payment Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Pembayaran:', style: TextStyle(fontSize: 12)),
              Text(order.paymentMethod.displayName, style: const TextStyle(fontSize: 12)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Status:', style: TextStyle(fontSize: 12)),
              Text(order.paymentStatus.displayName, style: const TextStyle(fontSize: 12)),
            ],
          ),
          
          if (order.notes != null && order.notes!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              height: 1,
              color: Colors.grey.shade400,
              margin: const EdgeInsets.symmetric(vertical: 4),
            ),
            const Text('Catatan:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            Text(
              order.notes!,
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ],
          
          const SizedBox(height: 16),
          
          // Footer
          Container(
            height: 1,
            color: Colors.grey.shade400,
            margin: const EdgeInsets.symmetric(vertical: 8),
          ),
          
          const Text(
            'Terima kasih atas kunjungan Anda!',
            style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
          const Text(
            'Selamat menikmati makanan Anda',
            style: TextStyle(fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ReceiptDialog extends StatelessWidget {
  final Order order;

  const ReceiptDialog({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: const Text('Struk Pembayaran'),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ReceiptWidget(order: order),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.print),
                      label: const Text('Cetak'),
                      onPressed: () {
                        // TODO: Implement printing
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fitur cetak akan segera tersedia')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.share),
                      label: const Text('Bagikan'),
                      onPressed: () {
                        // TODO: Implement sharing
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fitur bagikan akan segera tersedia')),
                        );
                      },
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
}
