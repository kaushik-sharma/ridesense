import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ButtonType { elevated, outlined, text }

class CustomButton extends StatelessWidget {
  final ButtonType type;
  final VoidCallback onTap;
  final String text;
  final bool isEnabled;
  final bool isLoading;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const CustomButton({
    super.key,
    required this.type,
    required this.onTap,
    required this.text,
    this.isEnabled = true,
    this.isLoading = false,
    this.prefixIcon,
    this.suffixIcon,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      ButtonType.elevated => _buildElevatedButton(context),
      ButtonType.outlined => _buildOutlinedButton(),
      ButtonType.text => _buildTextButton(),
    };
  }

  Widget _buildElevatedButton(BuildContext context) => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor:
                backgroundColor ?? Theme.of(context).colorScheme.primary,
            foregroundColor: foregroundColor ?? Colors.white,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            disabledForegroundColor: Colors.grey.shade900,
            disabledBackgroundColor: Colors.grey.shade300,
            shape: _shape,
            padding: _padding,
          ),
          onPressed: _onPressed(),
          child: _buildButtonChild(),
        ),
      );

  Widget _buildOutlinedButton() => SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: foregroundColor ?? Colors.black,
            disabledForegroundColor: Colors.grey.shade900,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: _shape,
            padding: _padding,
            side: BorderSide(
              color: isEnabled
                  ? (foregroundColor ?? Colors.black)
                  : Colors.grey.shade300,
              width: 1.r,
            ),
          ),
          onPressed: _onPressed(),
          child: _buildButtonChild(),
        ),
      );

  Widget _buildTextButton() => TextButton(
        style: TextButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: foregroundColor ?? Colors.grey.shade900,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: _shape,
          padding: _padding,
        ),
        onPressed: _onPressed(),
        child: _buildButtonChild(),
      );

  Widget _buildButtonChild() => isLoading
      ? SizedBox(
          width: 25.r,
          height: 25.r,
          child: CircularProgressIndicator(
            color: foregroundColor ?? Colors.white,
            strokeWidth: 2.r,
          ),
        )
      : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prefixIcon != null) ...[
              Icon(prefixIcon!, size: 20.sp),
              SizedBox(width: 8.w),
            ],
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            if (suffixIcon != null) ...[
              SizedBox(width: 8.w),
              Icon(suffixIcon!, size: 20.sp),
            ],
          ],
        );

  OutlinedBorder get _shape => const StadiumBorder();

  EdgeInsets get _padding =>
      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h);

  VoidCallback? _onPressed() => isEnabled && !isLoading ? onTap : null;
}
