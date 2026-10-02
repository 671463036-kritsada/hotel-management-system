// home_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../util/model/model.dart';
import '../../../../util/function/app_route_observer.dart';
import '../provider/home_screen_provider.dart';
import 'homeScreen_desktopBody.dart';
import 'homeScreen_mobileBody.dart';
import '../../../responsiveLayout/responsive_layout.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  PageRoute<dynamic>? _subscribedRoute;
  Timer? _availabilityRefreshTimer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute<dynamic> && route != _subscribedRoute) {
      if (_subscribedRoute != null) {
        appRouteObserver.unsubscribe(this);
      }
      _subscribedRoute = route;
      appRouteObserver.subscribe(this, route);
    }
  }

  @override
  void didPush() => _startAvailabilityRefresh();

  @override
  void didPopNext() {
    _refreshAvailability();
    _startAvailabilityRefresh();
  }

  @override
  void didPushNext() => _stopAvailabilityRefresh();

  @override
  void didPop() => _stopAvailabilityRefresh();

  void _startAvailabilityRefresh() {
    _stopAvailabilityRefresh();
    _availabilityRefreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _refreshAvailability(),
    );
  }

  void _stopAvailabilityRefresh() {
    _availabilityRefreshTimer?.cancel();
    _availabilityRefreshTimer = null;
  }

  void _refreshAvailability() {
    if (!mounted) return;
    final provider = context.read<HomeScreenProvider>();
    if (provider.hasDateFilter && !provider.isLoading) {
      provider.filterAvailableRooms();
    }
  }

  @override
  void dispose() {
    _stopAvailabilityRefresh();
    appRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final HomeFilterArgs? filterArgs = args is HomeFilterArgs ? args : null;

    return ResponsiveLayout(
      mobileBody: HomeScreenMobileBody(filterArgs: filterArgs),
      desktopBody: HomeScreenDesktopBody(filterArgs: filterArgs),
    );
  }
}
