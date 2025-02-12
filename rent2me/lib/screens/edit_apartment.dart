import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rent2me/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rent2me/components/custom_button.dart';
import 'package:rent2me/components/custom_text_form_field.dart';
import 'package:rent2me/screens/my_apartments.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditApartment extends StatefulWidget {
  const EditApartment(
      {this.olddescription,
      this.oldcarBrand,
      this.oldcarModel,
      this.oldlisencePlate,
      this.oldfuelType,
      this.oldimageUrl,
      this.oldmatloop,
      this.oldyear,
      this.oldcolor,
      this.oldprice,
      this.olddocId,
      this.olduserId});
  static String id = 'EditApartment';
  final String? olddescription;
  final String? oldcarBrand;
  final String? oldcarModel;
  final String? oldlisencePlate;
  final String? oldfuelType;
  final String? oldimageUrl;
  final String? oldmatloop;
  final String? oldyear;
  final String? oldcolor;
  final String? oldprice;
  final String? olddocId;
  final String? olduserId;

  @override
  State<EditApartment> createState() => _AddApartmwntState();
}

class _AddApartmwntState extends State<EditApartment> {
  bool isLoading = false;
  TextEditingController? description = TextEditingController();
  TextEditingController? fuelType = TextEditingController();
  TextEditingController? price = TextEditingController();
  TextEditingController? carModel = TextEditingController();
  TextEditingController? carBrand = TextEditingController();
  TextEditingController? color = TextEditingController();
  TextEditingController? lisencePlate = TextEditingController();
  TextEditingController? year = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  File? _selectedImage;
  CollectionReference apartment =
      FirebaseFirestore.instance.collection('apartments');

  @override
  void initState() {
    super.initState();
    carBrand!.text = widget.oldcarBrand!;
  }

  Future<void> editapartment() {
    return apartment
        .doc(widget.olddocId)
        .update({
          'Price': (price?.text) == '' ? widget.oldprice : price!.text,
          'car brand':
              (carBrand?.text) == '' ? widget.oldcarBrand : carBrand!.text,
          'car model':
              (carModel?.text) == '' ? widget.oldcarModel : carModel!.text,
          'description': (description?.text) == ''
              ? widget.olddescription
              : description!.text,
          'color': (color?.text) == '' ? widget.oldcolor : color!.text,
          'fuel type':
              (fuelType?.text) == '' ? widget.oldfuelType : fuelType!.text,
          'lisence Plate': (lisencePlate?.text) == ''
              ? widget.oldlisencePlate
              : lisencePlate!.text,
          'year': (year?.text) == '' ? widget.oldyear : year!.text,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryBackgroundColor,
        title: Text(
          'Edit my car ..',
          style: TextStyle(color: kPrimaryColor, fontSize: 20.sp),
        ),
      ),
      body: (isLoading)
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                key: formkey,
                child: ListView(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'choose your car photo....',
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              customButton(
                                onPressed: () {
                                  setState(() {
                                    _pickImaheFromCamera();
                                  });
                                },
                                texts: [
                                  Icon(Icons.camera_alt),
                                ],
                                width: 18.w,
                                color: kPrimaryColor,
                              ),
                              customButton(
                                onPressed: () {
                                  setState(() {
                                    _pickImaheFromGallery();
                                  });
                                },
                                texts: [
                                  Icon(Icons.image),
                                ],
                                width: 18.w,
                                color: kPrimaryColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    customTextFormField(
                        validator: (p0) {
                          if (p0 == '') return 'shoudn\'t empty';
                        },
                        controller: carBrand,
                        text: 'Car Brand'),
                    customTextFormField(
                        validator: (p0) {
                          if (p0 == '') return 'shoudn\'t empty';
                        },
                        controller: carModel,
                        text: 'Car model'),
                    customTextFormField(
                        keyboardType: TextInputType.number,
                        validator: (p0) {
                          if (p0 == '') return 'shoudn\'t empty';
                        },
                        controller: color,
                        text: 'Color'),
                    customTextFormField(
                        validator: (p0) {
                          if (p0 == '') return 'shoudn\'t empty';
                        },
                        controller: lisencePlate,
                        text: 'Lisence Plate'),
                    customTextFormField(
                        validator: (p0) {
                          if (p0 == '') return 'shoudn\'t empty';
                        },
                        controller: year,
                        text: 'Year'),
                    customTextFormField(
                        validator: (p0) {
                          if (p0 == '') return 'shoudn\'t empty';
                        },
                        controller: fuelType,
                        text: 'Fuel Type'),
                    customTextFormField(
                        keyboardType: TextInputType.number,
                        validator: (p0) {
                          if (p0 == '') return 'shoudn\'t empty';
                        },
                        controller: price,
                        text: 'price'),
                    customTextFormField(
                        validator: (p0) {
                          if (p0 == '') return 'shoudn\'t empty';
                        },
                        controller: description,
                        text: 'Add a description about a car'),
                    customButton(
                      onPressed: () async {
                        try {
                          isLoading = true;
                          setState(() {});
                          editapartment();
                          await uploadImageToFirebase(_selectedImage?.path);
                          isLoading = false;
                          setState(() {});
                          Navigator.pop(context);
                        } catch (e) {
                          isLoading = false;
                          setState(() {});
                          print('============$e');
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('You should select a photo')));
                        }
                      },
                      texts: [
                        Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                      color: Colors.black,
                      width: 50.w,
                      height: 5.h,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future _pickImaheFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  Future _pickImaheFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  Future<void> uploadImageToFirebase(String? imagePath) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref().child(fileName);
      await ref.putFile(File(imagePath!));

      String imageUrl = await ref.getDownloadURL();
      print('Image URL: $imageUrl');

      await apartment
          .doc(widget.olddocId)
          .update({
            'imageUrl': imageUrl,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
      print('Image URL stored in Firestore');
    } catch (e) {
      print('Error: $e');
    }
  }
}
