import 'package:flutter/material.dart';

class LegendSymbol extends StatelessWidget {
  const LegendSymbol({
    super.key,
    required this.legendLabel,
    required this.legendColor,
    this.colorBoxSize = 8.0,
    this.spacing = 4.0,
  });

  final Color legendColor;
  final String legendLabel;
  final double colorBoxSize;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: colorBoxSize,
          width: colorBoxSize,
          color: legendColor,
        ),
        SizedBox(width: spacing),
        Text(legendLabel)
      ],
    );
  }
}
