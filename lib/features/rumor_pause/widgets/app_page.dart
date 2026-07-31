import 'package:flutter/material.dart';

class AppPage extends StatelessWidget {
  final Widget child;
  final VoidCallback? onBack;
  final bool showBack;

  const AppPage({
    super.key,
    required this.child,
    this.onBack,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isCompact = size.width < 360 || size.height < 680;
    final horizontalPadding = size.width >= 600
        ? 32.0
        : (isCompact ? 16.0 : 20.0);
    final topPadding = isCompact ? 10.0 : 16.0;
    final bottomPadding = isCompact ? 16.0 : 20.0;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            topPadding,
            horizontalPadding,
            bottomPadding,
          ),
          child: Column(
            children: [
              if (showBack)
                Row(
                  children: [
                    IconButton(
                      onPressed: onBack,
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    SizedBox(width: isCompact ? 2 : 4),
                    Text(
                      'Back',
                      style: TextStyle(fontSize: isCompact ? 15 : 17),
                    ),
                  ],
                ),
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
