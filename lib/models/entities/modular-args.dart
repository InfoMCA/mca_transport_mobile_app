import 'package:transportation_mobile_app/models/entities/inspection_item.dart';

class PhotoDetailsArgs {
  bool isEditable;
  InspectionItem item;

  PhotoDetailsArgs(this.item, this.isEditable);
}
