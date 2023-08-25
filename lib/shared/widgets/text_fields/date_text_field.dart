import "package:flutter/material.dart";

class DateTextField extends StatelessWidget {
  final void Function(DateTime) onDateSelected;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? label;
  final bool? enabled;

  final TextEditingController? controller;

  const DateTextField({
    required this.onDateSelected,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    super.key,
    this.controller,
    this.enabled,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          icon: const Icon(Icons.calendar_month_rounded),
          label: label != null ? Text(label!) : null,
          filled: true),
      readOnly: true,
      onTap: () async {
        final newDate = await showDatePicker(
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
