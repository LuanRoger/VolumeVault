import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:volume_vault/shared/validators/text_field_validator.dart';

class LargeInfoInput extends HookWidget {
  final _largeFormKey = GlobalKey<FormState>();

  final String? initialObservationText;
  final String? initialSynopsisText;

  LargeInfoInput(
      {super.key, this.initialObservationText, this.initialSynopsisText});

  @override
  Widget build(BuildContext context) {
    final observationController =
        useTextEditingController(text: initialObservationText);
    final synopsisController =
        useTextEditingController(text: initialSynopsisText);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                bool allGood = _largeFormKey.currentState!.validate();
                if (allGood) {
                  Navigator.pop(context,
                      [observationController.text, synopsisController.text]);
                }
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
