import 'package:flutter/material.dart';
import 'package:omegbazaar/screens/home/widgets/bottom_sheet.dart';
import 'package:omegbazaar/utills/app_colour.dart';

class CheckoutBtn extends StatelessWidget {
  final List<Map<String, dynamic>> cartProducts;
  final List<int> quantities;

  const CheckoutBtn({
    super.key,
    required this.cartProducts,
    required this.quantities,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColour.primaryColor,
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder:
                  (context) => BottomSheetCart(
                    cartProducts: cartProducts,
                    quantities: quantities,
                  ),
            );
          },
          child: const Text(
            "checkout",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
