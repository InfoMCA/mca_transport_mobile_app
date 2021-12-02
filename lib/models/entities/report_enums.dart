import 'package:transportation_mobile_app/models/entities/session.dart';

enum ReportTabs {
  PickUp,
  DropOff,
}

extension ReportCTabsExtension on ReportTabs {
  String getName() {
    switch (this) {
      case ReportTabs.PickUp:
        return "Pick-up Information";
      case ReportTabs.DropOff:
        return "Drop-off Information";
      default:
        return "";
    }
  }

  bool canUserEditTab(SessionStatus sessionStatus) {
    switch (this) {
      case ReportTabs.PickUp:
        return sessionStatus == SessionStatus.DISPATCHED ||
            sessionStatus == SessionStatus.STARTED;
      case ReportTabs.DropOff:
        return sessionStatus == SessionStatus.PICKUP ||
            sessionStatus == SessionStatus.TRANSFERRING;
      default:
        return false;
    }
  }
}

enum ReportCategories {
  PickupPictures,
  PickupSignature,
  DropOffPictures,
  DropOffSignature,
}

extension ReportCategoriesExtension on ReportCategories {
  String getName() {
    switch (this) {
      case ReportCategories.PickupPictures:
        return "Pick-up Pictures";
      case ReportCategories.PickupSignature:
        return "Pick-up Signature";
      case ReportCategories.DropOffPictures:
        return "Drop-off Pictures";
      case ReportCategories.DropOffSignature:
        return "Drop-off Signature";
      default:
        return "";
    }
  }

  String getTitle() {
    switch (this) {
      case ReportCategories.PickupPictures:
      case ReportCategories.DropOffPictures:
        return "Pictures";
      case ReportCategories.PickupSignature:
      case ReportCategories.DropOffSignature:
        return "Signature";
      default:
        return "";
    }
  }

  bool canUserEditTab(SessionStatus sessionStatus) {
    switch (this) {
      case ReportCategories.PickupPictures:
      case ReportCategories.PickupSignature:
        return sessionStatus == SessionStatus.DISPATCHED ||
            sessionStatus == SessionStatus.STARTED;
      case ReportCategories.DropOffPictures:
      case ReportCategories.DropOffSignature:
        return sessionStatus == SessionStatus.PICKUP ||
            sessionStatus == SessionStatus.TRANSFERRING;
      default:
        return false;
    }
  }

  bool isTabFilled(SessionStatus sessionStatus) {
    switch (this) {
      case ReportCategories.PickupPictures:
      case ReportCategories.PickupSignature:
        return sessionStatus.index >= SessionStatus.PICKUP.index;
      case ReportCategories.DropOffPictures:
      case ReportCategories.DropOffSignature:
        return sessionStatus.index >= SessionStatus.DROPPED.index;
      default:
        return false;
    }
  }

  ReportCategories getNextPage() {
    switch (this) {
      case ReportCategories.PickupPictures:
        return ReportCategories.PickupSignature;
      case ReportCategories.DropOffPictures:
        return ReportCategories.DropOffSignature;
      case ReportCategories.PickupSignature:
      case ReportCategories.DropOffSignature:
        return this;
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
  Registration,
  BillOfLading,
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
      case ReportCategoryItems.BillOfLading:
        return "BillOfLading";
      default:
        return "";
    }
  }
}
