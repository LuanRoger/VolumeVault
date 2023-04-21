import 'package:flutter/material.dart';

class DateTextField extends StatelessWidget {
  final void Function(DateTime) onDateSelected;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? label;

  final TextEditingController? controller;

  const DateTextField(
      {super.key,
      required this.onDateSelected,
      required this.initialDate,
      required this.firstDate,
      required this.lastDate,
      this.controller,
      this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          icon: const Icon(Icons.calendar_month_rounded),
          label: label != null ? Text(label!) : null,
          filled: true),
      readOnly: true,
      onTap: () async {
        final DateTime? newDate = await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: firstDate,
            lastDate: lastDate);
        if (newDate == null) return;

        onDateSelected(newDate);
      },
    );
  }
}
