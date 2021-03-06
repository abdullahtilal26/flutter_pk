import 'package:cloud_firestore/cloud_firestore.dart';

class UserCache {
  InAppUser _user;

  InAppUser get user => _user;

  Future<InAppUser> getUser(String id, {bool useCached = true}) async {
    if (_user != null && useCached) {
      return _user;
    }
    _user = InAppUser.fromSnapshot(
        await FirebaseFirestore.instance.collection('users').document(id).get());
    return _user;
  }

  void clear() => _user = null;
}

class InAppUser {
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final String mobileNumber;
  final bool isRegistered;
  final bool isContributor;
  final bool isPresent;
  final DocumentReference reference;

  Contribution contribution;

  InAppUser({
    this.name,
    this.id,
    this.email,
    this.reference,
    this.photoUrl,
    this.isRegistered = false,
    this.isContributor = false,
    this.isPresent = false,
    this.mobileNumber,
  });

  InAppUser.fromMap(Map<String, dynamic> map, {this.reference})
      : id = map['id'],
        name = map['name'],
        email = map['email'],
        photoUrl = map['photoUrl'],
        isRegistered = map['isRegistered'],
        isContributor = map['isContributor'],
        isPresent = map['isPresent'],
        mobileNumber = map['mobileNumber'] {
    if (isContributor) contribution = Contribution.fromMap(map['contribution']);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "photoUrl": photoUrl,
        "isRegistered": isRegistered,
        "mobileNumber": mobileNumber,
        "isPresent": isPresent,
        "isContributor": isContributor
      };

  InAppUser.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}

class Contribution {
  final bool isVolunteer;
  final bool isLogisticsAdministrator;
  final bool isSpeaker;
  final bool isSocialMediaMarketingPerson;

  Contribution({
    this.isSocialMediaMarketingPerson,
    this.isLogisticsAdministrator,
    this.isSpeaker,
    this.isVolunteer,
  });

  Contribution.fromMap(Map<dynamic, dynamic> map)
      : isSpeaker = map['speaker'],
        isSocialMediaMarketingPerson = map['socialMediaMarketing'],
        isLogisticsAdministrator = map['administrationAndLogistics'],
        isVolunteer = map['volunteer'];

  Map<String, dynamic> toJson() => {
        "socialMediaMarketing": isSocialMediaMarketingPerson,
        "speaker": isSpeaker,
        "administrationAndLogistics": isLogisticsAdministrator,
        "volunteer": isVolunteer
      };
}
