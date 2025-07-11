import 'package:flutter/material.dart';
import 'package:omegbazaar/utills/app_colour.dart';

class PriceSlider extends StatelessWidget {
  final RangeValues currentRange;
  final Function(RangeValues) onRangeChanged;

  const PriceSlider({
    super.key,
    required this.currentRange,
    required this.onRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          RangeSlider(
            values: currentRange,
            activeColor: AppColour.primaryColor,
            min: 0,
            max: 10000,
            divisions: 100,
            labels: RangeLabels(
              '₹${currentRange.start.round()}',
              '₹${currentRange.end.round()}',
            ),
            onChanged: onRangeChanged,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('₹${currentRange.start.round()}'),
              Text('₹${currentRange.end.round()}'),
            ],
          ),
        ],
      ),
    );
  }
}
