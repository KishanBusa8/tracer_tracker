import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracer_tracker/app/data/global/theme_controller.dart';
import 'package:tracer_tracker/flavors.dart';
import 'package:tracer_tracker/helpers/schema/text_styles.dart';

class AppHeaderWidget extends StatelessWidget {
  AppHeaderWidget({super.key});

  final ThemeController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Hey There, ${F.title}',
          style: CustomTextStyle().heading4(),
        ),
        Obx(() {
          return IconButton(
            onPressed: () {
              _controller.toggleTheme();
            },
            icon: _controller.isDarkMode.value
                ? const Icon(Icons.light_mode)
                : const Icon(Icons.dark_mode),
          );
        })
      ],
    );
  }
}
