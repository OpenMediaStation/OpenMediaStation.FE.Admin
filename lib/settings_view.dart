import 'package:flutter/material.dart';
import 'package:open_media_station_base/open_media_station_base.dart';
import 'package:open_media_station_base/views/login.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await InventoryApi.rescan();
              },
              child: Text("Rescan"),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await logout(context);
              },
              child: const Text("Log out"),
            ),
          ),
        ],
      ),
    );
  }

  Future logout(BuildContext context) async {
    await Preferences.prefs?.clear();

    if (context.mounted) {
      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>
              LoginView(widget: SettingsView(), title: "Open Media Station"),
        ),
        (route) => false, // This removes all previous routes
      );
    } else {
      throw Exception("Context wasn't mounted correctly!");
    }
  }
}
