import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SingleCartProdCardShimmer extends StatelessWidget {
  const SingleCartProdCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            // Image placeholder
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            // Product name & price
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 18,
                    width: 120,
                    color: Colors.grey,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                  Container(
                    height: 14,
                    width: 80,
                    color: Colors.grey,
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                  ),
                ],
              ),
            ),
            // Quantity button shimmer
            Column(
              children: [
                Container(
                  height: 26,
                  width: 26,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 20,
                  width: 30,
                  color: Colors.grey,
                ),
                const SizedBox(height: 4),
                Container(
                  height: 26,
                  width: 26,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
