import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class SearchField extends StatefulWidget {
  final String placeholder;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;

  const SearchField({
    super.key,
    required this.placeholder,
    required this.onChanged,
    this.onClear,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: _controller,
        style: AppTextStyles.input,
        textInputAction: TextInputAction.search,
        onChanged: (v) {
          widget.onChanged(v);
          setState(() => _hasText = v.isNotEmpty);
        },
        decoration: InputDecoration(
          hintText: widget.placeholder,
          hintStyle: AppTextStyles.input.copyWith(color: AppColors.textFaint),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.textFaint,
            size: 16,
          ),
          suffixIcon: _hasText
              ? GestureDetector(
            onTap: () {
              _controller.clear();
              widget.onChanged('');
              widget.onClear?.call();
              setState(() => _hasText = false);
            },
            child: const Icon(
              Icons.close,
              color: AppColors.textFaint,
              size: 16,
            ),
          )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}