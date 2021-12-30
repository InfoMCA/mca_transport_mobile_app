import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:transportation_mobile_app/app_driver/utils/app_colors.dart';
import 'package:transportation_mobile_app/app_driver/utils/app_images.dart';

class VehiclePanelReport extends StatefulWidget {
  const VehiclePanelReport(
      {Key key,
      @required this.sideName,
      this.onIssueReported,
      this.issues = const []})
      : super(key: key);

  final String sideName;
  final String Function(List<Map<String, dynamic>> issues) onIssueReported;
  final List<Map<String, dynamic>> issues;

  @override
  State<VehiclePanelReport> createState() => _VehiclePanelReportState();
}

class _VehiclePanelReportState extends State<VehiclePanelReport> {
  final Map<String, Map<String, double>> imageProperties = {
    "left": {"width": 280, "height": 150, "left": 30, "top": 0},
    "back": {"width": 200, "height": 150, "left": 70, "top": 0},
    "right": {"width": 280, "height": 150, "left": 30, "top": 0},
    "front": {"width": 250, "height": 150, "left": 30, "top": 0},
    "top": {"width": 250, "height": 150, "left": 30, "top": 0},
  };

  final Map<String, List<Map<String, double>>> dotCoordinates = {
    "left": [
      {"markNumber": 1, "top": 80, "left": 30},
      {"markNumber": 2, "top": 60, "left": 110},
      {"markNumber": 3, "top": 60, "left": 180},
      {"markNumber": 4, "top": 50, "left": 255},
      {"markNumber": 5, "top": 80, "left": 260},
      {"markNumber": 7, "top": 80, "left": 60},
      {"markNumber": 6, "top": 80, "left": 225},
      {"markNumber": 8, "top": 30, "left": 130},
      {"markNumber": 9, "top": 30, "left": 190},
    ],
    "back": [
      {"markNumber": 1, "top": 5, "left": 150},
      {"markNumber": 2, "top": 40, "left": 150},
      {"markNumber": 3, "top": 90, "left": 150},
      {"markNumber": 4, "top": 40, "left": 80},
      {"markNumber": 5, "top": 40, "left": 225},
      {"markNumber": 6, "top": 90, "left": 80},
      {"markNumber": 7, "top": 90, "left": 225},
    ],
    "right": [
      {"markNumber": 1, "top": 80, "left": 270},
      {"markNumber": 2, "top": 60, "left": 200},
      {"markNumber": 3, "top": 60, "left": 130},
      {"markNumber": 4, "top": 50, "left": 50},
      {"markNumber": 5, "top": 80, "left": 30},
      {"markNumber": 6, "top": 80, "left": 240},
      {"markNumber": 7, "top": 80, "left": 75},
      {"markNumber": 8, "top": 30, "left": 170},
      {"markNumber": 9, "top": 30, "left": 110},
    ],
    "front": [
      {"markNumber": 1, "top": 5, "left": 130},
      {"markNumber": 2, "top": 40, "left": 130},
      {"markNumber": 3, "top": 100, "left": 130},
      {"markNumber": 5, "top": 65, "left": 205},
      {"markNumber": 4, "top": 65, "left": 60},
      {"markNumber": 7, "top": 100, "left": 205},
      {"markNumber": 6, "top": 100, "left": 60},
    ],
    "top": [
      {"markNumber": 1, "top": 100, "left": 0},
      {"markNumber": 2, "top": 100, "left": 120},
      {"markNumber": 3, "top": 100, "left": 50},
      {"markNumber": 4, "top": 100, "left": 150},
    ]
  };

  @override
  Widget build(BuildContext context) {
    if (dotCoordinates == null ||
        !dotCoordinates.containsKey(widget.sideName)) {
      return Container();
    }
    return Column(
      children: [
        Text("Tap anywhere in the image below to report an issue"),
        SizedBox(
          // width: 300,
          height: 150,
          child: Stack(
            children: [
              Positioned(
                top: imageProperties[widget.sideName]['top'],
                left: imageProperties[widget.sideName]['left'],
                child: Image.asset(
                  AppImages.report_issues_base + widget.sideName + ".png",
                  width: imageProperties[widget.sideName]['width'],
                  height: imageProperties[widget.sideName]['height'],
                  fit: BoxFit.fill,
                ),
              ),
              ...dotCoordinates[widget.sideName]
                  .map((Map<String, double> e) => Positioned(
                        top: e["top"],
                        left: e["left"],
                        child: IssueButtonMenu(
                            allIssues: widget.issues,
                            sideName: widget.sideName,
                            markNumber: e["markNumber"],
                            onChange: (allIssues) =>
                                widget.onIssueReported(allIssues)),
                      ))
                  .toList(),
            ],
          ),
        ),
      ],
    );
  }
}

class IssueButtonMenu extends StatefulWidget {
  IssueButtonMenu({
    Key key,
    @required this.allIssues,
    @required String sideName,
    @required double markNumber,
    this.onChange,
  })  : panelName = "${sideName}_${markNumber.round()}",
        super(key: key);

