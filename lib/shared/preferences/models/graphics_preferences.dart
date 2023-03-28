import 'package:freezed_annotation/freezed_annotation.dart';

part 'graphics_preferences.freezed.dart';

@freezed
class GraphicsPreferences with _$GraphicsPreferences {
  const factory GraphicsPreferences({required bool lightEffect}) =
      _GraphicsPreferences;
}
