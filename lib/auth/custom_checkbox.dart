import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {

  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CustomCheckbox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: widget.value,
      onChanged: (bool? value) {
        if (value != null) {
          widget.onChanged(value);
        }
      }, 
    );
  }
}