  final List<Map<String, dynamic>> allIssues;
  final String panelName;
  final String Function(List<Map<String, dynamic>> issues) onChange;
  List<String> data = IssueTypes.values.map((e) => e.getName()).toList();

  @override
  State<IssueButtonMenu> createState() => _IssueButtonMenuState();
}

class _IssueButtonMenuState extends State<IssueButtonMenu> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> currentIssues = widget.allIssues
        .where((element) => element['name'] == widget.panelName)
        .toList();
    return SizedBox(
      height: 40,
      width: 40,
      child: TextButton(
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
              color: currentIssues.isNotEmpty ? Colors.red : Colors.grey,
              shape: BoxShape.circle),
        ),
        onPressed: () async {
          print("panel name: " + widget.panelName);
          IssueTypes issueSel = IssueTypes.none;
          List<IssueTypes> selected = [IssueTypes.none];
          if (currentIssues.isNotEmpty) {
            selected = IssueTypes.values
                .where((element) =>
                    element.getAbbreviation() == currentIssues.first['value'])
                .toList();
          }

          List<int> issues = await showPickerModal(context, selected);
          if (issues == null) {
            return;
          }
          issueSel = IssueTypes.values
              .where((element) => element.getName() == widget.data[issues[0]])
              .first;
          widget.allIssues.removeWhere((Map<String, dynamic> element) =>
              element['name'] == widget.panelName);
          if (issueSel != IssueTypes.none) {
            widget.allIssues.add({
              "name": widget.panelName,
              "value": issueSel.getAbbreviation()
            });
          }
          setState(() {
            widget.onChange(widget.allIssues);
          });
        },
      ),
    );
  }

  Future<List<int>> showPickerModal(
      BuildContext context, List<IssueTypes> values) async {
    final result = await Picker(
      adapter: PickerDataAdapter<String>(pickerdata: widget.data),
      selecteds: values.map((e) => widget.data.indexOf(e.getName())).toList(),
      changeToFirst: true,
      hideHeader: false,
      cancelTextStyle: TextStyle(
          color: AppColors.portGore,
          fontFamily: 'poppins',
          fontSize: 18,
          fontWeight: FontWeight.w700),
      confirmTextStyle: TextStyle(
          color: AppColors.alizarinCrimson,
          fontFamily: 'poppins',
          fontSize: 18,
          fontWeight: FontWeight.w700),
      textStyle: TextStyle(
          color: Colors.black,
          fontFamily: 'poppins',
          fontSize: 20,
          fontWeight: FontWeight.w500),
      selectedTextStyle: TextStyle(
          color: Colors.blue,
          fontFamily: 'poppins',
          fontSize: 20,
          fontWeight: FontWeight.w500),
    ).showModal(this.context); //_sca
    return result;
  }
}

enum IssueTypes {
  none,
  b,
  bb,
  br,
  c,
  cr,
  d,
  f,
  ff,
  l,
  m,
  pc,
  r,
  ru,
  s,
  ss,
  st,
  t
}

extension on IssueTypes {
  String getName() {
    switch (this) {
      case IssueTypes.b:
        return "Bent";
      case IssueTypes.bb:
        return "Buffer Burned";
      case IssueTypes.br:
        return "Broken";
      case IssueTypes.c:
        return "Cut";
      case IssueTypes.cr:
        return "Cracked";
      case IssueTypes.d:
        return "Dented";
      case IssueTypes.f:
        return "Faded";
      case IssueTypes.ff:
        return "Foreign Fluid";
      case IssueTypes.l:
        return "Loose";
      case IssueTypes.m:
        return "Mission";
      case IssueTypes.pc:
        return "Paint Chip";
      case IssueTypes.r:
        return "Rubble";
      case IssueTypes.ru:
        return "Rust";
      case IssueTypes.s:
        return "Scratched";
      case IssueTypes.ss:
        return "Surface Scratch";
      case IssueTypes.st:
        return "Stained";
      case IssueTypes.t:
        return "Torn";
      case IssueTypes.none:
        return "No issues";
      default:
        return "Other";
    }
  }

  String getAbbreviation() {
    switch (this) {
      case IssueTypes.b:
        return "B";
      case IssueTypes.bb:
        return "BB";
      case IssueTypes.br:
        return "BR";
      case IssueTypes.c:
        return "C";
      case IssueTypes.cr:
        return "CR";
      case IssueTypes.d:
        return "D";
      case IssueTypes.f:
        return "F";
      case IssueTypes.ff:
        return "F";
      case IssueTypes.l:
        return "L";
      case IssueTypes.m:
        return "M";
      case IssueTypes.pc:
        return "PC";
      case IssueTypes.r:
        return "R";
      case IssueTypes.ru:
        return "RU";
      case IssueTypes.s:
        return "S";
      case IssueTypes.ss:
        return "SS";
      case IssueTypes.st:
        return "ST";
      case IssueTypes.t:
        return "T";
      case IssueTypes.none:
        return "NONE";
      default:
        return "OTHER";
    }
  }
}
