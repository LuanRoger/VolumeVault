import "package:url_launcher/url_launcher.dart";
import "package:volume_vault/shared/consts.dart";

abstract class AboutStrategy {
  Future<void> launchNeonPage() async {
    final neonUri = Uri.parse(Consts.NEON_URL);
    await launchUrl(neonUri);
  }
}
