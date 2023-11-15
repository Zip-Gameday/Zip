import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StarRating extends StatelessWidget {
  final int rating;
  final int ratingCount;

  StarRating({this.rating, this.ratingCount});

  @override
  Widget build(BuildContext context) {
    List<Widget> starList = [];

    for (int i = 0; i < rating; i++) {
      starList
          .add(Icon(Icons.star_rate_rounded, color: Colors.yellow, size: 15));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: starList,
    );
  }
}
