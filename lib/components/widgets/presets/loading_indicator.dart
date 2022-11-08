import 'dart:math';

import 'package:daewon_am/components/helpers/color_manager.dart';
import 'package:daewon_am/components/models/theme_setting_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoadingIndicatorState();
}

class IndicatorState {
  final int index;
  int iconIndex;
  double elev;
  double size;
  bool trig = false;
  IndicatorState({required this.index, required this.iconIndex, required this.elev, required this.size});
}

class _LoadingIndicatorState extends State<LoadingIndicator> with SingleTickerProviderStateMixin {
  late ThemeSettingModel _themeModel;
  late Color _indicatorColor;

  late AnimationController _controller;

  bool _firstCall = true;

  final List<IconData> _icons = [ Icons.circle, Icons.square, Icons.star, Icons.favorite ];
  final List<IndicatorState> _states = [ 
    IndicatorState(index: 0, iconIndex: 0, elev: 0.0, size: 24.0),
    IndicatorState(index: 1, iconIndex: 1, elev: 0.0, size: 24.0),
    IndicatorState(index: 2, iconIndex: 2, elev: 0.0, size: 24.0),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000)
    );
    _controller.addListener(onAnimationControllerChanged);    
    _controller.repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstCall) {
      _firstCall = false;
      _themeModel = context.watch<ThemeSettingModel>();
      _themeModel.addListener(onThemeModelChanged);
      onThemeModelChanged();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _states.map((state) {
              return Container(
                margin: const EdgeInsets.only(left: 5, right: 5),
                child: Transform.translate(
                  offset: Offset(0.0, -state.elev),
                  child: Icon(
                    _icons[state.iconIndex],
                    size: state.size,
                    color: _indicatorColor,
                  )
                )
              );
            }).toList()
          );
        },
      ),
    );
  }

  void onThemeModelChanged() {
    var themeType = _themeModel.getThemeType();
    _indicatorColor = ColorManager.getLoadingIndicatorColor(themeType);
  }

  void onAnimationControllerChanged() {
    for (final state in _states) {
      final sine = sin(DateTime.now().millisecondsSinceEpoch * 0.005 + state.index) * 0.5 + 0.5;
      if (!state.trig && sine > 0.95) {
        state.trig = true;
        state.iconIndex = (state.iconIndex + 1) % _icons.length;
      }
      else if (state.trig && sine < 0.05) {
        state.trig = false;
      }
      state.elev = sine * 60.0;
    }
  }
}