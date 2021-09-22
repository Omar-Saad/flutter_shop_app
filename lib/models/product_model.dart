class ProductModel {
  int id;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;
  String image;
  List<String> images=[];
  String name;
  String description;
  bool inFavourite;
  bool inCart;
  ProductModel.fromJson(Map<String,dynamic> json){
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    json['images']!=null ? json['images'].forEach((element){
      images.add(element);
    }):null;
    name = json['name'];
    description = json['description'];
    inFavourite = json['in_favorites'];
    inCart = json['in_cart'];

  }
}