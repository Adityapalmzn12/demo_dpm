import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class GformSearchBar extends StatefulWidget {
  const GformSearchBar({
    super.key,
    required this.value,
    required this.onChanged,
    this.hintText = 'Search responses',
  });

  final String value;
  final ValueChanged<String> onChanged;
  final String hintText;

  @override
  State<GformSearchBar> createState() => _GformSearchBarState();
}

class _GformSearchBarState extends State<GformSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant GformSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.text = widget.value;
      _controller.selection =
          TextSelection.collapsed(offset: _controller.text.length);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(8),
      elevation: 1,
      shadowColor: Colors.black12,
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
