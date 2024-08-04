// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomCart extends StatelessWidget {
  final Widget child;
  final int count;
  const CustomCart({
    Key? key,
    required this.child,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        count < 1
            ? Container()
            : Positioned(
                top: 6,
                right: 8,
                child: Container(
                  height: 14,
                  width: 14,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              )
      ],
    );
  }
}
