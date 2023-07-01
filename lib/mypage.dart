import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shrine/supplemental/detail.dart';
import 'model/products_repository.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyPageState();
}

class MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('My Page'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            ClipOval(
              clipper: MyClipper(),
              child: Lottie.network(
                'https://assets8.lottiefiles.com/packages/lf20_HX0isy.json',
                width: 220,
                height: 220,
              ),
            ),
            Text('DH Park', style: theme.textTheme.titleSmall),
            Text('21800266', style: theme.textTheme.bodySmall),
            const SizedBox(
              height: 16.0,
            ),
            Text(
              'MY FAVORITE HOTEL LIST',
              style: theme.textTheme.titleLarge,
            ),
            // Expanded(
            //   child: favoriteList.isEmpty
            //       ? const Center(
            //           child: Text("No there is element in favorite list!"),
            //         )
            //       : ListView.builder(
            //           itemCount: favoriteList.length,
            //           itemBuilder: (context, index) {
            //             return InkWell(
            //               onTap: () {
            //                 Navigator.pushNamed(context, '/detail',
            //                     arguments: ProductArguments(
            //                         favoriteList[index], favoriteList));
            //               },
            //               child: Stack(
            //                 children: [
            //                   SizedBox(
            //                     height: 200,
            //                     width: double.infinity,
            //                     child: Card(
            //                       semanticContainer: true,
            //                       clipBehavior: Clip.antiAliasWithSaveLayer,
            //                       shape: RoundedRectangleBorder(
            //                         borderRadius: BorderRadius.circular(10.0),
            //                       ),
            //                       elevation: 5,
            //                       margin: const EdgeInsets.all(10),
            //                       // child: Image.network(
            //                       //   favoriteList[index].imageLink,
            //                       //   fit: BoxFit.cover,
            //                       // ),
            //                     ),
            //                   ),
            //                   Positioned(
            //                     top: 130,
            //                     right: size.width * 0.47,
            //                     child: SizedBox(
            //                       width: 200,
            //                       child: Column(
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                         children: [
            //                           // Text(
            //                           //   favoriteList[index].name,
            //                           //   style: theme.textTheme.titleLarge!
            //                           //       .copyWith(
            //                           //     color: Colors.white,
            //                           //     fontWeight: FontWeight.bold,
            //                           //   ),
            //                           // ),
            //                         ],
            //                       ),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             );
            //           },
            //         ),
            // ),
          ],
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromCenter(
        center: Offset(size.width / 2, 120), width: 200, height: 200);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return false;
  }
}
