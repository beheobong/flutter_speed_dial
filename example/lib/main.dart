import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var theme = ValueNotifier(ThemeMode.dark);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Flutter Speed Dial Example';
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: theme,
        builder: (context, value, child) => MaterialApp(
              title: appTitle,
              home: MyHomePage(theme: theme),
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                brightness: Brightness.light,
                primaryColor: Colors.blue,
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                primaryColor: Colors.lightBlue[900],
              ),
              themeMode: value,
            ));
  }
}

class MyHomePage extends StatefulWidget {
  final ValueNotifier<ThemeMode> theme;
  const MyHomePage({Key? key, required this.theme}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var renderOverlay = true;
  var visible = true;
  var switchLabelPosition = false;
  var extend = false;
  var rmicons = false;
  var customDialRoot = false;
  var closeManually = false;
  var useRAnimation = true;
  var isDialOpen = ValueNotifier<bool>(false);
  var speedDialDirection = SpeedDialDirection.up;
  var buttonSize = const Size(56.0, 56.0);
  var childrenButtonSize = const Size(56.0, 56.0);
  var selectedfABLocation = FloatingActionButtonLocation.endDocked;
  var items = [
    FloatingActionButtonLocation.startFloat,
    FloatingActionButtonLocation.startDocked,
    FloatingActionButtonLocation.centerFloat,
    FloatingActionButtonLocation.endFloat,
    FloatingActionButtonLocation.endDocked,
    FloatingActionButtonLocation.startTop,
    FloatingActionButtonLocation.centerTop,
    FloatingActionButtonLocation.endTop,
  ];
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          isDialOpen.value = false;
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Flutter Speed Dial Example"),
        ),
        
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("SpeedDial Location",
                                style: Theme.of(context).textTheme.bodyText1),
                            const SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.grey[800]
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10)),
                              child:
                                  DropdownButton<FloatingActionButtonLocation>(
                                value: selectedfABLocation,
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 20,
                                underline: const SizedBox(),
                                onChanged: (fABLocation) => setState(
                                    () => selectedfABLocation = fABLocation!),
                                selectedItemBuilder: (BuildContext context) {
                                  return items.map<Widget>((item) {
                                    return Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 10),
                                            child: Text(item.value)));
                                  }).toList();
                                },
                                items: items.map((item) {
                                  return DropdownMenuItem<
                                      FloatingActionButtonLocation>(
                                    child: Text(
                                      item.value,
                                    ),
                                    value: item,
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("SpeedDial Direction",
                                style: Theme.of(context).textTheme.bodyText1),
                            const SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.grey[800]
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10)),
                              child: DropdownButton<SpeedDialDirection>(
                                value: speedDialDirection,
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 20,
                                underline: const SizedBox(),
                                onChanged: (sdo) {
                                  setState(() {
                                    speedDialDirection = sdo!;
                                    selectedfABLocation = (sdo.isUp &&
                                                selectedfABLocation.value
                                                    .contains("Top")) ||
                                            (sdo.isLeft &&
                                                selectedfABLocation.value
                                                    .contains("start"))
                                        ? FloatingActionButtonLocation.endDocked
                                        : sdo.isDown &&
                                                !selectedfABLocation.value
                                                    .contains("Top")
                                            ? FloatingActionButtonLocation
                                                .endTop
                                            : sdo.isRight &&
                                                    selectedfABLocation.value
                                                        .contains("end")
                                                ? FloatingActionButtonLocation
                                                    .startDocked
                                                : selectedfABLocation;
                                  });
                                },
                                selectedItemBuilder: (BuildContext context) {
                                  return SpeedDialDirection.values
                                      .toList()
                                      .map<Widget>((item) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 10),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text( describeEnum(item).toUpperCase())),
                                    );
                                  }).toList();
                                },
                                items: SpeedDialDirection.values
                                    .toList()
                                    .map((item) {
                                  return DropdownMenuItem<SpeedDialDirection>(
                                    child: Text(describeEnum(item).toUpperCase()),
                                    value: item,
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!customDialRoot)
                        SwitchListTile(
                            contentPadding: const EdgeInsets.all(15),
                            value: extend,
                            title: const Text("Extend Speed Dial"),
                            onChanged: (val) {
                              setState(() {
                                extend = val;
                              });
                            }),
                      SwitchListTile(
                          contentPadding: const EdgeInsets.all(15),
                          value: visible,
                          title: const Text("Visible"),
                          onChanged: (val) {
                            setState(() {
                              visible = val;
                            });
                          }),
                      SwitchListTile(
                          contentPadding: const EdgeInsets.all(15),
                          value: customDialRoot,
                          title: const Text("Custom dialRoot"),
                          onChanged: (val) {
                            setState(() {
                              customDialRoot = val;
                            });
                          }),
                      SwitchListTile(
                          contentPadding: const EdgeInsets.all(15),
                          value: renderOverlay,
                          title: const Text("Render Overlay"),
                          onChanged: (val) {
                            setState(() {
                              renderOverlay = val;
                            });
                          }),
                      SwitchListTile(
                          contentPadding: const EdgeInsets.all(15),
                          value: closeManually,
                          title: const Text("Close Manually"),
                          onChanged: (val) {
                            setState(() {
                              closeManually = val;
                            });
                          }),
                      SwitchListTile(
                          contentPadding: const EdgeInsets.all(15),
                          value: rmicons,
                          title: const Text("Remove Icons (for children)"),
                          onChanged: (val) {
                            setState(() {
                              rmicons = val;
                            });
                          }),
                      if (!customDialRoot)
                        SwitchListTile(
                            contentPadding: const EdgeInsets.all(15),
                            value: useRAnimation,
                            title: const Text("Use Rotation Animation"),
                            onChanged: (val) {
                              setState(() {
                                useRAnimation = val;
                              });
                            }),
                      SwitchListTile(
                          contentPadding: const EdgeInsets.all(15),
                          value: switchLabelPosition,
                          title: const Text("Switch Label Position"),
                          onChanged: (val) {
                            setState(() {
                              switchLabelPosition = val;
                              if (val) {
                                if ((selectedfABLocation.value
                                            .contains("end") ||
                                        selectedfABLocation.value
                                            .toLowerCase()
                                            .contains("top")) &&
                                    speedDialDirection.isUp) {
                                  selectedfABLocation =
                                      FloatingActionButtonLocation.startDocked;
                                } else if ((selectedfABLocation.value
                                            .contains("end") ||
                                        !selectedfABLocation.value
                                            .toLowerCase()
                                            .contains("top")) &&
                                    speedDialDirection.isDown) {
                                  selectedfABLocation =
                                      FloatingActionButtonLocation.startTop;
                                }
                              }
                            });
                          }),
                      const Text("Button Size"),
                      Slider(
                        value: buttonSize.width,
                        min: 50,
                        max: 500,
                        label: "Button Size",
                        onChanged: (val) {
                          setState(() {
                            buttonSize = Size(val, val);
                          });
                        },
                      ),
                      const Text("Children Button Size"),
                      Slider(
                        value: childrenButtonSize.height,
                        min: 50,
                        max: 500,
                        onChanged: (val) {
                          setState(() {
                            childrenButtonSize = Size(val, val);
                          });
                        },
                      )
                    ]),
              ),
            )),
        // floatingActionButtonLocation: selectedfABLocation,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SpeedDial(
        iconTheme: const IconThemeData(color: Colors.white),
        activeIcon: Icons.close,
        switchLabelPosition: true,
        direction: SpeedDialDirection.left,
        // curve: Curves.easeInBack,
        backgroundColor: Colors.black,
        offset:  Offset(width/3, -50),
        closeManually: false,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
        overlayColor: Colors.black,
        overlayOpacity: 0.7,
        onOpen: () => debugPrint('Opening!'),
        onClose: () => debugPrint('Closing!'),
        children: [
          SpeedDialChild(
              child: const Icon(Icons.ac_unit),
              label: 'ĐẦU TƯ',
              labelBackgroundColor: Colors.transparent,
              backgroundColor: Colors.yellow,
              
              labelShadow: [],
              onTap: () => debugPrint('Second!')),
          SpeedDialChild(
              child: const Icon(Icons.ac_unit),
              label: 'TÍCH LŨY',
              backgroundColor: Colors.yellow,
              labelShadow: [],
              labelBackgroundColor: Colors.transparent,
              onTap: () => debugPrint('Second!'))
        ],

      ),
      
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          child: Row(
            mainAxisAlignment: selectedfABLocation ==
                    FloatingActionButtonLocation.startDocked
                ? MainAxisAlignment.end
                : selectedfABLocation == FloatingActionButtonLocation.endDocked
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                icon: const Icon(Icons.nightlight_round),
                tooltip: "Switch Theme",
                onPressed: () => {
                  widget.theme.value = widget.theme.value.index == 2
                      ? ThemeMode.light
                      : ThemeMode.dark
                },
              ),
              ValueListenableBuilder<bool>(
                  valueListenable: isDialOpen,
                  builder: (ctx, value, _) => IconButton(
                        icon: const Icon(Icons.open_in_browser),
                        tooltip: (!value ? "Open" : "Close") + " Speed Dial",
                        onPressed: () => {isDialOpen.value = !isDialOpen.value},
                      ))
            ],
          ),
        ),
      ),
    );
  }
}

extension EnumExt on FloatingActionButtonLocation {
  /// Get Value of The SpeedDialDirection Enum like Up, Down, etc. in String format
  String get value => toString().split(".")[1];
}
