import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../models/product.dart';
import '../models/order.dart' as app_order;
import '../models/user.dart';
import '../models/sales_report.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  // Collections
  static const String _productsCollection = 'products';
  static const String _ordersCollection = 'orders';
  static const String _usersCollection = 'users';
  static const String _reportsCollection = 'reports';

  // Authentication
  static Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final userDoc = await _firestore
            .collection(_usersCollection)
            .doc(credential.user!.uid)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data()!;
          userData['id'] = credential.user!.uid;
          return User.fromMap(userData);
        }
      }
      return null;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  static Future<User?> signInTestUser(UserRole role) async {
    try {
      String email = role == UserRole.admin ? 'admin@test.com' : 'user@test.com';
      String password = 'test123';

      return await signInWithEmailAndPassword(email, password);
    } catch (e) {
      throw Exception('Test login failed: $e');
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static User? getCurrentUser() {
    return _auth.currentUser != null ? null : null; // Will be implemented with user data
  }

  static Future<User?> getCurrentUserData() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      try {
        final userDoc = await _firestore
            .collection(_usersCollection)
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data()!;
          userData['id'] = currentUser.uid;
          return User.fromMap(userData);
        }
      } catch (e) {
        print('Error getting current user data: $e');
      }
    }
    return null;
  }

  // Products CRUD
  static Future<List<Product>> getProducts() async {
    try {
      final querySnapshot = await _firestore
          .collection(_productsCollection)
          .orderBy('name')
          .get();
      
      return querySnapshot.docs
          .map((doc) => Product.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to get products: $e');
    }
  }

  static Future<List<Product>> getProductsByCategory(ProductCategory category) async {
    try {
      final querySnapshot = await _firestore
          .collection(_productsCollection)
          .where('category', isEqualTo: category.toString().split('.').last)
          .where('isAvailable', isEqualTo: true)
          .orderBy('name')
          .get();
      
      return querySnapshot.docs
          .map((doc) => Product.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to get products by category: $e');
    }
  }

  static Future<Product?> getProduct(String id) async {
    try {
      final doc = await _firestore.collection(_productsCollection).doc(id).get();
      if (doc.exists) {
        return Product.fromMap({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get product: $e');
    }
  }

  static Future<String> addProduct(Product product) async {
    try {
      final docRef = await _firestore.collection(_productsCollection).add(product.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  static Future<void> updateProduct(Product product) async {
    try {
      await _firestore
          .collection(_productsCollection)
          .doc(product.id)
          .update(product.toMap());
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  static Future<void> deleteProduct(String id) async {
    try {
      await _firestore.collection(_productsCollection).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  static Future<void> updateProductStock(String productId, int newStock) async {
    try {
      await _firestore
          .collection(_productsCollection)
          .doc(productId)
          .update({
        'stock': newStock,
        'updatedAt': DateTime.now().toIso8601String(),
        'isAvailable': newStock > 0,
      });
    } catch (e) {
      throw Exception('Failed to update product stock: $e');
    }
  }

  // Orders CRUD
  static Future<List<app_order.Order>> getOrders({app_order.OrderStatus? status, int? limit}) async {
    try {
      Query query = _firestore
          .collection(_ordersCollection)
          .orderBy('createdAt', descending: true);
      
      if (status != null) {
        query = query.where('status', isEqualTo: status.toString().split('.').last);
      }
      
      if (limit != null) {
        query = query.limit(limit);
      }
      
      final querySnapshot = await query.get();
      
      return querySnapshot.docs
          .map((doc) => app_order.Order.fromMap({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to get orders: $e');
    }
  }

  static Future<app_order.Order?> getOrder(String id) async {
    try {
      final doc = await _firestore.collection(_ordersCollection).doc(id).get();
      if (doc.exists) {
        return app_order.Order.fromMap({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get order: $e');
    }
  }

  static Future<List<app_order.Order>> getUserOrders(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_ordersCollection)
          .where('customerId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => app_order.Order.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user orders: $e');
    }
  }

  static Future<String> addOrder(app_order.Order order) async {
    try {
      // Start a batch write to update stock and add order
      final batch = _firestore.batch();
      
      // Add the order
      final orderRef = _firestore.collection(_ordersCollection).doc();
      batch.set(orderRef, order.toMap());
      
      // Update product stocks
      for (final item in order.items) {
        final productRef = _firestore.collection(_productsCollection).doc(item.productId);
        final productDoc = await productRef.get();
        
        if (productDoc.exists) {
          final currentStock = productDoc.data()!['stock'] as int;
          final newStock = currentStock - item.quantity;
          
          batch.update(productRef, {
            'stock': newStock,
            'updatedAt': DateTime.now().toIso8601String(),
            'isAvailable': newStock > 0,
          });
        }
      }
      
      await batch.commit();
      return orderRef.id;
    } catch (e) {
      throw Exception('Failed to add order: $e');
    }
  }

  static Future<void> updateOrder(app_order.Order order) async {
    try {
      await _firestore
          .collection(_ordersCollection)
          .doc(order.id)
          .update(order.toMap());
    } catch (e) {
      throw Exception('Failed to update order: $e');
    }
  }

  static Future<void> updateOrderStatus(String orderId, app_order.OrderStatus status) async {
    try {
      await _firestore
          .collection(_ordersCollection)
          .doc(orderId)
          .update({
        'status': status.toString().split('.').last,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  static Future<void> updatePaymentStatus(String orderId, app_order.PaymentStatus paymentStatus) async {
    try {
      await _firestore
          .collection(_ordersCollection)
          .doc(orderId)
          .update({
        'paymentStatus': paymentStatus.toString().split('.').last,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to update payment status: $e');
    }
  }

  // Reports
  static Future<List<app_order.Order>> getOrdersByDateRange(DateTime startDate, DateTime endDate) async {
    try {
      final querySnapshot = await _firestore
          .collection(_ordersCollection)
          .where('createdAt', isGreaterThanOrEqualTo: startDate.toIso8601String())
          .where('createdAt', isLessThanOrEqualTo: endDate.toIso8601String())
          .where('status', isEqualTo: 'completed')
          .orderBy('createdAt')
          .get();
      
      return querySnapshot.docs
          .map((doc) => app_order.Order.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to get orders by date range: $e');
    }
  }

  static Future<SalesReport> generateSalesReport(DateTime startDate, DateTime endDate, ReportPeriod period) async {
    try {
      final orders = await getOrdersByDateRange(startDate, endDate);
      
      // Calculate totals
      int totalOrders = orders.length;
      double totalRevenue = orders.fold(0, (sum, order) => sum + order.total);
      double totalTax = orders.fold(0, (sum, order) => sum + order.tax);
      
      // Calculate product sales
      Map<String, int> productSales = {};
      for (final order in orders) {
        for (final item in order.items) {
          productSales[item.productId] = (productSales[item.productId] ?? 0) + item.quantity;
        }
      }
      
      // Calculate category revenue
      Map<String, double> categoryRevenue = {};
      for (final order in orders) {
        for (final item in order.items) {
          final product = await getProduct(item.productId);
          if (product != null) {
            final categoryName = product.category.toString().split('.').last;
            categoryRevenue[categoryName] = (categoryRevenue[categoryName] ?? 0) + item.subtotal;
          }
        }
      }
      
      // Calculate payment method count
      Map<String, int> paymentMethodCount = {};
      for (final order in orders) {
        final method = order.paymentMethod.toString().split('.').last;
        paymentMethodCount[method] = (paymentMethodCount[method] ?? 0) + 1;
      }
      
      // Calculate daily sales
      Map<String, DailySales> dailySalesMap = {};
      for (final order in orders) {
        final dateKey = order.createdAt.toIso8601String().split('T')[0];
        if (dailySalesMap.containsKey(dateKey)) {
          final existing = dailySalesMap[dateKey]!;
          dailySalesMap[dateKey] = DailySales(
            date: existing.date,
            orders: existing.orders + 1,
            revenue: existing.revenue + order.total,
            tax: existing.tax + order.tax,
          );
        } else {
          dailySalesMap[dateKey] = DailySales(
            date: order.createdAt,
            orders: 1,
            revenue: order.total,
            tax: order.tax,
          );
        }
      }
      
      final report = SalesReport(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        startDate: startDate,
        endDate: endDate,
        period: period,
        totalOrders: totalOrders,
        totalRevenue: totalRevenue,
        totalTax: totalTax,
        productSales: productSales,
        categoryRevenue: categoryRevenue,
        paymentMethodCount: paymentMethodCount,
        dailySales: dailySalesMap.values.toList(),
        generatedAt: DateTime.now(),
      );
      
      // Save report to Firestore
      await _firestore.collection(_reportsCollection).doc(report.id).set(report.toMap());
      
      return report;
    } catch (e) {
      throw Exception('Failed to generate sales report: $e');
    }
  }

  static Future<ReportSummary> getReportSummary() async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final weekStart = today.subtract(Duration(days: now.weekday - 1));
      final monthStart = DateTime(now.year, now.month, 1);
      
      // Get today's orders
      final todayOrders = await getOrdersByDateRange(today, today.add(Duration(days: 1)));
      final weekOrders = await getOrdersByDateRange(weekStart, now);
      final monthOrders = await getOrdersByDateRange(monthStart, now);
      
      // Calculate revenues
      double todayRevenue = todayOrders.fold(0, (sum, order) => sum + order.total);
      double weekRevenue = weekOrders.fold(0, (sum, order) => sum + order.total);
      double monthRevenue = monthOrders.fold(0, (sum, order) => sum + order.total);
      
      // Get top products
      Map<String, int> productCount = {};
      for (final order in monthOrders) {
        for (final item in order.items) {
          productCount[item.productName] = (productCount[item.productName] ?? 0) + item.quantity;
        }
      }
      
      List<MapEntry<String, int>> topProductEntries = productCount.entries
          .toList()
          ..sort((a, b) => b.value.compareTo(a.value));

      List<String> topProducts = topProductEntries
          .take(5)
          .map((e) => e.key)
          .toList();
      
      // Category performance
      Map<String, double> categoryPerformance = {};
      for (final order in monthOrders) {
        for (final item in order.items) {
          final product = await getProduct(item.productId);
          if (product != null) {
            final categoryName = product.category.displayName;
            categoryPerformance[categoryName] = (categoryPerformance[categoryName] ?? 0) + item.subtotal;
          }
        }
      }
      
      return ReportSummary(
        todayRevenue: todayRevenue,
        weekRevenue: weekRevenue,
        monthRevenue: monthRevenue,
        todayOrders: todayOrders.length,
        weekOrders: weekOrders.length,
        monthOrders: monthOrders.length,
        topProducts: topProducts,
        categoryPerformance: categoryPerformance,
      );
    } catch (e) {
      throw Exception('Failed to get report summary: $e');
    }
  }

  // Initialize default data
  static Future<void> initializeDefaultData() async {
    try {
      // Check if products already exist
      final productsSnapshot = await _firestore.collection(_productsCollection).limit(1).get();
      if (productsSnapshot.docs.isNotEmpty) {
        return; // Data already exists
      }
      
      // Add sample products
      final sampleProducts = [
        Product(
          id: '',
          name: 'Nasi Gudeg',
          description: 'Nasi gudeg khas Yogyakarta dengan ayam dan telur',
          price: 25000,
          category: ProductCategory.makananUtama,
          stock: 50,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Product(
          id: '',
          name: 'Soto Ayam',
          description: 'Soto ayam dengan kuah bening dan rempah-rempah',
          price: 20000,
          category: ProductCategory.makananUtama,
          stock: 30,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Product(
          id: '',
          name: 'Gado-gado',
          description: 'Salad sayuran dengan bumbu kacang',
          price: 15000,
          category: ProductCategory.appetizer,
          stock: 25,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Product(
          id: '',
          name: 'Es Teh Manis',
          description: 'Teh manis dingin segar',
          price: 5000,
          category: ProductCategory.minuman,
          stock: 100,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Product(
          id: '',
          name: 'Jus Jeruk',
          description: 'Jus jeruk segar tanpa gula tambahan',
          price: 8000,
          category: ProductCategory.minuman,
          stock: 50,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
      
      for (final product in sampleProducts) {
        await addProduct(product);
      }
      
      print('Default data initialized successfully');
    } catch (e) {
      print('Failed to initialize default data: $e');
    }
  }

  static Future<void> initializeDefaultUsers() async {
    try {
      // Check if users already exist
      final usersSnapshot = await _firestore.collection(_usersCollection).get();
      if (usersSnapshot.docs.isNotEmpty) {
        print('Default users already exist');
        return;
      }

      // Create admin user
      try {
        final adminCredential = await _auth.createUserWithEmailAndPassword(
          email: 'admin@test.com',
          password: 'test123',
        );

        if (adminCredential.user != null) {
          final adminUser = User(
            id: adminCredential.user!.uid,
            email: 'admin@test.com',
            name: 'Admin Test',
            role: UserRole.admin,
            isActive: true,
            createdAt: DateTime.now(),
            lastLogin: DateTime.now(),
          );

          await _firestore
              .collection(_usersCollection)
              .doc(adminCredential.user!.uid)
              .set(adminUser.toMap());

          print('Admin user created successfully');
        }
      } catch (e) {
        print('Admin user might already exist: $e');
      }

      // Create regular user
      try {
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: 'user@test.com',
          password: 'test123',
        );

        if (userCredential.user != null) {
          final regularUser = User(
            id: userCredential.user!.uid,
            email: 'user@test.com',
            name: 'User Test',
            role: UserRole.user,
            isActive: true,
            createdAt: DateTime.now(),
            lastLogin: DateTime.now(),
          );

          await _firestore
              .collection(_usersCollection)
              .doc(userCredential.user!.uid)
              .set(regularUser.toMap());

          print('Regular user created successfully');
        }
      } catch (e) {
        print('Regular user might already exist: $e');
      }

      // Sign out after creating users
      await _auth.signOut();

    } catch (e) {
      print('Error initializing default users: $e');
    }
  }
}
