import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:volume_vault/models/enums/book_sort.dart';
import 'package:volume_vault/shared/widgets/chip/chip_choice.dart';

class BookSortChipChoice extends HookWidget implements ChipChoice<BookSort> {
  @override
  final BookSort? initialOption;
  @override
  final bool wrapped;
  @override
  final void Function(BookSort)? onChanged;

  const BookSortChipChoice(
      {super.key, this.initialOption, this.wrapped = true, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final selectedItem = useState<BookSort?>(initialOption);

    return ChipsChoice<BookSort>.single(
      value: selectedItem.value,
      wrapped: wrapped,
      onChanged: (newValue) {
        selectedItem.value = newValue;
        onChanged?.call(newValue);
      },
      choiceItems: [
        C2Choice(value: BookSort.title, label: "Titulo"),
        C2Choice(value: BookSort.author, label: "Author"),
        C2Choice(value: BookSort.releaseDate, label: "Data de lançamento"),
        C2Choice(value: BookSort.publisher, label: "Editora"),
        C2Choice(value: BookSort.genre, label: "Genero"),
        C2Choice(value: BookSort.readStartDay, label: "Inicio de leitura"),
        C2Choice(value: BookSort.readEndDay, label: "Fim de leitura"),
        C2Choice(value: BookSort.creationDate, label: "Data do cadastro")
      ],
    );
  }
}
