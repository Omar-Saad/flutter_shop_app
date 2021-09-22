import 'package:flutter_shop_app/models/product_model.dart';

class HomeModel {
  bool status;
  HomeDataModel data;

  HomeModel.fromJson(Map<String,dynamic> json){
    status = json['status'];
    data = HomeDataModel.fromJson(json['data']);
  }
}

class HomeDataModel{
  List<BannerModel> banners = [];
  List<ProductModel> products = [];

  HomeDataModel.fromJson(Map<String,dynamic> json){

     json['banners'].forEach((element){
       banners.add(BannerModel.fromJson(element));
     });
     json['products'].forEach((element){
       products.add(ProductModel.fromJson(element));
     });
  }
}



class BannerModel {
  int id;
  String image;
  BannerModel.fromJson(Map<String,dynamic> json){
    id = json['id'];
    image = json['image'];
  }
}