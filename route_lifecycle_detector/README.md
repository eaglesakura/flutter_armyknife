A lightweight library for detecting Navigator/ModalRoute/BuildContext lifecycles.
It solves **dialog multiple display issues caused by multiple asynchronous processes** and enables UI display at appropriate timing.

## Problem Statement

Typical problems that occur when multiple asynchronous processes are executed:

1. **Two heavy processes run in parallel on Screen A**
2. **Process 1 completes and Screen B opens**  
3. **Process 2 completes and a dialog is displayed on top of Screen B**

Using this library, you can automatically delay dialog display until Screen B closes and returns to Screen A.

## Features

- **Prevent Multiple Dialog Display**: Delay UI display while Route is inactive
- **Detailed Lifecycle State Detection**: Real-time detection of Route's current state (active/inactive/building/destroyed) and app foreground/background state
- **Stream-based Monitoring**: Monitor Route lifecycle changes via Stream
- **Type-safe State Management**: Type-safe pattern matching with sealed class using Freezed
- **Flexible Waiting Feature**: Wait for lifecycle state changes with custom conditions
- **Lightweight Design**: Minimal dependencies and performance overhead

## Getting started

Add the library to your `pubspec.yaml`:

```yaml
dependencies:
  route_lifecycle_detector: ^1.1.0
```

Add RouteLifecycleDetector observer to MaterialApp:

```dart
import 'package:route_lifecycle_detector/route_lifecycle_detector.dart';

MaterialApp(
  navigatorObservers: [
    RouteLifecycleDetector.navigatorObserver,
  ],
)
```

## Usage

### Problem Example: Multiple Dialog Display

```dart
// Bad example: Unintended multiple dialog display due to multiple async processes
class BadExamplePage extends StatefulWidget {
  @override
  _BadExamplePageState createState() => _BadExamplePageState();
}

class _BadExamplePageState extends State<BadExamplePage> {
  @override
  void initState() {
    super.initState();
    
    // Heavy process 1: Open Screen B after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(context, MaterialPageRoute(builder: (_) => PageB()));
    });
    
    // Heavy process 2: Open dialog after 3 seconds (Problem occurs!)
    Future.delayed(Duration(seconds: 3), () {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(title: Text('Task 2 Complete')),
      ); // Dialog appears on top of Screen B
    });
  }
  
  @override
  Widget build(BuildContext context) => Scaffold(/*...*/);
}
```

### Solution: Lifecycle-aware Processing

```dart
import 'package:route_lifecycle_detector/route_lifecycle_detector.dart';

class GoodExamplePage extends StatefulWidget {
  @override
  _GoodExamplePageState createState() => _GoodExamplePageState();
}

class _GoodExamplePageState extends State<GoodExamplePage> {
  @override
  void initState() {
    super.initState();
    
    // Heavy process 1: Open Screen B after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(context, MaterialPageRoute(builder: (_) => PageB()));
    });
    
    // Heavy process 2: Open dialog after 3 seconds (with lifecycle consideration)
    Future.delayed(Duration(seconds: 3), () async {
      // Wait until Route becomes active
      final lifecycle = await context.waitLifecycleWith(
        (lifecycle) => lifecycle is RouteLifecycleActive,
      );
      
      if (lifecycle is RouteLifecycleActive && mounted) {
        // Display dialog after screen returns to foreground
        showDialog(
          context: context,
          builder: (_) => AlertDialog(title: Text('Task 2 Complete')),
        );
      }
    });
  }
  
  @override
  Widget build(BuildContext context) => Scaffold(/*...*/);
}
```

### Getting Current Lifecycle State

```dart
// Check current lifecycle state before displaying dialog
void showDialogSafely(BuildContext context) {
  final lifecycle = RouteLifecycle.of(context);
  
  if (lifecycle is RouteLifecycleActive && lifecycle.isForeground) {
    // Display dialog only when Route is at foreground and app is in foreground
    showDialog(
      context: context,
      builder: (_) => AlertDialog(title: Text('Safely Displayed')),
    );
  } else {
    // Delay display when Route is inactive or app is in background
    print('Route is inactive or app is in background, delaying dialog display');
  }
}
```

