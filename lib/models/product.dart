class Product {
  String uid;
  String category;
  String title;
  String price;
  String branch;
  String sem;
  String subject;
  String description;
  String condition;
  String iUsedItFor;
  List<dynamic> pictureUrls;
  String sellerUid;
  String sellerName;
  String sellerCollege;
  String sellerSem;
  String sellerDeviceToken;

  String sellerBranch;
  String sellerImage;
  String sellerPhone;
  bool isAvailable;

  String dateTime;

  Product({
    this.uid,
    this.category,
    this.title,
    this.price,
    this.branch,
    this.sem,
    this.description,
    this.pictureUrls,
    this.sellerUid,
    this.sellerName,
    this.sellerBranch,
    this.sellerImage,
    this.isAvailable = true,
    this.condition,
    this.iUsedItFor,
    this.sellerPhone,
    this.subject,
    this.sellerCollege,
    this.sellerSem,
    this.sellerDeviceToken,
    this.dateTime,
  });

  Map<String, dynamic> toProductMap() {
    return {
      'uid': uid,
      'category': category,
      'title': title,
      'price': price,
      'branch': branch,
      'sem': sem,
      'description': description,
      'pictureUrls': pictureUrls,
      'sellerUid': sellerUid,
      'sellerName': sellerName,
      'sellerBranch': sellerBranch,
      'sellerCollege': sellerCollege,
      'sellerSem': sellerSem,
      'sellerImage': sellerImage,
      'sellerDeviceToken': sellerDeviceToken,
      'isAvailable': isAvailable,
      'condition': condition,
      'iUsedItFor': iUsedItFor,
      'sellerPhone': sellerPhone,
      'subject': subject,
      'dateTime': dateTime,
    };
  }

  void toProductObject(Map<String, dynamic> data) {
    this.uid = data['uid'];
    this.category = data['category'];
    this.title = data['title'];
    this.price = data['price'];
    this.branch = data['branch'];
    this.sem = data['sem'];
    this.description = data['description'];
    this.pictureUrls = data['pictureUrls'];
    this.sellerUid = data['sellerUid'];
    this.sellerName = data['sellerName'];
    this.sellerBranch = data['sellerBranch'];
    this.sellerCollege = data['sellerCollege'];
    this.sellerSem = data['sellerSem'];
    this.sellerImage = data['sellerImage'];
    this.sellerDeviceToken = data['sellerDeviceToken'];
    this.isAvailable = data['isAvailable'];
    this.condition = data['condition'];
    this.iUsedItFor = data['iUsedItFor'];
    this.sellerPhone = data['sellerPhone'];
    this.subject = data['subject'];
    this.dateTime = data['dateTime'];
  }
}
