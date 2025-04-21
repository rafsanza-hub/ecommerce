import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class TListTheme {
  TListTheme._(); // To avoid creating instances

  static ListTileThemeData lightListTileTheme = ListTileThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
    ),
    selectedColor: TColors.primary,
    selectedTileColor: TColors.primary.withOpacity(0.1),
    tileColor: TColors.white,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: TSizes.md,
      vertical: TSizes.sm,
    ),
    titleTextStyle: const TextStyle(
      fontSize: TSizes.fontSizeMd,
      fontWeight: FontWeight.w500,
      color: TColors.dark,
    ),
    subtitleTextStyle: const TextStyle(
      fontSize: TSizes.fontSizeSm,
      color: TColors.darkGrey,
    ),
    leadingAndTrailingTextStyle: const TextStyle(
      fontSize: TSizes.fontSizeSm,
      color: TColors.darkGrey,
    ),
    iconColor: TColors.darkGrey,
    style: ListTileStyle.list,
    horizontalTitleGap: TSizes.spaceBtwItems,
    minVerticalPadding: TSizes.sm,
    dense: false,
    enableFeedback: true,
    visualDensity: VisualDensity.standard,
  );

  static ListTileThemeData darkListTileTheme = ListTileThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
    ),
    selectedColor: TColors.primary,
    selectedTileColor: TColors.primary.withOpacity(0.1),
    tileColor: TColors.dark,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: TSizes.md,
      vertical: TSizes.sm,
    ),
    titleTextStyle: const TextStyle(
      fontSize: TSizes.fontSizeMd,
      fontWeight: FontWeight.w500,
      color: TColors.light,
    ),
    subtitleTextStyle: const TextStyle(
      fontSize: TSizes.fontSizeSm,
      color: TColors.lightGrey,
    ),
    leadingAndTrailingTextStyle: const TextStyle(
      fontSize: TSizes.fontSizeSm,
      color: TColors.lightGrey,
    ),
    iconColor: TColors.lightGrey,
    style: ListTileStyle.list,
    horizontalTitleGap: TSizes.spaceBtwItems,
    minVerticalPadding: TSizes.sm,
    dense: false,
    enableFeedback: true,
    visualDensity: VisualDensity.standard,
  );
}
