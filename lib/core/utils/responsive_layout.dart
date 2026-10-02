import 'package:flutter/material.dart';

class ResponsiveLayout {
  static const double mobileMax = 640.0;
  static const double tabletMax = 1024.0;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileMax;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= mobileMax &&
      MediaQuery.sizeOf(context).width <= tabletMax;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width > tabletMax;

  static T select<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < mobileMax) return mobile;
    if (width <= tabletMax) return tablet ?? mobile;
    return desktop;
  }
}

class ResponsiveBuilder extends StatelessWidget {
  final WidgetBuilder mobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < ResponsiveLayout.mobileMax) {
          return mobile(context);
        } else if (constraints.maxWidth <= ResponsiveLayout.tabletMax) {
          return (tablet ?? mobile)(context);
        } else {
          return desktop(context);
        }
      },
    );
  }
}
