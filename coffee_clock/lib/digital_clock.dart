// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:ui';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock>
    with TickerProviderStateMixin {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  double ftc(f) {
    return (5 / 9) * (f - 32);
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();

      // Update once per minute. If you want to update every second, use the
      // following code.

      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );

      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.

      // _timer = Timer(
      //   Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, allowFontScaling: true, width: 1920, height: 1080);

    //variables used in the view
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final weekDay = DateFormat('EEEE').format(_dateTime);
    final day = DateFormat('d').format(_dateTime);
    final month = DateFormat('MMM').format(_dateTime);
    final place = widget.model.location;
    final bool is24 = widget.model.is24HourFormat;
    final ampm = DateFormat('a').format(_dateTime);
    final _condition = widget.model.weatherString;
    final double _temperature = widget.model.unit == TemperatureUnit.celsius
        ? widget.model.temperature
        : ftc(widget.model.temperature);
    final _temperatureExpression =
        _temperature > 25 ? "hot" : _temperature < 15 ? "cold" : "cozy";

    //The expression used depending the weather
    var _extension;
    switch (_condition) {
      case 'cloudy':
        _extension =
            "to remind you that sooner or later the sun will rise again!";
        break;
      case 'foggy':
        _extension = "to tell you to be careful outside because it's foggy.";
        break;
      case 'rainy':
        _extension =
            "warning you that today it is better to carry an umbrella :D";
        break;
      case 'snowy':
        _extension =
            "to ask if you want to make a snowman! Cuz it's snowing :o";
        break;
      case 'thunderstorm':
        _extension =
            "to tell you that today it is better to stay at home, if possible...";
        break;
      case 'windy':
        _extension =
            "to tell you that there is a lot of wind outside! If you go out, please be careful :)";
        break;
      default:
        _extension =
            "to tell you that today is another great day to follow your dreams!";
    }

    final darkCoffe = BoxDecoration(
      boxShadow: [
        BoxShadow(color: Colors.black, blurRadius: 15, offset: Offset(10, 5)),
      ],
      border: Border.all(color: Colors.white, width: 5),
      color: Colors.brown,
      shape: BoxShape.circle,
      gradient: RadialGradient(
        center: Alignment(0.03, 0.05),
        tileMode: TileMode.clamp,
        colors: [
          Colors.brown[900],
          Colors.brown[800],
          Colors.brown[700],
          Colors.brown[700],
          Colors.brown[700],
          Colors.brown[700],
          Colors.black,
        ],
      ),
    );
    final lightCoffe = BoxDecoration(
      boxShadow: [
        BoxShadow(color: Colors.black, blurRadius: 15, offset: Offset(10, 5)),
      ],
      border: Border.all(color: Colors.white, width: 5),
      color: Colors.brown,
      shape: BoxShape.circle,
      gradient: RadialGradient(
        center: Alignment(0.03, 0.05),
        tileMode: TileMode.clamp,
        colors: [
          Colors.brown[50],
          Colors.brown[100],
          Colors.brown[100],
          Colors.brown[200],
          Colors.brown[300],
          Colors.brown[500],
          Colors.black,
        ],
      ),
    );
    final coffeTextStyle = TextStyle(
        color: Colors.brown[200],
        fontSize: ScreenUtil().setSp(140, allowFontScalingSelf: true),
        fontFamily: 'SpecialElite',
        shadows: [
          Shadow(
            blurRadius: 2,
            color: Colors.black,
            offset: Offset(0.2, 0.2),
          ),
          Shadow(
            blurRadius: 80,
            color: Colors.white70,
            offset: Offset(0.0, 0.0),
          ),
          Shadow(
            blurRadius: 60,
            color: Colors.white,
            offset: Offset(0.0, 0.0),
          ),
          Shadow(
            color: Colors.white54,
            blurRadius: 5.0,
            offset: Offset(0.0, -1.0),
          ),
        ]);
    final secondaryCoffeTextStyle = TextStyle(
        color: Colors.brown[200],
        fontSize: ScreenUtil().setSp(50, allowFontScalingSelf: true),
        fontFamily: 'SpecialElite',
        shadows: [
          Shadow(
            blurRadius: 2,
            color: Colors.black,
            offset: Offset(0.2, 0.2),
          ),
          Shadow(
            blurRadius: 150,
            color: Colors.white70,
            offset: Offset(0.2, 0.2),
          ),
          Shadow(
            blurRadius: 60,
            color: Colors.white,
            offset: Offset(0.0, 0.0),
          ),
          Shadow(
            color: Colors.white54,
            blurRadius: 5.0,
            offset: Offset(0.0, -1.0),
          ),
        ]);

    final lightCoffeTextStyle = TextStyle(
        color: Colors.brown[800],
        fontSize: ScreenUtil().setSp(140, allowFontScalingSelf: true),
        fontFamily: 'SpecialElite',
        shadows: [
          Shadow(
            blurRadius: 6,
            color: Colors.brown[800],
            offset: Offset(0.0, 0.0),
          ),
          Shadow(
            blurRadius: 35,
            color: Colors.brown[800],
            offset: Offset(0.0, 0.0),
          ),
          Shadow(
            blurRadius: 100,
            color: Colors.brown[300],
            offset: Offset(0.0, 0.0),
          ),
          Shadow(
            blurRadius: 60,
            color: Colors.brown[200],
            offset: Offset(0.0, 0.0),
          ),
          Shadow(
            color: Colors.brown[500],
            blurRadius: 5.0,
            offset: Offset(0.0, -1.0),
          ),
        ]);
    final lightSecondaryCoffeTextStyle = TextStyle(
        color: Colors.brown[800],
        fontSize: ScreenUtil().setSp(50, allowFontScalingSelf: true),
        fontFamily: 'SpecialElite',
        shadows: [
          Shadow(
            blurRadius: 6,
            color: Colors.brown[800],
            offset: Offset(0.0, 0.0),
          ),
          Shadow(
            blurRadius: 35,
            color: Colors.brown,
            offset: Offset(0.0, 0.0),
          ),
          Shadow(
            blurRadius: 100,
            color: Colors.white,
            offset: Offset(0.0, 0.0),
          ),
          Shadow(
            blurRadius: 60,
            color: Colors.brown,
            offset: Offset(0.0, 0.0),
          ),
          Shadow(
            color: Colors.brown,
            blurRadius: 5.0,
            offset: Offset(0.0, -1.0),
          ),
        ]);

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: Theme.of(context).brightness == Brightness.light
            ? AssetImage("assets/imgs/background_light.png")
            : AssetImage("assets/imgs/background_dark.png"),
        fit: BoxFit.cover,
      )),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Stack(
              alignment: Alignment.centerLeft,
              children: <Widget>[
                Container(
                  height: ScreenUtil().setHeight(600),
                  width: ScreenUtil().setWidth(600),
                  margin: EdgeInsets.only(left: 20),
                  // padding: EdgeInsets.all(20),
                  alignment: Alignment.center,
                  decoration: Theme.of(context).brightness == Brightness.light
                      ? lightCoffe
                      : darkCoffe,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            hour + ":" + minute,
                            style:
                                Theme.of(context).brightness == Brightness.light
                                    ? lightCoffeTextStyle
                                    : coffeTextStyle,
                          ),
                          is24 == true
                              ? Container()
                              : Text(
                                  " "+ampm,
                                  style: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? lightSecondaryCoffeTextStyle
                                      : secondaryCoffeTextStyle,
                                )
                        ],
                      ),
                      Text(
                        weekDay + ", " + day + " " + month,
                        style: Theme.of(context).brightness == Brightness.light
                            ? lightSecondaryCoffeTextStyle
                            : secondaryCoffeTextStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Stack(
              children: <Widget>[
                Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Dear friend",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Caveat",
                              fontSize: ScreenUtil()
                                  .setSp(50, allowFontScalingSelf: true),
                            )),
                        Text(
                            (_condition != 'foggy') &&
                                    (_condition != 'snowy') &&
                                    (_condition != 'windy')
                                ? " I'm writing here, from " +
                                    place +
                                    " on this " +
                                    _condition +
                                    " and " +
                                    _temperatureExpression +
                                    " (" +
                                    widget.model.temperatureString +
                                    ")" +
                                    " day " +
                                    _extension
                                : " I'm writing here, from " +
                                    place +
                                    " on this " +
                                    _temperatureExpression +
                                    " (" +
                                    widget.model.temperatureString +
                                    ")" +
                                    " day " +
                                    _extension,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Caveat",
                              fontSize: ScreenUtil()
                                  .setSp(50, allowFontScalingSelf: true),
                            )),
                      ],
                    ),
                    width: 150,
                    height: 210,
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.blueGrey[50],
                        gradient: LinearGradient(
                            colors: [Colors.white, Colors.grey[400]]),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black,
                              blurRadius: 2,
                              offset: Offset(1, .5)),
                        ]),
                    transform: Matrix4Transform()
                        .rotateByCenter(0.436332, Size(150, 210))
                        .matrix4),
                Positioned(
                  bottom: 20,
                  child: Container(
                    height: 30,
                    width: 120,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          offset: Offset(15, -2),
                          blurRadius: 9,
                          color: Colors.black,
                          spreadRadius: -11)
                    ]),
                    child: Image(
                        image: Theme.of(context).brightness == Brightness.light
                            ? AssetImage('assets/imgs/pencil_1.png')
                            : AssetImage('assets/imgs/pencil_2.png')),
                    transform: Matrix4Transform()
                        .rotateByCenter(
                            0.785398,
                            Size(ScreenUtil().setWidth(390),
                                ScreenUtil().setHeight(60)))
                        .matrix4,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
