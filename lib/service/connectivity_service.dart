import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityService {
  late final StreamSubscription<InternetStatus> _subscription;

  ConnectivityService(BuildContext context) {
    _subscription = InternetConnection().onStatusChange.listen((status) {
        if (context.mounted && status == InternetStatus.disconnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No WI-FI connection!')),
          );
        }
    });
  }

  Future<InternetStatus> getCurrentStatus() async {
    final bool isConnected = await InternetConnection().hasInternetAccess;
    return isConnected ? InternetStatus.connected : InternetStatus.disconnected;
  }

  void dispose() {
    _subscription.cancel();
  }
}