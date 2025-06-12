import "package:flutter/material.dart";

class SafeWidget extends StatelessWidget {
  final Widget child;
  final Widget fallback;

  const SafeWidget({
    super.key,
    required this.child,
    this.fallback = const Center(child: Text("Something Went Wrong")),
  });

  @override
  Widget build(BuildContext context) {
    try {
      return child;
    } catch (e) {
      debugPrint("Safe Widget error $e");
      return fallback;
    }
  }
}
