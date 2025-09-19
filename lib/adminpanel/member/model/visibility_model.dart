class VisibilityModel {
  final bool showAliveStatus;
  final bool showContact;
  final bool showDOB;
  final bool showSpouse;
  final bool showEmail;
  final bool showBloodGroup;
  final bool showLocation;

  VisibilityModel({
    required this.showAliveStatus,
    required this.showContact,
    required this.showDOB,
    required this.showSpouse,
    required this.showEmail,
    required this.showBloodGroup,
    required this.showLocation,
  });

  factory VisibilityModel.fromJson(Map<String, dynamic> json) {
    return VisibilityModel(
      showAliveStatus: json['showAliveStatus'],
      showContact: json['showContact'],
      showDOB: json['showDOB'],
      showSpouse: json['showSpouse'],
      showEmail: json['showEmail'],
      showBloodGroup: json['showBloodGroup'],
      showLocation: json['showLocation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'showSpouse': showSpouse,
      'showDOB': showDOB,
      'showContact': showContact,
      'showAliveStatus': showAliveStatus,
      'showLocation': showLocation,
      'showBloodGroup': showBloodGroup,
      'showEmail': showEmail,
    };
  }

  VisibilityModel copyWith({
    bool? showAliveStatus,
    bool? showContact,
    bool? showDOB,
    bool? showSpouse,
    bool? showEmail,
    bool? showBloodGroup,
    bool? showLocation,
  }) {
    return VisibilityModel(
      showAliveStatus: showAliveStatus ?? this.showAliveStatus,
      showContact: showContact ?? this.showContact,
      showDOB: showDOB ?? this.showDOB,
      showSpouse: showSpouse ?? this.showSpouse,
      showEmail: showEmail ?? this.showEmail,
      showBloodGroup: showBloodGroup ?? this.showBloodGroup,
      showLocation: showLocation ?? this.showLocation,
    );
  }

  factory VisibilityModel.empty() => VisibilityModel(
    showAliveStatus: true,
    showContact: true,
    showDOB: true,
    showSpouse: true,
    showEmail: true,
    showBloodGroup: true,
    showLocation: true,
  );
}
