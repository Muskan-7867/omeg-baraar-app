import 'package:flutter/material.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrderTimeLine extends StatelessWidget {
  final String status;

  const OrderTimeLine({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    // Convert status to lowercase for case-insensitive comparison
    final currentStatus = status.toLowerCase();

    // Determine which steps are completed based on current status
    final isOrderPlacedDone = true; // Always true since order exists
    final isInProgressDone = currentStatus != 'pending';
    final isShippedDone =
        currentStatus == 'shipped' || currentStatus == 'delivered';
    final isDeliveredDone = currentStatus == 'delivered';

    return ListView(
      children: [
        buildTile(
          isFirst: true,
          isLast: false,
          isDone: isOrderPlacedDone,
          title: "Order Placed",
          subtitle: "Your order has been placed",
          icon: Icons.check_circle,
        ),
        buildTile(
          isFirst: false,
          isLast: false,
          isDone: isInProgressDone,
          title: 'In Progress',
          subtitle:
              isInProgressDone
                  ? 'Your order is being processed'
                  : 'Waiting to process your order',
          icon: Icons.inventory,
        ),
        buildTile(
          isFirst: false,
          isLast: false,
          isDone: isShippedDone,
          title: 'Shipped',
          subtitle:
              isShippedDone ? 'Your order has been shipped' : 'Not yet shipped',
          icon: Icons.local_shipping,
        ),
        buildTile(
          isFirst: false,
          isLast: true,
          isDone: isDeliveredDone,
          title: 'Delivered',
          subtitle:
              isDeliveredDone
                  ? 'Your order has been delivered'
                  : 'Not yet delivered',
          icon: Icons.inventory_2,
        ),
      ],
    );
  }

  TimelineTile buildTile({
    required bool isFirst,
    required bool isLast,
    required bool isDone,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 20,
        color: isDone ? AppColour.primaryColor : Colors.grey.shade400,
        iconStyle: IconStyle(
          iconData: isDone ? Icons.check : Icons.radio_button_unchecked,
          color: isDone ? Colors.white : Colors.grey.shade300,
        ),
      ),
      beforeLineStyle: LineStyle(
        color: isDone ? AppColour.primaryColor : Colors.grey.shade300,
        thickness: 2,
      ),
      endChild: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDone ? Colors.black : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color:
                          isDone ? Colors.grey.shade700 : Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              icon,
              color: isDone ? AppColour.primaryColor : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
