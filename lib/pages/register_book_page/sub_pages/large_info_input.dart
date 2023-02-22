import 'package:flutter/material.dart';
import 'package:volume_vault/shared/validators/text_field_validator.dart';

class LargeInfoInput extends StatelessWidget {
  final _largeFormKey = GlobalKey<FormState>();

  final TextEditingController observationController;
  final TextEditingController synopsisController;

  LargeInfoInput(
      {super.key,
      required this.observationController,
      required this.synopsisController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                bool allGood = _largeFormKey.currentState!.validate();
                if (allGood) Navigator.pop(context);
              },
              icon: const Icon(Icons.check_rounded))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _largeFormKey,
          child: Column(children: [
            Expanded(
              flex: 10,
              child: TextFormField(
                controller: observationController,
                expands: true,
                decoration: const InputDecoration(
                    labelText: "Observação",
                    filled: true,
                    border: UnderlineInputBorder(borderSide: BorderSide.none)),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
            const Spacer(),
            Expanded(
              flex: 10,
              child: TextFormField(
                controller: synopsisController,
                validator: maximumLenght300,
                expands: true,
                decoration: const InputDecoration(
                    labelText: "Sinopse",
                    filled: true,
                    border: UnderlineInputBorder(borderSide: BorderSide.none)),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: 300,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
