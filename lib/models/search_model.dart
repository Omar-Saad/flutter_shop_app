

import 'package:flutter_shop_app/models/product_model.dart';


class SearchModel {
  bool status;
  SearchDataModel data;

  SearchModel.fromJson(Map<String , dynamic> json){
    status = json['status'];
    data = SearchDataModel.fromJson(json['data']);
  }
}

class SearchDataModel {
  List<ProductModel> data = [];

  SearchDataModel.fromJson(Map<String, dynamic> json){
     json['data'].forEach((element){
       data.add(ProductModel.fromJson(element));
     });
  }
}





