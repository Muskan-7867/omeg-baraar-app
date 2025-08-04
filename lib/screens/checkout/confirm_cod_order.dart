import 'package:flutter/material.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ConfirmCODScreen extends StatelessWidget {
  final List<dynamic> cartProducts;
  final List<int> quantities;
  final Map<String, dynamic> address;
  final double totalAmount;
  final VoidCallback onConfirm;
  final bool isBuyNow;

  const ConfirmCODScreen({
    super.key,
    required this.cartProducts,
    required this.quantities,
    required this.address,
    required this.totalAmount,
    required this.onConfirm,
    this.isBuyNow = false,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('Cart Products: ${cartProducts.toString()}');
    debugPrint('Quantities: ${quantities.toString()}');
    debugPrint('Address: ${address.toString()}');
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm COD Order')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Product List with Images
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cartProducts.length,
                itemBuilder: (context, index) {
                  final product = cartProducts[index];
                  final quantity = quantities[index];
                  final price = (product['price'] ?? 0.0) * quantity;
                  final imageUrl =
                      (product['images']?.isNotEmpty == true &&
                              product['images'][0]['url'] != null)
                          ? product['images'][0]['url']
                          : 'https://via.placeholder.com/150';

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl, // Use the extracted URL
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => Container(
                                  width: 70,
                                  height: 70,
                                  color: Colors.grey.shade200,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                            errorWidget:
                                (context, url, error) => Container(
                                  width: 70,
                                  height: 70,
                                  color: Colors.grey.shade200,
                                  child: const Icon(Icons.error),
                                ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Product Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'] ?? 'Product Name',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Quantity: $quantity',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '₹${price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColour.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Total Amount
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '₹$totalAmount',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColour.primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Shipping Address Section
            const Text(
              'Shipping Address',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${address['street'] ?? ''}, ${address['address'] ?? ''}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${address['city']}, ${address['state']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${address['pincode']}, ${address['country']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Phone: ${address['phone']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Payment Method Section
            const Text(
              'Payment Method',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Cash on Delivery (Pay when you receive your order)',
                style: TextStyle(fontSize: 16),
              ),
            ),

            const Spacer(),

            // Confirm Order Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColour.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  onPressed: onConfirm,
                  child: const Text(
                    'Confirm Order',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
