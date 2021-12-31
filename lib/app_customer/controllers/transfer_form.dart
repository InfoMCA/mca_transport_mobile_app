import 'package:transportation_mobile_app/app_driver/models/entities/globals.dart';

class TransferRequest {
  Map questions = {
    "general": [
      {
        "name": "Pick Up Date",
        "internalName": "scheduledDate",
        "questionFormat": "DatePicker",
        "responseFormat": "Epoch",
        "value": 0
      },
      {
        "name": "Title",
        "internalName": "title",
        "questionFormat": "TextField",
        "responseFormat": "Text",
        "value": ""
      },
      {
        "name": "Broker",
        "internalName": "broker",
        "questionFormat": "TextField",
        "responseFormat": "Text",
        "value": "GATowing"
      },
      {
        "name": "Vin",
        "internalName": "vin",
        "questionFormat": "TextField",
        "responseFormat": "Text",
        "value": ""
      },
      {
        "name": "Note",
        "internalName": "notes",
        "questionFormat": "TextField",
        "responseFormat": "Text",
        "value": ""
      }
    ],
    "pickUp": [
      {
        "name": "Name",
        "internalName": "firstName",
        "questionFormat": "TextField",
        "responseFormat": "Text",
        "value": ""
      },
      {
        "name": "Address 1",
        "internalName": "address1",
        "questionFormat": "TextField",
        "responseFormat": "Text",
        "value": ""
      },
      {
        "name": "Address 2",
        "internalName": "address2",
        "questionFormat": "TextField",
        "responseFormat": "Text",
        "value": ""
      },
      {
        "name": "City",
        "internalName": "city",
        "questionFormat": "TextField",
        "responseFormat": "Text",
        "value": ""
      },
      {
        "name": "State 2-letter abbreviation",
        "internalName": "state",
        "questionFormat": "StatePicker",
        "responseFormat": "Text",
        "value": ""
      },
      {
        "name": "Zipcode",
        "internalName": "zipCode",
        "questionFormat": "TextField",
        "responseFormat": "Text",
        "value": ""
      },
      {
        "name": "Phone number",
        "internalName": "phone",
        "questionFormat": "TextField",
        "responseFormat": "Text",
        "value": ""
      }
    ],
    "dropOff": [
      {
        "name": "Name",
        "internalName": "firstName",
        "questionFormat": "TextField",
        "responseFormat": "Text",
        "value": ""
      },
      {
        "name": "Address 1",
        "internalName": "address1",
        "questionFormat": "TextField",
        "responseFormat": "Text",
        "value": ""
      },
      {
        "name": "Address 2",
        "internalName": "address2",
        "questionFormat": "TextField",
        "responseFormat": "Text",
        "value": ""
      },
      {
        "name": "City",
        "internalName": "city",
        "questionFormat": "TextField",
        "responseFormat": "Text",
        "value": ""
      },
      {
        "name": "State 2-letter abbreviation",
        "internalName": "state",
        "questionFormat": "StatePicker",
        "responseFormat": "Text",
        "value": ""
      },
      {
        "name": "Zipcode",
        "internalName": "zipCode",
        "questionFormat": "TextField",
        "responseFormat": "Text",
        "value": ""
      },
      {
        "name": "Phone number",
        "internalName": "phone",
        "questionFormat": "TextField",
        "responseFormat": "Text",
        "value": ""
      }
    ]
  };

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
    // request['broker'] = "GATowing";
    return request;
  }
}
