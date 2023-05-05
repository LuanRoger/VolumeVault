abstract class ChipChoice<T> {
  final T? initialOption;
  final bool wrapped;
  final void Function(T)? onChanged;

  ChipChoice({this.initialOption, this.wrapped = true, this.onChanged});
}
