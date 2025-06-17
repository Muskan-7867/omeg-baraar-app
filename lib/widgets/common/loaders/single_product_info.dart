import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductInfoShimmer extends StatelessWidget {
  const ProductInfoShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Name + Stock Badge
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Product name placeholder
                  Container(
                    width: 180,
                    height: 20,
                    color: Colors.white,
                  ),
                  // Stock badge placeholder
                  Container(
                    width: 70,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            /// Price Row
            Row(
              children: [
                Container(width: 80, height: 18, color: Colors.white),
                const SizedBox(width: 8),
                Container(width: 60, height: 14, color: Colors.white),
              ],
            ),

            const SizedBox(height: 12),

            /// Product Details Title
            Container(
              width: 150,
              height: 20,
              color: Colors.white,
            ),

            const SizedBox(height: 8),

            /// Description lines (simulate 3 lines)
            ...List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Container(
                  width: double.infinity,
                  height: 12,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
