import 'package:flutter/material.dart';
import 'package:showcaseview/get_position.dart';

class Content extends StatelessWidget {
  final GetPosition position;
  final Offset offset;
  final Size screenSize;
  final String title;
  final String description;
  final Animation<double> animationOffset;
  final TextStyle titleTextStyle;
  final TextStyle descTextStyle;
  final Widget container;
  final Color tooltipColor;
  final Color textColor;
  final bool showArrow;
  final double cHeight;
  final double cWidht;
  static bool isArrowUp;

  Content(
      {this.position,
      this.offset,
      this.screenSize,
      this.title,
      this.description,
      this.animationOffset,
      this.titleTextStyle,
      this.descTextStyle,
      this.container,
      this.tooltipColor,
      this.textColor,
      this.showArrow,
      this.cHeight,
      this.cWidht});

  bool isCloseToTopOrBottom(Offset position) {
    double height = 120;
    if (cHeight != null) {
      height = cHeight;
    }
    return (screenSize.height - position.dy) <= height;
  }

  String findPositionForContent(Offset position) {
    if (isCloseToTopOrBottom(position)) {
      return 'A';
    } else {
      return 'B';
    }
  }

  double _getTooltipWidth() {
    double width = 40;
    width += (description.length * 6);
    return width;
  }

  bool _isLeft() {
    double screenWidht = screenSize.width / 3;
    return !(screenWidht <= position.getCenter());
  }

  bool _isRight() {
    double screenWidht = screenSize.width / 3;
    return ((screenWidht * 2) <= position.getCenter());
  }

  double _getLeft() {
    if (_isLeft()) {
      double leftPadding = position.getCenter() - (_getTooltipWidth() * 0.1);
      if (leftPadding + _getTooltipWidth() > screenSize.width) {
        leftPadding = (screenSize.width - 20) - _getTooltipWidth();
      }
      return leftPadding;
    } else if (!(_isRight())) {
      return position.getCenter() - (_getTooltipWidth() * 0.5);
    } else {
      return null;
    }
  }

  double _getRight() {
    if (_isRight()) {
      double rightPadding = position.getCenter() + (_getTooltipWidth() / 2);
      if (rightPadding + _getTooltipWidth() > screenSize.width) {
        rightPadding = 20;
      }
      return rightPadding;
    } else if (!(_isLeft())) {
      return position.getCenter() - (_getTooltipWidth() * 0.5);
    } else {
      return null;
    }
  }

  double _getSpace() {
    double space = position.getCenter() - (cWidht / 2);
    if (space + cWidht > screenSize.width) {
      space = screenSize.width - cWidht - 8;
    } else if (space < (cWidht / 2)) {
      space = 16;
    }
    return space;
  }

  @override
  Widget build(BuildContext context) {
    final contentOrientation = findPositionForContent(offset);
    final contentOffsetMultiplier = contentOrientation == "B" ? 1.0 : -1.0;
    isArrowUp = contentOffsetMultiplier == 1.0 ? true : false;
    final contentY = isArrowUp
        ? position.getBottom() + (contentOffsetMultiplier * 3)
        : position.getTop() + (contentOffsetMultiplier * 3);
    final contentFractionalOffset = contentOffsetMultiplier.clamp(-1.0, 0.0);

    double padingTop = isArrowUp ? 22 : 0;
    double padingBottom = isArrowUp ? 0 : 27;

    if (!showArrow) {
      padingTop = 10;
      padingBottom = 10;
    }

    if (container == null) {
      return Stack(
        children: <Widget>[
          showArrow ? _getArrow(contentOffsetMultiplier) : Container(),
          Positioned(
            top: contentY,
            left: _getLeft(),
            right: _getRight(),
            child: FractionalTranslation(
              translation: Offset(0.0, contentFractionalOffset),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0.0, contentFractionalOffset / 10),
                  end: Offset(0.0, 0.100),
                ).animate(animationOffset),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding:
                        EdgeInsets.only(top: padingTop, bottom: padingBottom),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        color: tooltipColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0, top: 8),
                              child: Text(
                                title,
                                style: titleTextStyle ??
                                    Theme.of(context).textTheme.title,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                description,
                                style: descTextStyle ??
                                    Theme.of(context).textTheme.subtitle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      );
    } else {
      return Stack(
        children: <Widget>[
          showArrow ? _getArrow(contentOffsetMultiplier) : Container(),
          Positioned(
            left: _getSpace(),
            top: isArrowUp ? contentY + 10 : contentY - 10,
            child: FractionalTranslation(
              translation: Offset(0.0, contentFractionalOffset),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0.0, contentFractionalOffset / 5),
                  end: Offset(0.0, 0.100),
                ).animate(animationOffset),
                child: Container(
                  child: Material(
                    color: Colors.transparent,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.only(
                            top: padingTop, bottom: padingBottom),
                        child: Container(
                          color: Colors.transparent,
                          height: cHeight,
                          width: cWidht,
                          child: Center(
                            child: container,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _getArrow(contentOffsetMultiplier) {
    final contentFractionalOffset = contentOffsetMultiplier.clamp(-1.0, 0.0);
    return Positioned(
      top: isArrowUp ? position.getBottom() : position.getTop(),
      left: position.getCenter() - 25,
      child: FractionalTranslation(
          translation: Offset(0.0, contentFractionalOffset),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0.0, contentFractionalOffset / 5),
              end: Offset(0.0, 0.100),
            ).animate(animationOffset),
            child: isArrowUp
                ? Icon(
                    Icons.arrow_drop_up,
                    color: tooltipColor,
                    size: 50.0,
                  )
                : Icon(
                    Icons.arrow_drop_down,
                    color: tooltipColor,
                    size: 50.0,
                  ),
          )),
    );
  }
}
