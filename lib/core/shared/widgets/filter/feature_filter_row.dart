import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/shared/widgets/filter/feature_filter_chip.dart';

import 'package:ai_eru_tawasol/core/shared/widgets/filter/filter_item.dart';
export 'package:ai_eru_tawasol/core/shared/widgets/filter/filter_item.dart';

class FeatureFilterRow<T> extends StatelessWidget {
  final List<FilterItem<T>> items;
  final T? activeValue;
  final void Function(T?) onChanged;

  const FeatureFilterRow({
    super.key,
    required this.items,
    required this.activeValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, __) => AppSpacing.w8,
        itemBuilder: (context, i) {
          final item = items[i];
          return FeatureFilterChip(
            label: item.label,
            icon: item.icon,
            color: item.color,
            isSelected: activeValue == item.value,
            onTap: () => onChanged(
              activeValue == item.value ? null : item.value,
            ),
          );
        },
      ),
    );
  }
}
