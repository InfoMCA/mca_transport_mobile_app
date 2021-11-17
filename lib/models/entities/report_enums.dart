import 'package:transportation_mobile_app/models/entities/session.dart';

enum ReportCategories {
  PICKUP_PICTURES,
  PICKUP_SIGNATURE,
  PICKUP_BILL,
  DROP_OFF_PICTURES,
  DROP_OFF_SIGNATURE,
  DROP_OFF_BILL
}

extension ReportCategoriesExtension on ReportCategories {
  String getName() {
    switch (this) {
      case ReportCategories.PICKUP_PICTURES:
        return "Pick-up Pictures";
      case ReportCategories.PICKUP_SIGNATURE:
        return "Pick-up Signature";
      case ReportCategories.PICKUP_BILL:
        return "Pick-up Bill of Lading";
      case ReportCategories.DROP_OFF_PICTURES:
        return "Drop-off Pictures";
      case ReportCategories.DROP_OFF_SIGNATURE:
        return "Drop-off Signature";
      case ReportCategories.DROP_OFF_BILL:
        return "Drop-off Bill of Lading";
      default:
        return "";
    }
  }

  bool canUserEditTab(SessionStatus sessionStatus) {
    switch (this) {
      case ReportCategories.PICKUP_PICTURES:
      case ReportCategories.PICKUP_SIGNATURE:
        return sessionStatus == SessionStatus.DISPATCHED ||
            sessionStatus == SessionStatus.STARTED;
      case ReportCategories.PICKUP_BILL:
      case ReportCategories.DROP_OFF_PICTURES:
      case ReportCategories.DROP_OFF_SIGNATURE:
        return sessionStatus == SessionStatus.PICKUP ||
            sessionStatus == SessionStatus.TRANSFERRING;
      case ReportCategories.DROP_OFF_BILL:
      default:
        return false;
    }
  }

  bool isTabFilled(SessionStatus sessionStatus) {
    switch (this) {
      case ReportCategories.PICKUP_PICTURES:
      case ReportCategories.PICKUP_SIGNATURE:
        return sessionStatus.index >= SessionStatus.PICKUP.index;
      case ReportCategories.PICKUP_BILL:
      case ReportCategories.DROP_OFF_PICTURES:
      case ReportCategories.DROP_OFF_SIGNATURE:
        return sessionStatus.index >= SessionStatus.DROPPED.index;
      case ReportCategories.DROP_OFF_BILL:
      default:
        return false;
    }
  }

  ReportCategories getNextPage() {
    switch (this) {
      case ReportCategories.PICKUP_PICTURES:
        return ReportCategories.PICKUP_SIGNATURE;
      case ReportCategories.DROP_OFF_PICTURES:
        return ReportCategories.DROP_OFF_SIGNATURE;
      case ReportCategories.PICKUP_SIGNATURE:
      case ReportCategories.DROP_OFF_SIGNATURE:
        return this;
      case ReportCategories.PICKUP_BILL:
      case ReportCategories.DROP_OFF_BILL:
      default:
        return this;
    }
  }
}

enum ReportCategoryItems {
  VIN,
  Odometer,
  DiagonalFront,
  Front,
  Left,
  Right,
  Back,
  DiagonalBack,
  SignatureImage,
  CustomerName,
  DriverLicense,
  Title,
  Registration
}

extension CategoryNamesExtension on ReportCategoryItems {
  String getName() {
    switch (this) {
      case ReportCategoryItems.VIN:
        return "VIN";
      case ReportCategoryItems.Odometer:
        return "Odometer";
      case ReportCategoryItems.DiagonalFront:
        return "Diagonal Front";
      case ReportCategoryItems.Front:
        return "Front";
      case ReportCategoryItems.Left:
        return "Left";
      case ReportCategoryItems.Right:
        return "Right";
      case ReportCategoryItems.Back:
        return "Back";
      case ReportCategoryItems.DiagonalBack:
        return "Diagonal Back";
      case ReportCategoryItems.SignatureImage:
        return "Signature Image";
      case ReportCategoryItems.CustomerName:
        return "Customer Name";
      case ReportCategoryItems.DriverLicense:
        return "Driver License";
      case ReportCategoryItems.Title:
        return "Title";
      case ReportCategoryItems.Registration:
        return "Registration";
      default:
        return "";
    }
  }
}

// ignore: non_constant_identifier_names
// final Map<ReportCategories, Set<CategoryItems>> ReportCategoriesItems = {
//   ReportCategories.PICKUP_PICTURES: {
//     CategoryItems.VIN,
//     CategoryItems.Odometer,
//     CategoryItems.DiagonalFront,
//     CategoryItems.Front,
//     CategoryItems.Left,
//     CategoryItems.Right,
//     CategoryItems.Back,
//     CategoryItems.DiagonalBack,
//   },
//   ReportCategories.PICKUP_SIGNATURE: {
//     CategoryItems.Signature,
//   },
//   ReportCategories.DROP_OFF_PICTURES: {
//     CategoryItems.Odometer,
//     CategoryItems.DiagonalFront,
//     CategoryItems.Front,
//     CategoryItems.Left,
//     CategoryItems.Right,
//     CategoryItems.Back,
//   },
//   ReportCategories.DROP_OFF_SIGNATURE: {
//     CategoryItems.Signature,
//   },
// };
