import 'package:flutter/material.dart';

enum UITrait { compact, regular }

mixin UITraitsMixin {
  UITrait deriveWidthTrait(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width <= 600) {
      return UITrait.compact;
    } else {
      return UITrait.regular;
    }
  }
}