### Stream-based Monitoring

```dart
// Monitor lifecycle changes to control dialog display
class SmartDialogController {
  StreamSubscription? _subscription;
  final List<VoidCallback> _pendingDialogs = [];
  
  void startListening(BuildContext context) {
    _subscription = RouteLifecycle.streamOf(context).listen((lifecycle) {
      if (lifecycle is RouteLifecycleActive && 
          lifecycle.isForeground && 
          _pendingDialogs.isNotEmpty) {
        // Display pending dialogs when Route returns to foreground and app is in foreground
        final dialogs = List<VoidCallback>.from(_pendingDialogs);
        _pendingDialogs.clear();
        
        for (final showDialog in dialogs) {
          showDialog();
        }
      }
    });
  }
  
  void showDialogWhenActive(BuildContext context, WidgetBuilder builder) {
    final lifecycle = RouteLifecycle.of(context);
    if (lifecycle is RouteLifecycleActive && lifecycle.isForeground) {
      // Display immediately
      showDialog(context: context, builder: builder);
    } else {
      // Hold for later display
      _pendingDialogs.add(() => showDialog(context: context, builder: builder));
    }
  }
  
  void dispose() {
    _subscription?.cancel();
    _pendingDialogs.clear();
  }
}
```

### Waiting for Lifecycle Changes

```dart
// Wait until Route becomes active and app is in foreground
try {
  final result = await context.waitLifecycleWith(
    (lifecycle) => lifecycle is RouteLifecycleActive && lifecycle.isForeground,
  );
  // Route has resumed
  print('Route has resumed: $result');
} on BadLifecycleException catch (e) {
  // Route was destroyed or could not reach the expected state
  print('Could not reach expected state: ${e.latestLifecycle}');
}
```

### Practical Usage Example

Example of stopping processing while dialog is open and resuming when dialog closes:

```dart
class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  StreamSubscription? _subscription;
  
  @override
  void initState() {
    super.initState();
    _startProcessing();
  }
  
  void _startProcessing() {
    _subscription = RouteLifecycle.streamOf(context).listen((lifecycle) {
      if (lifecycle is RouteLifecycleActive && lifecycle.isForeground) {
        // Execute processing only when Route is at foreground and app is in foreground
        _performBackgroundTask();
      }
    });
  }
  
  void _performBackgroundTask() {
    // Execute background task
    print('Task is running...');
  }
  
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Display dialog
            await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                content: Text('Dialog'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Close'),
                  ),
                ],
              ),
            );
            // Processing automatically resumes after dialog is closed
          },
          child: Text('Open Dialog'),
        ),
      ),
    );
  }
}
```

## Lifecycle States

| State | Description | Dialog Display Recommendation |
|-------|-------------|----------------|
| `RouteLifecycleActive(isForeground: true)` | App is in foreground and Route is at top of stack | 🟢 Safe to display |
| `RouteLifecycleActive(isForeground: false)` | Route is at top of stack but app is in background | 🔴 Should delay display |
| `RouteLifecycleInactive` | Route is not at top of stack | 🔴 Should delay display |
| `RouteLifecycleBuilding` | Widget is being built and Route is not yet created | 🔴 Cannot display |
| `RouteLifecycleDestroyed` | Route has been destroyed | 🔴 Cannot display |

**Note:** The `isForeground` property allows fine-grained control over app foreground/background state.

## Additional information

This library combines Flutter's NavigatorObserver with flutter_fgbg to accurately track Route lifecycles.

**Key Benefits:**

- Prevent unintended process execution due to dialogs and screen transitions
- Control considering app foreground/background state
- Stream-based reactive programming support

**Contributing:**
Bug reports and feature requests are welcome at [GitHub Issues](https://github.com/eaglesakura/flutter_armyknife/issues).
