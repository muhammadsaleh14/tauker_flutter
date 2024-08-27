import 'package:flutter/material.dart';

class SliderVerticalWidget extends StatefulWidget {
  final double defaultValue;
  final double min;
  final double max;
  final int divisions;
  final String label;
  final VoidCallback onChanged;

  const SliderVerticalWidget({
    required Key key,
    required this.defaultValue,
    required this.min,
    required this.max,
    required this.divisions,
    required this.label,
    required this.onChanged,
  }) : super(key: key);

  @override
  SliderVerticalWidgetState createState() => SliderVerticalWidgetState();
}

class SliderVerticalWidgetState extends State<SliderVerticalWidget> {
  late double value;

  @override
  void initState() {
    super.initState();
    value = widget.defaultValue;
  }

  void resetValue() {
    setState(() {
      value = widget.defaultValue;
      widget.onChanged();
    });
  }

  // double get getCurrentValue => value; // Getter for the slider value

  set setValue(double newValue) {
    setState(() {
      value = newValue;
      widget.onChanged();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: const SliderThemeData(
        trackHeight: 30,
        trackShape: RoundedRectSliderTrackShape(),
        thumbColor: Colors.black,
        activeTickMarkColor: Colors.blue,
        inactiveTickMarkColor: Colors.grey,
        tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 2),
        rangeTickMarkShape:  RoundRangeSliderTickMarkShape(tickMarkRadius: 3)
      ),
      child: Column(
        children: [
          Text(
            value.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          SizedBox(
            height: 300,
            width: 20,
            child: RotatedBox(
              quarterTurns: 3,
              child: Slider(
                value: value,
                min: widget.min,
                max: widget.max,
                divisions: widget.divisions,
                onChanged: (newValue) {
                  setState(() {
                    value = newValue;
                    widget.onChanged();
                  });
                },
              ),
            ),
          ),
          Transform.rotate(
            angle: 45 * 3 / 180,
            child: Text(
              widget.label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
