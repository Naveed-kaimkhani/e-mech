import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_mech/data/firebase_user_repository.dart';
import 'package:e_mech/presentation/seller_screens/seller_navigation.dart';
import 'package:e_mech/presentation/widgets/auth_button.dart';
import 'package:e_mech/presentation/widgets/circle_progress.dart';
import 'package:e_mech/presentation/widgets/profile_pic.dart';
import 'package:e_mech/style/styling.dart';
import 'package:e_mech/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/seller_model.dart';
import '../../domain/entities/user_model.dart';
import '../../providers/seller_provider.dart';
import '../../style/custom_text_style.dart';
import '../../utils/storage_services.dart';
import '../../providers/user_provider.dart';
import '../widgets/inputfields.dart';
import '../widgets/user_screen_widget/services_n_setting_header.dart';

class SellerProfile extends StatefulWidget {
  SellerProfile({Key? key}) : super(key: key);

  @override
  State<SellerProfile> createState() => _SellerProfileState();
}

class _SellerProfileState extends State<SellerProfile> {
  @override
  void initState() {
    _nameController.text = "";
    _nameController.selection = TextSelection.fromPosition(
        TextPosition(offset: _nameController.text.length));

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    nameFocusNode.dispose();
    phoneFocusNode.dispose();
    cityFocusNode.dispose();
    _phoneController.dispose();
    _cityController.dispose();
  }

  bool isLoadingNow = false;
  Uint8List? _profileImage;
  FocusNode nameFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode cityFocusNode = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  final FirebaseUserRepository _FirebaseUserRepository =
      FirebaseUserRepository();
  EdgeInsetsGeometry k = EdgeInsets.only(
    left: 10.h,
    right: 10.h,
    // top: 10.h,
  );
  final users = FirebaseFirestore.instance.collection('sellers');
  SellerModel? user;
  Future<String> updateProfile() async {
    String profileUrl = await _FirebaseUserRepository.uploadProfileImage(
        imageFile: _profileImage!, uid: utils.currentUserUid);
    return profileUrl;
  }

  void isLoading(bool value) {
    setState(() {
      isLoadingNow = value;
    });
  }

  Future<void> updateData() {
    final uid = utils.currentUserUid;
    if (_profileImage != null) {
      updateProfile()
          .then((url) => {
                users.doc(uid).update({
                  "profileImage": url,
                }),
                debugPrint('Data updated'),
              })
          .onError((error, stackTrace) => {
                utils.flushBarErrorMessage(error.toString(), context),
                isLoading(false),
              });
    }

    return users
        .doc(uid)
        .update({
          "name":
              _nameController.text.isEmpty ? user!.name : _nameController.text,
          "phone": _phoneController.text.isEmpty
              ? user!.phone
              : _phoneController.text,
          "service": _cityController.text.isEmpty
              ? user!.service
              : _cityController.text,
        })
        .then((value) => {
              isLoading(false),
              utils.toastMessage('Profile Updated'),
            })
        .onError((error, stackTrace) => {
              isLoading(false),
              utils.flushBarErrorMessage(error.toString(), context),
            });
  }

