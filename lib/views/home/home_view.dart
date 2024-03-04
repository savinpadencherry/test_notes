library home_view;

import 'dart:math';

import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter/core/logger.dart';
import 'package:test_flutter/core/models/notes.dart';
import 'package:test_flutter/core/repository/test_repo.dart';
import 'package:test_flutter/core/widgets/note_widget.dart';
import 'package:uuid/uuid.dart';

part 'home_mobile.dart';
part 'home_tablet.dart';
part 'home_desktop.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: const _HomeMobile(),
        desktop: const _HomeDesktop(),
        tablet: const _HomeTablet(),
      );
    });
  }
}
