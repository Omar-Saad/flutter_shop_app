

import 'package:flutter_shop_app/models/product_model.dart';


class CategoriesDetailsModel {
  bool status;
  CategoriesDetailsDataModel data;

  CategoriesDetailsModel.fromJson(Map<String , dynamic> json){
    status = json['status'];
    data = CategoriesDetailsDataModel.fromJson(json['data']);
  }
}

class CategoriesDetailsDataModel {
  List<ProductModel> data = [];

  CategoriesDetailsDataModel.fromJson(Map<String, dynamic> json){
     json['data'].forEach((element){
       data.add(ProductModel.fromJson(element));
     });
  }
}





