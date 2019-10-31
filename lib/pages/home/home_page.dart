import 'package:checklist/mixins/ui_traits_mixin.dart';
import 'package:checklist/pages/home/compact_home_page.dart';
import 'package:checklist/pages/home/regular_home_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget with UITraitsMixin {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final traits = deriveWidthTrait(context);
    Widget widget;
    switch (traits) {
      case UITrait.compact:
        widget = CompactHomePage();
        break;
      case UITrait.regular:
        widget = RegularHomePage();
        break;
    }
    return widget;
  }
}
