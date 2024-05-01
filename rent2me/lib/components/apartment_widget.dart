import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rent2me/components/custom_button.dart';
import 'package:rent2me/constants.dart';
import 'package:rent2me/screens/chat_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Apartment extends StatelessWidget {
  Apartment(
      {this.imageUrl,
      this.description,
      this.carBrand,
      this.carModel,
      this.lisencePlate,
      this.fuelType,
      this.color,
      this.CHATFLAG = false,
      this.year,
      this.docId,
      this.userId,
      this.matloop,
      this.price});

  String? description;
  String? carBrand;
  String? carModel;
  String? lisencePlate;
  String? fuelType;
  String? imageUrl;
  String? matloop;
  String? year;
  String? color;
  String? price;
  String? docId;
  String? userId;
  bool CHATFLAG;
  @override
  Widget build(BuildContext context) {
    if (CHATFLAG) {
      return chatFlag2(
          imageUrl: imageUrl,
          carBrand: carBrand,
          year: year,
          color: color,
          fuelType: fuelType,
          lisencePlate: lisencePlate,
          carModel: carModel,
          price: price,
          docId: docId,
          userId: userId);
    } else {
      return chatFlag(
        imageUrl: imageUrl,
        carBrand: carBrand,
        year: year,
        color: color,
        fuelType: fuelType,
        lisencePlate: lisencePlate,
        carModel: carModel,
        price: price,
      );
    }
  }
}

class chatFlag2 extends StatelessWidget {
  const chatFlag2({
    super.key,
    required this.imageUrl,
    required this.carBrand,
    required this.year,
    required this.color,
    required this.fuelType,
    required this.lisencePlate,
    required this.carModel,
    required this.price,
    required this.docId,
    required this.userId,
  });

  final String? imageUrl;
  final String? carBrand;
  final String? year;
  final String? color;
  final String? fuelType;
  final String? lisencePlate;
  final String? carModel;
  final String? price;
  final String? docId;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 10,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: imageUrl != ''
                  ? Container(
                      width: 80.w,
                      height: 25.h,
                      child: Image.network(
                        fit: BoxFit.fitWidth,
                        imageUrl!,
                      ),
                    )
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      '${carBrand!}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17.sp,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      child: Center(
                        child: Text(
                          year!,
                          style: TextStyle(fontSize: 13.sp),
                        ),
                      ),
                      width: 16.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.palette_sharp,
                          color: kPrimaryColor,
                        ),
                        Text('${color!}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.solar_power,
                          color: kPrimaryColor,
                        ),
                        Text('${fuelType!}'),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.label,
                          color: kPrimaryColor,
                        ),
                        Text('${lisencePlate!}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.king_bed,
                          color: kPrimaryColor,
                        ),
                        Text('${carModel!}'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Divider(
              indent: 20,
              endIndent: 20,
              thickness: 2,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '\$${price}',
                    style: TextStyle(
                      fontSize: 23.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '/month',
                    style: TextStyle(
                      fontSize: 15.sp,
                    ),
                  ),
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: customButton(
                      width: 20.w,
                      height: 4.h,
                      color: kPrimaryColor,
                      onPressed: () {
                        Navigator.pushNamed(context, chatPage.id,
                            arguments: [imageUrl, docId, userId]);
                      },
                      texts: [
                        Text(
                          'Rent Now',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class chatFlag extends StatelessWidget {
  const chatFlag({
    super.key,
    required this.imageUrl,
    required this.carBrand,
    required this.year,
    required this.color,
    required this.fuelType,
    required this.lisencePlate,
    required this.carModel,
    required this.price,
  });

  final String? imageUrl;
  final String? carBrand;
  final String? year;
  final String? color;
  final String? fuelType;
  final String? lisencePlate;
  final String? carModel;
  final String? price;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 10,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: imageUrl != ''
                  ? Container(
                      width: 80.w,
                      height: 25.h,
                      child: Image.network(
                        fit: BoxFit.fitWidth,
                        imageUrl!,
                      ),
                    )
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      '${carBrand!}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17.sp,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      child: Center(
                        child: Text(
                          year!,
                          style: TextStyle(fontSize: 13.sp),
                        ),
                      ),
                      width: 16.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.palette_sharp,
                          color: kPrimaryColor,
                        ),
                        Text('${color!}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.solar_power,
                          color: kPrimaryColor,
                        ),
                        Text('${fuelType!}'),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.label,
                          color: kPrimaryColor,
                        ),
                        Text('${lisencePlate!}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.king_bed,
                          color: kPrimaryColor,
                        ),
                        Text('${carModel!}'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Divider(
              indent: 20,
              endIndent: 20,
              thickness: 2,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '\$${price}',
                    style: TextStyle(
                      fontSize: 23.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '/month',
                    style: TextStyle(
                      fontSize: 15.sp,
                    ),
                  ),
                  //   Container(
                  //     clipBehavior: Clip.hardEdge,
                  //     decoration:
                  //         BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  //     child: customButton(
                  //       width: 20.w,
                  //       height: 4.h,
                  //       color: kPrimaryColor,
                  //       onPressed: () {
                  //         Navigator.pushNamed(context, chatPage.id,
                  //             arguments: [imageUrl, docId, userId]);
                  //       },
                  //       texts: [
                  //         Text(
                  //           'Rent Now',
                  //           style: TextStyle(
                  //             fontSize: 13.sp,
                  //             color: Colors.white,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
