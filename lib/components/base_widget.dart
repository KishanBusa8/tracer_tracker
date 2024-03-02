import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:tracer_tracker/app/data/global/theme_controller.dart';
import 'package:tracer_tracker/components/app_header_widget.dart';
import 'package:tracer_tracker/helpers/schema/color_schema.dart';

class BaseWidget extends StatelessWidget {
  BaseWidget({super.key, required this.children});
  List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (logic) {
        return Scaffold(
          backgroundColor: ColorSchema.background(),
          body: SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  ShowUpAnimation(
                    delayStart: const Duration(milliseconds: 00),
                    animationDuration: const Duration(seconds: 1),
                    curve: Curves.bounceIn,
                    direction: Direction.vertical,
                    offset: -0.5,
                    child: AppHeaderWidget(),
                  ),
                  ...children
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
