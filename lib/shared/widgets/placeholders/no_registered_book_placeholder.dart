import 'package:flutter/material.dart';

class NoRegisteredBookPlaceholder extends StatelessWidget {
  const NoRegisteredBookPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.book, size: 100),
        Text(
          "Nenhum livro cadastrado.",
          style: Theme.of(context).textTheme.headlineSmall,
        )
      ],
    );
  }
}
