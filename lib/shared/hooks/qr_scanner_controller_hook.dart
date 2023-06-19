import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

MobileScannerController useQrScannerController(
    {bool flash = false, bool autoStart = true, bool useFrontCamera = false}) {
  return use(_QrScannerControllerHook(
    flash: flash,
    autoStart: autoStart,
    useFrontCamera: useFrontCamera,
  ));
}

class _QrScannerControllerHook extends Hook<MobileScannerController> {
  final bool flash;
  final bool autoStart;
  final bool useFrontCamera;

  const _QrScannerControllerHook({
    this.flash = false,
    this.autoStart = true,
    this.useFrontCamera = false,
  });

  @override
  HookState<MobileScannerController, Hook<MobileScannerController>>
      createState() => _QrScannerControllerHookState();
}

class _QrScannerControllerHookState
    extends HookState<MobileScannerController, _QrScannerControllerHook> {
  late final MobileScannerController _controller;

  @override
  void initHook() {
    _controller = MobileScannerController(
      autoStart: hook.autoStart,
      torchEnabled: hook.flash,
      facing: hook.useFrontCamera ? CameraFacing.front : CameraFacing.back,
      formats: [BarcodeFormat.qrCode],
    );
  }

  @override
  MobileScannerController build(BuildContext context) => _controller;

  @override
  void dispose() => _controller.dispose();
}
