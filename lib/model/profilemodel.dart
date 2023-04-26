class Profilemodel {
  final String firstname;
  final String lastname;
  final String city;
  final String about;
  final String userEmail;
  final dynamic userProfilePic;

  Profilemodel({
    required this.firstname,
    required this.lastname,
    required this.city,
    required this.about,
    required this.userEmail,
    required this.userProfilePic,
  });

  Profilemodel.fromJson(Map<String, dynamic> json)
      : firstname = json['firstname'] as String,
        lastname = json['lastname'] as String,
        city = json['city'] as String,
        about = json['about'] as String,
        userEmail = json['user_email'] as String,
        userProfilePic = json['user_profile_pic'];

  Map<String, dynamic> toJson() => {
        'firstname': firstname,
        'lastname': lastname,
        'city': city,
        'about': about,
        'user_email': userEmail,
        'user_profile_pic': userProfilePic
      };
}
