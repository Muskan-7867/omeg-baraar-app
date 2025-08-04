import 'package:flutter/material.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrderTimeLine extends StatelessWidget {
  final String status;

  const OrderTimeLine({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final currentStatus = status.toLowerCase();
    final isCancelled = currentStatus == 'cancelled';

    return ListView(
      children: [
        buildTile(
          isFirst: true,
          isLast: false,
          isDone: true, // Order placed is always done
          isCancelled: isCancelled,
          title: "Order Placed",
          subtitle: "Your order has been placed",
          icon: Icons.check_circle,
        ),
        buildTile(
          isFirst: false,
          isLast: false,
          isDone: currentStatus != 'pending',
          isCancelled: isCancelled,
          title: isCancelled ? 'Cancelled' : 'In Progress',
          subtitle:
              isCancelled
                  ? 'Your order has been cancelled'
                  : (currentStatus != 'pending'
                      ? 'Your order is being processed'
                      : 'Waiting to process your order'),
          icon: isCancelled ? Icons.cancel : Icons.inventory,
        ),
        if (!isCancelled) ...[
          buildTile(
            isFirst: false,
            isLast: false,
            isDone: currentStatus == 'shipped' || currentStatus == 'delivered',
            isCancelled: false,
            title: 'Shipped',
            subtitle:
                (currentStatus == 'shipped' || currentStatus == 'delivered')
                    ? 'Your order has been shipped'
                    : 'Not yet shipped',
            icon: Icons.local_shipping,
          ),
          buildTile(
            isFirst: false,
            isLast: true,
            isDone: currentStatus == 'delivered',
            isCancelled: false,
            title: 'Delivered',
            subtitle:
                currentStatus == 'delivered'
                    ? 'Your order has been delivered'
                    : 'Not yet delivered',
            icon: Icons.inventory_2,
          ),
        ],
      ],
    );
  }

  TimelineTile buildTile({
    required bool isFirst,
    required bool isLast,
    required bool isDone,
    required bool isCancelled,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final indicatorColor =
        isCancelled
            ? Colors.red
            : (isDone ? AppColour.primaryColor : Colors.grey.shade400);

    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 20,
        color: indicatorColor,
        iconStyle: IconStyle(
          iconData:
              isCancelled
                  ? Icons.cancel
                  : (isDone ? Icons.check : Icons.radio_button_unchecked),
          color: Colors.white,
        ),
      ),
      beforeLineStyle: LineStyle(
        color:
            isCancelled
                ? Colors.red
                : (isDone ? AppColour.primaryColor : Colors.grey.shade300),
        thickness: 2,
      ),
      afterLineStyle:
          isLast
              ? null
              : LineStyle(
                color:
                    isCancelled
                        ? Colors.red
                        : (isDone
                            ? AppColour.primaryColor
                            : Colors.grey.shade300),
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
                      color:
                          isCancelled
                              ? Colors.red
                              : (isDone ? Colors.black : Colors.grey.shade600),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color:
                          isCancelled
                              ? Colors.red.shade700
                              : (isDone
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade500),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              icon,
              color:
                  isCancelled
                      ? Colors.red
                      : (isDone
                          ? AppColour.primaryColor
                          : Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }
}
