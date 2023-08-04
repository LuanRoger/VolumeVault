import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:volume_vault/pages/about_page/commands/about_command.dart";
import "package:volume_vault/providers/providers.dart";
import "package:volume_vault/shared/assets/app_images.dart";
import "package:volume_vault/shared/theme/text_themes.dart";
import "package:volume_vault/shared/widgets/heros/icon_app_name.dart";
import "package:volume_vault/shared/widgets/list_tiles/expand_tile_text.dart";

class AboutPage extends ConsumerWidget {
  final AboutCommand _command = AboutCommand();

  AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const creatorName = "Luan Roger";
    const developmentYear = "2023";
    final appInfo = ref.read(packageInfoProvider);

    final neonTextTapGesture = TapGestureRecognizer()
      ..onTap = _command.launchNeonPage;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Sobre"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Flexible(
                flex: 0,
                child: Column(
                  children: [
                    const IconAppName(),
                    Text(appInfo.packageName,
                        style: Theme.of(context).textTheme.titleMedium),
                    Text("v${appInfo.version} - ${appInfo.buildNumber}",
                        style: Theme.of(context).textTheme.titleMedium),
                    Text("Desenvolvido por $creatorName",
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(developmentYear,
                        style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.fqaTitleAboutPage,
                        style: headlineSmall),
                    Expanded(
                      child: ListView(
                        children: [
                          ExpandTileText(
                            AppLocalizations.of(context)!.fqaQuestion1AboutPage,
                            content: TextSpan(
                              text: AppLocalizations.of(context)!
                                  .fqaQuestion1AnswerAboutPage,
                            ),
                          ),
                          ExpandTileText(
                            AppLocalizations.of(context)!.fqaQuestion2AboutPage,
                            content: TextSpan(
                              text: AppLocalizations.of(context)!
                                  .fqaQuestion2AnswerAboutPage,
                            ),
                          ),
                          ExpandTileText(
                            AppLocalizations.of(context)!.fqaQuestion3AboutPage,
                            content: TextSpan(
                              text: AppLocalizations.of(context)!
                                  .fqaQuestion3AnswerAboutPage,
                            ),
                          ),
                          ExpandTileText(
                            AppLocalizations.of(context)!.fqaQuestion4AboutPage,
                            content: TextSpan(
                              text: AppLocalizations.of(context)!
                                  .fqaQuestion4AnswerAboutPage,
                            ),
                          ),
                          ExpandTileText(
                            AppLocalizations.of(context)!.fqaQuestion5AboutPage,
                            content: TextSpan(
                              text: AppLocalizations.of(context)!
                                  .fqaQuestion5AnswerAboutPage,
                            ),
                          ),
                          ExpandTileText(
                            AppLocalizations.of(context)!.fqaQuestion6AboutPage,
                            content: TextSpan(
                              text: AppLocalizations.of(context)!
                                  .fqaQuestion6AnswerAboutPage,
                            ),
                          ),
                          ExpandTileText(
                            AppLocalizations.of(context)!.fqaQuestion7AboutPage,
                            content: TextSpan(
                              text: AppLocalizations.of(context)!
                                  .fqaQuestion7AnswerAboutPage,
                            ),
                          ),
                          ExpandTileText(
                            AppLocalizations.of(context)!.fqaQuestion8AboutPage,
                            content: TextSpan(
                              text: AppLocalizations.of(context)!
                                  .fqaQuestion8AnswerAboutPage,
                            ),
                          ),
                          ExpandTileText(
                            AppLocalizations.of(context)!.fqaQuestion9AboutPage,
                            content: TextSpan(
                              text: AppLocalizations.of(context)!
                                  .fqaQuestion9AnswerAboutPage,
                            ),
                          ),
                          ExpandTileText(
                            AppLocalizations.of(context)!
                                .fqaQuestion10AboutPage,
                            content: TextSpan(
                              text: AppLocalizations.of(context)!
                                  .fqaQuestion10AnswerAboutPage,
                            ),
                          ),
                          ExpandTileText(
                            AppLocalizations.of(context)!
                                .fqaQuestion11AboutPage,
                            content: TextSpan(
                              text: AppLocalizations.of(context)!
                                  .fqaQuestion11AnswerAboutPage,
                            ),
                          ),
                          ExpandTileText(
                            AppLocalizations.of(context)!
                                .fqaQuestion12AboutPage,
                            content: TextSpan(
                              text: AppLocalizations.of(context)!
                                  .fqaQuestion12AnswerAboutPage,
                            ),
                          ),
                          ExpandTileText(
                            AppLocalizations.of(context)!
                                .fqaQuestion13AboutPage,
                            content: TextSpan(
                              text: AppLocalizations.of(context)!
                                  .fqaQuestion13AnswerAboutPage,
                            ),
                          ),
                          ExpandTileText(
                            AppLocalizations.of(context)!
                                .fqaQuestion14AboutPage,
                            content: TextSpan(
                              text: AppLocalizations.of(context)!
                                  .fqaQuestion14AnswerAboutPage,
                            ),
                          ),
                          ExpandTileText(
                            AppLocalizations.of(context)!
                                .fqaQuestion15AboutPage,
                            content: TextSpan(
                              text: AppLocalizations.of(context)!
                                  .fqaQuestion15AnswerAboutPage,
                              children: [
                                TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .fqaQuestion15AnswerProp1AboutPage,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline),
                                    recognizer: neonTextTapGesture)
                              ],
                            ),
                          ),
                          ExpandTileText(
                            AppLocalizations.of(context)!
                                .fqaQuestion16AboutPage,
                            content: TextSpan(
                              text: AppLocalizations.of(context)!
                                  .fqaQuestion16AnswerAboutPage,
                            ),
                          ),
                          ExpandTileText(
                            AppLocalizations.of(context)!
                                .fqaQuestion17AboutPage,
                            content: TextSpan(
                              text: AppLocalizations.of(context)!
                                  .fqaQuestion17AnswerAboutPage,
                            ),
                          ),
                          ExpandTileText(
                            AppLocalizations.of(context)!
                                .fqaQuestion18AboutPage,
                            content: TextSpan(
                              text: AppLocalizations.of(context)!
                                  .fqaQuestion18AnswerAboutPage,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
