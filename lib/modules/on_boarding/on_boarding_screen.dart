import 'package:flutter/material.dart';
import 'package:flutter_shop_app/modules/login/login_screen.dart';
import 'package:flutter_shop_app/shared/components/components.dart';
import 'package:flutter_shop_app/shared/network/local/cache_helper.dart';
import 'package:flutter_shop_app/shared/style/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardingController = PageController();

  List<OnBoardingModel> boardingModels = [
    OnBoardingModel(
        image: 'assets/images/onboarding_1.png',
        title: 'Welcome!',
        body: 'Get More Pay Less'),
    OnBoardingModel(
        image: 'assets/images/onboarding_1.png',
        title: 'Best Shopping Experience',
        body: 'Explore our Products - Add to Cart - Pay - Done... '),
    OnBoardingModel(
        image: 'assets/images/onboarding_1.png',
        title: 'Join Us Now ',
        body: 'Login or SignUp to explore our new offers ')
  ];


  bool isLast = false ;

  void finishOnBoarding(){
    CacheHelper.setData(key: 'isOnBoarding', value: false).then((value) {
      if(value)
        navigateAndFinish(context: context, widget: LoginScreen());

    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(onPressed: (){
            finishOnBoarding();
          }, child: Text('SKIP'),),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Expanded(
             child: PageView.builder(
                 itemBuilder: (context, index) {
                   return buildOnBoardingItem(model: boardingModels[index]);
                 },
             physics: BouncingScrollPhysics(),
               controller: boardingController,
               itemCount: boardingModels.length,
               onPageChanged: (value) {
                 if(value == boardingModels.length-1)
                   {
                     setState(() {
                       isLast = true;
                     });}
                     else{
                       setState(() {
                         isLast = false;
                       });
                   }
               },
             ),
           ),
            SizedBox(
              height: 15.0,
            ),
            Row(
              children: [
               SmoothPageIndicator(
                   controller: boardingController,
                   count: boardingModels.length,
                 effect: ExpandingDotsEffect(
                   activeDotColor: defaultColor,
                   expansionFactor: 4,
                   dotWidth: 10.0,
                   dotHeight: 10.0,
                   spacing: 5.0,
                 ),
               ),
                Spacer(),
                FloatingActionButton(onPressed: () {
                  if(isLast == true){
                    finishOnBoarding();
                  }
                  else{
                  boardingController.nextPage(duration: Duration(
                    milliseconds: 750,
                  ),
                      curve: Curves.decelerate);}
                },
                child: Icon(Icons.arrow_forward_ios),)

              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOnBoardingItem ({@required OnBoardingModel model})=>Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Image(
          image: AssetImage('${model.image}',),
          width: double.infinity,
        ),
      ),
      SizedBox(
        height: 0.0,
      ),
      Text('${model.title}',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),),
      SizedBox(
        height: 15.0,
      ),
      Text('${model.body}',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),),

    ],
  );
}

class OnBoardingModel {
  final String image;
  final String title;
  final String body;

  OnBoardingModel({
    @required  this.image,
    @required  this.title,
    @required  this.body});

}
