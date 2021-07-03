import 'package:flutter/material.dart';

class CategoryAndSeeAllButton extends StatelessWidget {
  const CategoryAndSeeAllButton({
    Key key,
    @required this.title,
    @required this.isSelected,
    @required this.changeCategory,
    @required this.padding,
  }) : super(key: key);

  final String title;
  final bool isSelected;
  final Function changeCategory;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.changeCategory,
      child: Container(
        padding: EdgeInsets.fromLTRB(padding * 0.5, padding * 0.5,
            title == 'See All' ? 0 : padding * 0.5, padding * 0.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: isSelected ? const Color(0xffe8e8e8) : null,
        ),
        child: Text(
          this.title,
          style: TextStyle(
            fontWeight: title == 'See All' ? FontWeight.w300 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
