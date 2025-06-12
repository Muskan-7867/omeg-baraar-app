import 'package:flutter/material.dart';
import 'package:omeg_bazaar/screens/home/widgets/bottom_sheet.dart';
import 'package:omeg_bazaar/services/cart_data_load.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';

class CheckoutBtn extends StatefulWidget {
  const CheckoutBtn({super.key});

  @override
  State<CheckoutBtn> createState() => _CheckoutBtnState();
}

class _CheckoutBtnState extends State<CheckoutBtn> {
   List<Map<String, dynamic>> cartProducts = [];
  List<int> quantities = [];

  @override
  void initState() {
    super.initState();
    loadCartData();
  }

  Future<void> loadCartData() async {
    try {
      final (products, loadedQuantities) = await CartDataLoader.load();

      setState(() {
        cartProducts = List<Map<String, dynamic>>.from(products);
        quantities = List<int>.from(loadedQuantities);
      });
    } catch (e) {
      // Handle error
    }
  }

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
                  child: Text(
                    "checkout",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
  }
}