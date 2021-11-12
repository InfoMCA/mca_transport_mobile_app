
class Address {
  String address1;
  String address2;
  String city;
  String state;
  String zipCode;
  String phone;
  String email;
  double lat;
  double lng;

  Address({
    this.address1,
    this.address2,
    this.city,
    this.state,
    this.zipCode,
    this.phone,
    this.email,
    this.lat,
    this.lng
  });

  factory Address.fromJson(dynamic json) {
    return Address(
        address1: json['address1'] as String,
        address2: json['address2'] as String,
        city: json['city'] as String,
        state: json['state'] as String,
        zipCode: json['zipCode'] as String,
        phone: json['phone'] as String,
        email: json['email'] as String,
        lat: json['lat'] as double,
        lng: json['lng'] as double
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address1': address1,
      'address2': address2,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'phone': phone,
      'email': email,
      'lat': lat,
      'lng': lng,
    };
  }

  String toString() {
    return [this.address1, this.address2, this.city, this.state, this.zipCode]
        .where((element) => element != null && element.isNotEmpty).join(", ");
  }

  String toStringShort() {
    return [this.address1, this.address2, this.city]
        .where((element) => element != null && element.isNotEmpty).join(", ");
  }
}
