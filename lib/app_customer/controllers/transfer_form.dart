import 'package:transportation_mobile_app/app_driver/models/entities/globals.dart';

class TransferRequest {
  Map questions = {
    "general": [
      {
        "name": "Pick Up Date",
        "internalName": "scheduledDate",
        "questionFormat": "DatePicker",
        "required": true,
        "responseFormat": "Epoch",
        "value": 0
      },
      {
        "name": "Title",
        "internalName": "title",
        "questionFormat": "TextField",
        "required": true,
        "responseFormat": "Text",
        "value": ""
      },
      {
        "name": "Broker",
        "internalName": "broker",
        "questionFormat": "TextField",
        "required": true,
        "responseFormat": "Text",
        "value": "GATowing"
      },
      {
        "name": "Vin",
        "internalName": "vin",
        "questionFormat": "VinField",
        "required": true,
        "responseFormat": "Text",
        "value": ""
      },
      {
        "name": "Note",
        "internalName": "notes",
        "questionFormat": "TextField",
        "required": false,
        "responseFormat": "Text",
        "value": ""
      }
    ],
    "pickUp": [
      {
        "name": "Name",
        "internalName": "firstName",
        "questionFormat": "TextField",
        "required": true,
        "responseFormat": "Text",
        "value": ""
      },
      {
        "name": "Address 1",
        "internalName": "address1",
        "questionFormat": "TextField",
        "required": true,
        "responseFormat": "Text",
        "value": ""
      },
      {
        "name": "Address 2",
        "internalName": "address2",
        "questionFormat": "TextField",
        "required": false,
        "responseFormat": "Text",
        "value": ""
      },
      {
        "name": "City",
        "internalName": "city",
        "questionFormat": "TextField",
        "required": true,
        "responseFormat": "Text",
        "value": ""
      },
      {
        "name": "State 2-letter abbreviation",
        "internalName": "state",
        "questionFormat": "StatePicker",
        "required": true,
        "responseFormat": "Text",
        "value": ""
      },
      {
        "name": "Zipcode",
        "internalName": "zipCode",
        "questionFormat": "NumberField",
        "required": true,
        "responseFormat": "Text",
        "value": ""
      },
      {
        "name": "Phone number",
        "internalName": "phone",
        "questionFormat": "PhoneField",
        "required": true,
        "responseFormat": "Text",
        "value": ""
      }
    ],
    "dropOff": [
      {
        "name": "Name",
        "internalName": "firstName",
        "questionFormat": "TextField",
        "required": true,
        "responseFormat": "Text",
        "value": ""
      },
      {
        "name": "Address 1",
        "internalName": "address1",
        "questionFormat": "TextField",
        "required": true,
        "responseFormat": "Text",
        "value": ""
      },
      {
        "name": "Address 2",
        "internalName": "address2",
        "questionFormat": "TextField",
        "required": false,
        "responseFormat": "Text",
        "value": ""
      },
      {
        "name": "City",
        "internalName": "city",
        "questionFormat": "TextField",
        "required": true,
        "responseFormat": "Text",
        "value": ""
      },
      {
        "name": "State 2-letter abbreviation",
        "internalName": "state",
        "questionFormat": "StatePicker",
        "required": true,
        "responseFormat": "Text",
        "value": ""
      },
      {
        "name": "Zipcode",
        "internalName": "zipCode",
        "questionFormat": "TextField",
        "required": true,
        "responseFormat": "Text",
        "value": ""
      },
      {
        "name": "Phone number",
        "internalName": "phone",
        "questionFormat": "TextField",
        "required": true,
        "responseFormat": "Text",
        "value": ""
      }
    ]
  };

  Set<String> getMissingItems({String section}) {
    Set<String> items = Set.castFrom(questions[section]
        .map((e) => e['required'] && (e['value'] == 0 || e['value'] == "")
            ? e['name']
            : null)
        .toSet());
    items.removeWhere((element) => element == null);
    if (items.isEmpty) items.add("Nothing missing");
    return items;
  }

  bool canSendRequest() {
    Set items = questions['general']
        .where((e) => e['required'] && (e['value'] == 0 || e['value'] == ""))
        .toSet();
    items.addAll(questions['pickUp']
        .where((e) => e['required'] && (e['value'] == 0 || e['value'] == ""))
        .toSet());
    items.addAll(questions['dropOff']
        .where((e) => e['required'] && (e['value'] == 0 || e['value'] == ""))
        .toSet());
    return items.isEmpty;
  }

  Map<String, dynamic> getRequest() {
    Map<String, dynamic> request = {};
    for (Map<String, dynamic> item in questions['general']) {
      request[item['internalName']] = item["value"];
    }
    request["source"] = {};
    request["destination"] = {};
    for (Map<String, dynamic> item in questions['pickUp']) {
      request["source"][item['internalName']] = item["value"];
    }
    for (Map<String, dynamic> item in questions['dropOff']) {
      request["destination"][item['internalName']] = item["value"];
    }
    request['customer'] = currentStaff.username;
    return request;
  }
}
