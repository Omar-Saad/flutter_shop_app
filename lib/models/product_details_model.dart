import 'package:flutter_shop_app/models/product_model.dart';

class ProductDetailsModel {
  bool status;
  ProductModel data;

  ProductDetailsModel.fromJson(Map<String,dynamic> json){
    status = json['status'];
    data = ProductModel.fromJson(json['data']);
  }
}




