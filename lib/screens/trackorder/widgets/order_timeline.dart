import 'package:flutter/material.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrderTimeLine extends StatelessWidget {
  const OrderTimeLine({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        //buildtile is a method taht builds the timeline tile (steps) Each Tile	Shows: status icon, title, subtitle, colored line
        buildTile(
          isFirst: true,
          isLast: false,
          isDone: true,
          title: "Order Placed",
          subtitle: "12:00 AM",
          icon: Icons.check_circle,
        ),
        buildTile(
          isFirst: false,
          isLast: false,
          isDone: true,
          title: 'In Progress',
          subtitle: '23 Aug 2023, 03:54 PM',
          icon: Icons.inventory,
        ),
        buildTile(
          isFirst: false,
          isLast: false,
          isDone: false,
          title: 'Shipped',
          subtitle: 'Expected 02 Sep 2023',
          icon: Icons.local_shipping,
        ),
        buildTile(
          isFirst: false,
          isLast: true,
          isDone: false,
          title: 'Delivered',
          subtitle: 'Not yet delivered',
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
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
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
