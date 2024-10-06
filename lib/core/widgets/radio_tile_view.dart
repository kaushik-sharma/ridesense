import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RadioTileOption<T> {
  final T value;
  final String text;

  const RadioTileOption({required this.value, required this.text});
}

class RadioTileView<T> extends StatelessWidget {
  final List<RadioTileOption<T>> options;
  final T groupValue;
  final void Function(T value) onChanged;

  const RadioTileView({
    super.key,
    required this.options,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: options.length,
      itemBuilder: (context, index) => RadioListTile<T>(
        value: options[index].value,
        groupValue: groupValue,
        onChanged: (value) {
          if (value == null) return;
          onChanged(value);
        },
        title: Text(options[index].text),
      ),
      separatorBuilder: (context, index) => SizedBox(height: 5.h),
    );
  }
}
