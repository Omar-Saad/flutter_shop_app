import 'package:flutter_shop_app/models/product_model.dart';

class FavouritesModel {
  bool status;
  FavouritesDataModel data;

  FavouritesModel.fromJson(Map<String , dynamic> json){
    status = json['status'];
    data = FavouritesDataModel.fromJson(json['data']);
  }
}

class FavouritesDataModel {
  List<DataModel> data = [];

  FavouritesDataModel.fromJson(Map<String, dynamic> json){
     json['data'].forEach((element){
       data.add(DataModel.fromJson(element));
     });
  }
}

class DataModel {
  int id;
  ProductModel product;

  DataModel.fromJson(Map<String , dynamic> json){
    id = json['id'];
    product = ProductModel.fromJson(json['product']);
  }
}


