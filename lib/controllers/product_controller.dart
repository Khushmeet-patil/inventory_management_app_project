import 'package:get/get.dart';
import '../models/product_model.dart';
import '../models/history_model.dart';
import '../services/database_services.dart';

class ProductController extends GetxController {
  final DatabaseService _dbService = DatabaseService.instance;

  final RxList<Product> products = <Product>[].obs;
  final RxList<ProductHistory> rentalHistory = <ProductHistory>[].obs;
  final RxList<ProductHistory> returnHistory = <ProductHistory>[].obs;
  final RxList<ProductHistory> addedProductHistory = <ProductHistory>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    products.value = await _dbService.getAllProducts();
    rentalHistory.value = await _dbService.getHistoryByType(HistoryType.rental);
    returnHistory.value = await _dbService.getHistoryByType(HistoryType.return_product);
    addedProductHistory.value = await _dbService.getHistoryByType(HistoryType.added_stock);
  }

  Future<Product?> getProductByBarcode(String barcode) async {
    return await _dbService.getProductByBarcode(barcode);
  }

  Future<void> addNewProduct(Product product) async {
    final addedProduct = await _dbService.addProduct(product);
    await _dbService.addHistory(ProductHistory(
      id: 0,
      productId: addedProduct.id,
      productName: product.name,
      barcode: product.barcode,
      quantity: product.quantity,
      type: HistoryType.added_stock,
      rentedDate: DateTime.now(),
      createdAt: DateTime.now(),
    ));
    await loadData();
  }

  Future<void> addExistingStock(String barcode, int quantity) async {
    final product = await getProductByBarcode(barcode);
    if (product != null) {
      final updatedProduct = product.copyWith(
        quantity: product.quantity + quantity,
        updatedAt: DateTime.now(),
      );
      await _dbService.updateProduct(updatedProduct);
      await _dbService.addHistory(ProductHistory(
        id: 0,
        productId: product.id,
        productName: product.name,
        barcode: product.barcode,
        quantity: quantity,
        type: HistoryType.added_stock,
        rentedDate: DateTime.now(),
        createdAt: DateTime.now(),
      ));
      await loadData();
    } else {
      Get.snackbar('Error', 'Product not found');
    }
  }

  Future<void> rentProduct(String barcode, int quantity, String givenTo, int rentalDays, {String? agency}) async {
    final product = await getProductByBarcode(barcode);
    if (product != null && product.quantity >= quantity) {
      final updatedProduct = product.copyWith(
        quantity: product.quantity - quantity,
        updatedAt: DateTime.now(),
      );
      await _dbService.updateProduct(updatedProduct);
      await _dbService.addHistory(ProductHistory(
        id: 0,
        productId: product.id,
        productName: product.name,
        barcode: product.barcode,
        quantity: quantity,
        type: HistoryType.rental,
        givenTo: givenTo,
        agency: agency,
        rentedDate: DateTime.now(),
        rentalDays: rentalDays,
        createdAt: DateTime.now(),
      ));
      await loadData();
    } else {
      Get.snackbar('Error', product == null ? 'Product not found' : 'Insufficient stock');
    }
  }

  Future<void> returnProduct(String barcode, int quantity, String returnedBy, {String? agency, String? notes}) async {
    final product = await getProductByBarcode(barcode);
    if (product != null) {
      final updatedProduct = product.copyWith(
        quantity: product.quantity + quantity,
        updatedAt: DateTime.now(),
      );
      await _dbService.updateProduct(updatedProduct);
      await _dbService.addHistory(ProductHistory(
        id: 0,
        productId: product.id,
        productName: product.name,
        barcode: product.barcode,
        quantity: quantity,
        type: HistoryType.return_product,
        givenTo: returnedBy,
        agency: agency,
        returnDate: DateTime.now(),
        notes: notes,
        createdAt: DateTime.now(),
        rentedDate: DateTime.now(),
      ));
      await loadData();
    } else {
      Get.snackbar('Error', 'Product not found');
    }
  }
}