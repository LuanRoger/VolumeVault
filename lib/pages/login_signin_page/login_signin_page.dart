import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:volume_vault/pages/login_signin_page/sections/login_section.dart';
import 'package:volume_vault/pages/login_signin_page/sections/signin_section.dart';
import 'package:volume_vault/shared/assets/app_images.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginSigninPage extends HookWidget {
  const LoginSigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeFactor = MediaQuery.of(context).size.width;
    final minimizedContainer = sizeFactor * 0.1;
    final maximizedContainer = sizeFactor * 0.765;

    final initialSctionMaximizedState = useState(true);
    final loginSctionMaximizedState = useState(false);
    final signinSctionMaximizedState = useState(false);

    final imageConainerDecorator = BoxDecoration(
      borderRadius: BorderRadius.circular(10),
    );
    const containersPadding = EdgeInsets.all(20.0);

    const containersCurves = Curves.easeInOutExpo;
    const containerElementsOpacityDuration = Duration(milliseconds: 600);
    const containerWidthDuration = Duration(milliseconds: 700);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      body: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Row(
            children: [
              AnimatedContainer(
                duration: containerWidthDuration,
                curve: containersCurves,
                height: double.infinity,
                width: loginSctionMaximizedState.value
                    ? maximizedContainer
                    : minimizedContainer,
                clipBehavior: Clip.antiAlias,
                decoration: imageConainerDecorator.copyWith(
                  image: const DecorationImage(
                      image: AppImages.loginImage, fit: BoxFit.cover),
                ),
                padding: containersPadding,
                child: AnimatedOpacity(
                  duration: containerElementsOpacityDuration,
                  curve: containersCurves,
                  opacity: loginSctionMaximizedState.value ? 1 : 0,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.titleLoginPage,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                          ),
                          LoginSection(
                            onSigninButtonPressed: () {
                              loginSctionMaximizedState.value = false;
                              signinSctionMaximizedState.value = true;
                            },
                          )
                        ]),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              AnimatedContainer(
                duration: const Duration(milliseconds: 700),
                curve: containersCurves,
                clipBehavior: Clip.antiAlias,
                decoration: imageConainerDecorator.copyWith(
                  image: const DecorationImage(
                      image: AppImages.loginSigninPageDivider,
                      fit: BoxFit.cover),
                ),
                padding: containersPadding,
                height: double.infinity,
                width: initialSctionMaximizedState.value
                    ? maximizedContainer
                    : minimizedContainer,
                child: AnimatedOpacity(
                  duration: containerElementsOpacityDuration,
                  curve: containersCurves,
                  opacity: initialSctionMaximizedState.value ? 1 : 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!
                            .initialPageTitle,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              loginSctionMaximizedState.value = true;
                              initialSctionMaximizedState.value = false;
                            },
                            child: Text(AppLocalizations.of(context)!.loginButtonLoginPage),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              signinSctionMaximizedState.value = true;
                              initialSctionMaximizedState.value = false;
                            },
                            child: Text(AppLocalizations.of(context)!.signinButtonSigninPage),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 5),
              AnimatedContainer(
                duration: containerWidthDuration,
                curve: containersCurves,
                clipBehavior: Clip.antiAlias,
                height: double.infinity,
                decoration: imageConainerDecorator.copyWith(
                  image: const DecorationImage(
                    image: AppImages.signinImage,
                    fit: BoxFit.cover,
                  ),
                ),
                width: signinSctionMaximizedState.value
                    ? maximizedContainer
                    : minimizedContainer,
                padding: containersPadding,
                child: AnimatedOpacity(
                  duration: containerElementsOpacityDuration,
                  curve: containersCurves,
                  opacity: signinSctionMaximizedState.value ? 1 : 0,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.titleSigninPage,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                        ),
                        SigninSection(onLoginButtonPressed: () {
                          signinSctionMaximizedState.value = false;
                          loginSctionMaximizedState.value = true;
                        }),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
