import 'package:flutter/material.dart';

class NoBookSelectedPlaceholder extends StatelessWidget {
  const NoBookSelectedPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.info_outline_rounded, size: 100),
        Text("Selecione um livro para visualizar.",
            style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }
}
