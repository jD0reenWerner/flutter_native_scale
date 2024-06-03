import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_checker/flutter_zoom_checker.dart';
import 'package:open_settings_plus/open_settings_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true),
      home: const MyHomePage(title: 'DISPLAY DEMO'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool? isZoomed;
  bool? isDefault;
  bool? isMoreSpace;

  @override
  void initState() {
    FlutterZoomChecker.isZoomed().then((value) => setState(() => isZoomed = value));
    FlutterZoomChecker.isMoreSpace().then((value) => setState(() => isMoreSpace = value));
    FlutterZoomChecker.isDefault().then((value) => setState(() => isDefault = value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: const _FloatingActionButton(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _DisplayZoom(label: 'Larger Text', enabled: isZoomed),
              _DisplayZoom(label: 'Default', enabled: isDefault),
              _DisplayZoom(label: 'More Space', enabled: isMoreSpace),
            ],
          ),
          const Spacer(),
          const Divider(),
          const Spacer(),
          const ContainerRow(container: FixedContainer(width: 120)),
          const Spacer(),
          const ContainerRow(container: _FlexibleContainer()),
          const Spacer(),
          const ContainerRow(container: FixedContainer()),
          const Spacer(),
          const ContainerRow(container: _FlexibleContainer(expanded: true)),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

class FixedContainer extends StatelessWidget {
  const FixedContainer({super.key, this.width = 380});
  final double width;

  @override
  Widget build(BuildContext context) {
    const height = 70.0;
    return Container(
      height: height,
      width: width,
      color: Theme.of(context).primaryColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text('${height.round()}x${width.round()}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

class _FlexibleContainer extends StatelessWidget {
  const _FlexibleContainer({this.expanded = false});

  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: expanded ? FlexFit.tight : FlexFit.loose,
      child: Container(
        color: expanded ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColorDark,
        child: Padding(padding: const EdgeInsets.all(20), child: Text(expanded ? 'EXPANDED' : 'FLEXIBLE', textAlign: TextAlign.center)),
      ),
    );
  }
}

class ContainerRow extends StatelessWidget {
  const ContainerRow({super.key, required this.container});

  final Widget container;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [container, const SizedBox(width: 10), container, const SizedBox(width: 10), container],
    );
  }
}

class _DisplayZoom extends StatelessWidget {
  const _DisplayZoom({required this.label, required this.enabled});

  final String label;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: enabled == null ? Colors.grey : Colors.black)),
        const SizedBox(height: 10),
        if (enabled == null)
          Container(width: 30, height: 30, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 2, color: Colors.grey)))
        else
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: enabled! ? Colors.blue : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(width: 2, color: enabled! ? Colors.blue : Colors.grey.shade800),
            ),
            child: enabled! ? const Icon(Icons.check, color: Colors.black, size: 17) : null,
          ),
      ],
    );
  }
}

class _FloatingActionButton extends StatelessWidget {
  const _FloatingActionButton();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final info = await DeviceInfoPlugin().iosInfo;
        await const OpenSettingsPlusIOS().sendCustomMessage(
          // Settings: Display & Brightness → Display Zoom | SIMULATOR: Developer → Display Zoom
          // -> Preference paths: https://github.com/FifiTheBulldog/ios-settings-urls?tab=readme-ov-file
          info.isPhysicalDevice ? 'App-prefs:DISPLAY&path=MAGNIFY' : 'App-prefs:DEVELOPER_SETTINGS&path=MAGNIFY',
        );
      },
      child: const Icon(Icons.settings),
    );
  }
}
