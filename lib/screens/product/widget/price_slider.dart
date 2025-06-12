import 'package:flutter/material.dart';
import 'package:omeg_bazaar/utills/app_colour.dart';

class PriceSlider extends StatefulWidget {
  const PriceSlider({super.key});

  @override
  State<PriceSlider> createState() => _PriceSliderState();
}

class _PriceSliderState extends State<PriceSlider> {
  double start = 10.0;
  double end = 100000.00;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RangeSlider(
          activeColor: AppColour.primaryColor,
          values: RangeValues(start, end),
          onChanged: (value) {
            setState(() {
              start = value.start;
              end = value.end;
            });
          },

          min: 10.0,
          max: 100000.00,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                start.toStringAsFixed(2),

                style: const TextStyle(fontSize: 12),
              ),
              Text(
                end.toStringAsFixed(2),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
