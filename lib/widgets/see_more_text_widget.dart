import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:flutter/material.dart';

class TextWithSeeMore extends StatefulWidget {
  final String text;

  const TextWithSeeMore({super.key, required this.text});

  @override
  TextWithSeeMoreState createState() => TextWithSeeMoreState();
}

class TextWithSeeMoreState extends State<TextWithSeeMore> {
  bool _isExpanded = false;
  bool _isTextOverflowing = false;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: widget.text,
            style: const TextStyle(fontSize: 16.0),
          ),
          maxLines: 3,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        _isTextOverflowing = textPainter.didExceedMaxLines;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: const TextStyle(fontSize: 16.0),
              maxLines: _isExpanded ? null : 3,
              overflow:
                  _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            if (_isTextOverflowing || _isExpanded)
              InkWell(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Text(
                  _isExpanded ? 'See less' : 'See more',
                  style: TextStyle(color: AppColors.redColor),
                ),
              ),
          ],
        );
      },
    );
  }
}
