import 'dart:math';

import 'package:daewon_am/components/helpers/theme/color_manager.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PingPongWidget extends StatefulWidget {
  final Duration duration;
  final int offset;
  final List<IconData> icons;

  const PingPongWidget({
    Key? key,
    this.duration = Duration.zero,
    this.offset = 0,
    required this.icons}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PingPongWidget();
}

class _PingPongWidget extends State<PingPongWidget> with SingleTickerProviderStateMixin {
  late ThemeSettingModel _themeModel;

  late AnimationController _controller;

  late Animation<double> _elevCurveAnimation;
  late Animation<double> _sizeCurveAnimation;
  late Animation _elevAnimation;
  late Animation _sizeAnimation;

  double _elevation = 0;
  double _size = 16;

  late IconData _icon;
  bool _changed = false;
  late int _index;

  late Color _foregroundColor;

  @override
  void initState() {
    super.initState();

    _index = widget.offset;
    _icon = widget.icons[_index];

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100)
    );

    _elevCurveAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.slowMiddle
    );

    _sizeCurveAnimation = CurvedAnimation(
      parent: _controller, 
      curve: Curves.easeInOutExpo
    );

    _elevAnimation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: 1),
          weight: 50
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1, end: 0),
          weight: 50
        ),
      ]
    ).animate(_elevCurveAnimation);

    _sizeAnimation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: 1),
          weight: 20
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1, end: 0),
          weight: 80
        ),
      ]
    ).animate(_sizeCurveAnimation);

    _controller.addListener(callback);
    
    Future.delayed(
      widget.duration,
      () {
        if (mounted) {
          _controller.repeat();
        }
      }
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeModel = context.watch<ThemeSettingModel>();

    loadColors();
  }

  @override
  void dispose() {
    _controller.removeListener(callback);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller, 
      builder: (context, _) {
        return Container(
          width: 32,
          height: 32,
          margin: EdgeInsets.only(bottom: _elevation),
          child: Center(
            child: Icon(
              _icon,
              size: _size,
              color: _foregroundColor,
            ),
          ),
        );
      }
    );
  }

  void loadColors() {
    var themeType = _themeModel.getThemeType();

    _foregroundColor = ColorManager.getForegroundColor(themeType);
  }

  void callback() {
    _elevation = _elevAnimation.value * 60;
      if (!_changed && _sizeAnimation.value >= 0.9) {
        _changed = true;
        _index = (_index + 1) % widget.icons.length;
        setState(() {
          _icon = widget.icons[_index];
        });
      }

      if (_changed && _sizeAnimation.value <= 0.1) {
        _changed = false;
      }

      _size = 16.0 + _sizeAnimation.value * 16;
  }
}

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> {
  final List<IconData> _icons = [ Icons.circle, Icons.square, Icons.star, Icons.favorite ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PingPongWidget(
            icons: _icons,
          ),
          const SizedBox(width: 5),
          PingPongWidget(
            icons: _icons,
            offset: 1,
            duration: const Duration(
              milliseconds: 150
            ),
          ),
          const SizedBox(width: 5),
          PingPongWidget(
            icons: _icons,
            offset: 2,
            duration: const Duration(
              milliseconds: 300
            ),
          ),
        ],
      ),
    );
  }
}