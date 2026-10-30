import 'package:flutter/material.dart';
import '../widgets/product_card.dart';

class ProductGridScreen extends StatelessWidget {
  const ProductGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dữ liệu giả cho 10 sản phẩm
    final products = List.generate(
      10,
      (index) => {
        'title': 'Product #$index',
        'price': 10.0 + index,
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 cột
            childAspectRatio: 0.75, // tỉ lệ ngang/dọc của mỗi item
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              title: product['title'] as String,
              price: product['price'] as double,
            );
          },
        ),
      ),
    );
  }
}