  Future<void> _getUserDetails(String uid) async {
    _FirebaseUserRepository.getSeller().then((SellerModel? userModel) {
      if (userModel != null) {
        StorageService.saveSeller(userModel).then((value) async {
          await Provider.of<SellerProvider>(context, listen: false)
              .getSellerFromServer(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const SellerNavigation();
          }));
        }).catchError((error) {
          isLoading(false);
          utils.flushBarErrorMessage(error.message.toString(), context);
        });
      } else {
        isLoading(false);
        utils.flushBarErrorMessage("User is null", context);
      }
    }).catchError((error) {
      isLoading(false);
      utils.flushBarErrorMessage(error.message.toString(), context);
    });
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<SellerProvider>(context, listen: false).seller;
    return SafeArea(
      top: false,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ServicesNSettingHeader(
                    text: "Personal Data", icon: Icons.account_circle_outlined),
                SizedBox(
                  height: 21.h,
                ),
                Center(
                  child: UploadProfile(_profileImage),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Center(
                  child: AbsorbPointer(
                    child: SizedBox(
                      height: 25,
                      child: FittedBox(
                        child: RatingBar(
                          ratingWidget: RatingWidget(
                            full: Icon(
                              Icons.star_rate_rounded,
                              color: Colors.amber.shade600,
                              size: 8,
                            ),
                            half: Icon(
                              Icons.star_half_rounded,
                              color: Colors.amber.shade600,
                              size: 8,
                            ),
                            empty: Icon(
                              Icons.star_border_rounded,
                              color: Colors.grey,
                              size: 8,
                            ),
                          ),
                          initialRating: user != null ? user!.rating ?? 0 : 0,
                          onRatingUpdate: (v) {},
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Center(
                    child: Text(
                        "(" + (user!.numberOfRatings ?? 0).toString() + ")")),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Your Name",
                    style:
                        TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: 7.h,
                ),
                Padding(
                  padding: k,
                  child: InputField(
                    currentNode: nameFocusNode,
                    focusNode: nameFocusNode,
                    nextNode: cityFocusNode,
                    hint_text: user!.name!,
                    controller: _nameController,
                  ),
                ),
                SizedBox(
                  height: 19.h,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Service",
                    style:
                        TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w700),
                  ),
                ),
                Padding(
                  padding: k,
                  child: InputField(
                    currentNode: cityFocusNode,
                    focusNode: cityFocusNode,
                    nextNode: phoneFocusNode,
                    hint_text: user!.service,
                    controller: _cityController,
                  ),
                ),
                SizedBox(
                  height: 11.h,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "phone",
                    style:
                        TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: 7.h,
                ),
                Padding(
                  padding: k,
                  child: InputField(
                    currentNode: phoneFocusNode,
                    focusNode: phoneFocusNode,
                    nextNode: phoneFocusNode,
                    hint_text: user!.phone!,
                    controller: _phoneController,
                  ),
                ),
                SizedBox(
                  height: 35.h,
                ),
                Center(
                    child: isLoadingNow
                        ? const CircleProgress()
                        : AuthButton(
                            func: () async {
                              utils.checkConnectivity(context);
                              isLoading(true);
                              await updateData();
                              await _getUserDetails(
                                  FirebaseAuth.instance.currentUser!.uid);
                              isLoading(false);
                            },
                            text: 'Save Changes',
                            color: Styling.primaryColor,
                          )),
              ],
            ),
          )),
    );
  }

  Widget UploadProfile(Uint8List? image) {
    return image == null
        ? Stack(
            children: [
              // ProfilePic(url: url, height: height, width: width)
              ProfilePic(url: user!.profileImage!, height: 82.h, width: 94.w),

              Positioned(
                left: 45.w,
                bottom: 0.h,
                child: IconButton(
                  onPressed: () async {
                    Uint8List? _image = await utils.pickImage();
                    if (_image != null) {
                      setState(() {
                        _profileImage = _image;
                      });
                    } else {
                      debugPrint("Image not loaded");
                    }
                  },
                  icon: Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: Styling.primaryColor,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: Image.asset('assets/gallery.png'),
                    ),
                  ),
                ),
              ),
            ],
          )
        : Stack(
            children: [
              ClipOval(
                child: Image.memory(
                  image,
                  height: 200.h,
                  width: 200.w,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 45.w,
                bottom: 0.h,
                child: IconButton(
                  onPressed: () async {
                    Uint8List? _image = await utils.pickImage();
                    if (_image != null) {
                      setState(() {
                        image = _image;
                      });
                    } else {
                      debugPrint("Image not loaded");
                    }
                  },
                  icon: Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: Styling.primaryColor,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: Image.asset('assets/gallery.png'),
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100.h,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top: 45, left: 50),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 25.w,
            ),
            Text(
              "Update Profile",
              style: CustomTextStyle.font_25,
            ),
          ],
        ));
  }
}
