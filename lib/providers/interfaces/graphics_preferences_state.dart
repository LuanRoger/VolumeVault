import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:volume_vault/shared/preferences/models/graphics_preferences.dart';

class GraphicsPreferencesState extends StateNotifier<GraphicsPreferences> {
  GraphicsPreferencesState({GraphicsPreferences? graphicsPreferences})
      : super(graphicsPreferences ??
            const GraphicsPreferences(lightEffect: true));
}