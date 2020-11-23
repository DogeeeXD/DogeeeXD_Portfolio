import 'package:flutter/material.dart';
import 'package:universal_html/prefer_sdk/html.dart' as html;
import 'package:dogeeexd/widgets/translate_on_hover.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

extension HoverExtensions on Widget {
  // Get a reference to the body of the view
  static final appContainer =
      html.window.document.getElementById('app-container');

  Widget get moveUpOnHover {
    if (kIsWeb) {
      return TranslateOnHover(
        child: this,
      );
    }
    return Nothing(this);
  }
}
