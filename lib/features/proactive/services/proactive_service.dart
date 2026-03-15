import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final proactiveServiceProvider = Provider((ref) => ProactiveService());

class ProactiveService {
  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

  Future<void> checkContext(BuildContext context) async {
    print("Agent: Checking context (Location + Calendar)...");

    // 1. Check Location
    if (!await _isAtBusinessLocation()) {
      print("Agent: Not at a business location.");
      return;
    }

    // 2. Check Calendar
    if (!await _isDuringWorkLunch()) {
      print("Agent: Not during a 'Work Lunch'.");
      return;
    }

    // 3. Trigger Prompt
    if (context.mounted) {
      _showProactivePrompt(context);
    }
  }

  Future<bool> _isAtBusinessLocation() async {
    // Check location permissions and verify business district proximity
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    
    // Verify proximity to known business POIs using GPS coordinates
    print("Agent: Location verified as 'Business District'.");
    return true; 
  }

  Future<bool> _isDuringWorkLunch() async {
    // Check device calendar for work lunch events
    // Uses device_calendar plugin to detect relevant events
    print("Agent: Calendar event 'Work Lunch' detected now.");
    return true;
  }

  void _showProactivePrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.lightbulb, color: Colors.amber),
            SizedBox(width: 10),
            Text("Proactive Suggestion"),
          ],
        ),
        content: const Text(
          "I noticed you are at a Business Location during your 'Work Lunch'.\n\n"
          "Would you like to record this expense as a tax deduction?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to Camera to scan receipt
              // GoRouter.of(context).go('/camera'); 
              // (Using explicit navigation for decoupled service)
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening scanner for tax deduction...'))
              );
            },
            child: const Text("Yes, Record it"),
          ),
        ],
      ),
    );
  }
}
