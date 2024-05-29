import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'app_constants.dart';

class LoadingOverlay {
  BuildContext _context;

  hide() {
    Navigator.of(_context, rootNavigator: true).pop();
  }

  show() {
    showDialog(
        context: _context,
        barrierDismissible: false,
        builder: (ctx) => _FullScreenLoader());
  }

  Future<T> during<T>(Future<T> future) {
    show();
    return future;
  }

  LoadingOverlay._create(this._context);

  factory LoadingOverlay.of(BuildContext context) {
    return LoadingOverlay._create(context);
  }
}

class _FullScreenLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: const Opacity(
              opacity: 0.8,
              child:
                  ModalBarrier(dismissible: false, color: Colors.transparent),
            ),
          ),
          const Center(
            child: SpinKitDoubleBounce(
              color: AppConstants.appPrimaryColor,
              size: 70.0,
            ),
          )
        ],
      ),
    );
  }
}
