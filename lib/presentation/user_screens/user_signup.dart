import 'dart:typed_data';
import 'package:e_mech/presentation/user_screens/home_page.dart';
import 'package:e_mech/presentation/widgets/inputfields.dart';
import 'package:e_mech/presentation/widgets/my_app_bar.dart';
import 'package:e_mech/style/custom_text_style.dart';
import 'package:e_mech/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import '../../data/firebase_user_repository.dart';
import '../../domain/entities/user_model.dart';
import '../../style/styling.dart';
import '../../utils/storage_services.dart';
import '../controllers/user_provider.dart';
import '../widgets/auth_button.dart';

class UserSignup extends StatefulWidget {
  const UserSignup({Key? key}) : super(key: key);

  @override
  State<UserSignup> createState() => _UserSignupState();
}

class _UserSignupState extends State<UserSignup> {
  final FirebaseUserRepository _firebaseUserRepository =
      FirebaseUserRepository();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    utils.checkConnectivity(context);
  }

  FocusNode emailFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();
  FocusNode numberFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmpasswordFocusNode = FocusNode();
  FocusNode cityFocusNode = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();

  bool? obsecureText = true;
  bool isLoadingNow = false;
  bool _obsecureText = true;
  Uint8List? _profileImage;

  @override
  void dispose() {
    confirmpasswordFocusNode.dispose();
    passwordFocusNode.dispose();
    emailFocusNode.dispose();
    nameFocusNode.dispose();
    numberFocusNode.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _numberController.dispose();
    _cityController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

  // void isLoading(bool value) {
  //   setState(() {
  //     isLoadingNow = value;
  //   });
  // }

  void _signup() {
    utils.showLoading(context);
    _firebaseUserRepository
        .signUpUser(
      _emailController.text,
      _passwordController.text,
    )
        .then((User? user) async {
      if (user != null) {
        UserModel userModel = UserModel(
          uid: user.uid,
          name: _nameController.text,
          phone: _numberController.text,
          email: _emailController.text,
          gender: 'male',
          city: _cityController.text,
          profileImage: await _firebaseUserRepository.uploadProfileImage(
              imageFile: _profileImage!, uid: user.uid),
        );
        _saveUser(user, userModel);
      } else {
        // isLoading(false);
        utils.hideLoading();
        utils.flushBarErrorMessage('Failed to Signup', context);
      }
    }).catchError((error) {
      // isLoading(false);
      utils.hideLoading();
      // print(error.message.toString());
      utils.flushBarErrorMessage(error.message.toString(), context);
    });
  }

  void _saveUser(User firebaseUser, UserModel userModel) {
    _firebaseUserRepository
        .saveUserDataToFirestore(userModel)
        .then((value) async {
      await StorageService.saveUser(userModel).then((value) async {
        //await  StorageService.readUser();
        Provider.of<UserProvider>(context, listen: false).getUserLocally();
        // isLoading(false);
        utils.hideLoading();
        // SharedPreferences preferences = await SharedPreferences.getInstance();
        // // initScreen = preferences.getInt('initScreen');
        // await preferences.setInt('initScreen', 1);
        // await preferences.setInt('isUser', 1);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      });
    }).catchError((error) {
      // isLoading(false);
      utils.hideLoading();
      // print(error);
      utils.flushBarErrorMessage(error.message.toString(), context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: MyAppBar(
              text: "Login",
              onSignUpOrLoginPressed: () {},
              onBackButtonPressed: () {}),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 16.h,
                  ),
                  Text("Sign-Up", style: CustomTextStyle.font_30),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text("As a User", style: CustomTextStyle.font_20),
                  uploadProfile(_profileImage),
                  // SizedBox(
                  //   height: 15.16.h,
                  // ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          InputField(
                            hint_text: "Enter name",
                            currentNode: nameFocusNode,
                            focusNode: nameFocusNode,
                            nextNode: numberFocusNode,
                            controller: _nameController,
                            obsecureText: false,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Enter name";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          InputField(
                            hint_text: "Enter email address",
                            currentNode: emailFocusNode,
                            focusNode: emailFocusNode,
                            nextNode: passwordFocusNode,
                            controller: _emailController,
                            obsecureText: false,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Enter email address";
                              } else if (!EmailValidator.validate(value)) {
                                return "Invalid email address";
                              }
                            },
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          InputField(
                            hint_text: "Enter phone number",
                            currentNode: numberFocusNode,
                            focusNode: numberFocusNode,
                            nextNode: cityFocusNode,
                            controller: _numberController,
                            keyboardType: TextInputType.number,
                            obsecureText: false,
                            preicon: SizedBox(
                              width: 60.w,
                              height: 60.h,
                              child: Row(
                                children: [
                                  Text(
                                    "  +92",
                                    style: TextStyle(fontSize: 17.sp),
                                  ),
                                  VerticalDivider(
                                    thickness: 2.r,
                                    color: Colors.grey.shade700,
                                  ),
                                ],
                              ),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Enter phone number";
                              } else if (value.length != 10) {
                                return "Invalid phone number";
                              }
                            },
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          InputField(
                            hint_text: "City",
                            currentNode: emailFocusNode,
                            focusNode: emailFocusNode,
                            nextNode: passwordFocusNode,
                            controller: _emailController,
                            obsecureText: false,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Enter city";
                              }
                            },
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          InputField(
                            hint_text: "Set password",
                            currentNode: passwordFocusNode,
                            focusNode: passwordFocusNode,
                            nextNode: confirmpasswordFocusNode,
                            keyboardType: TextInputType.text,
                            controller: _passwordController,
                            icon: obsecureText!
                                ? Icons.visibility_off
                                : Icons.remove_red_eye,
                            obsecureText: obsecureText,
                            onIconPress: () {
                              setState(() {
                                obsecureText = !obsecureText!;
                              });
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Enter password";
                              } else if (value.length < 6) {
                                return "password must be of 6 characters";
                              }
                            },
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          InputField(
                            hint_text: "Confirm password",
                            currentNode: confirmpasswordFocusNode,
                            focusNode: confirmpasswordFocusNode,
                            nextNode: confirmpasswordFocusNode,
                            controller: _confirmpasswordController,
                            obsecureText: _obsecureText,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Enter password to confirm";
                              } else if (value != _passwordController.text) {
                                return "Password not match";
                              }
                            },
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 31.h,
                  ),
                  AuthButton(
                      text: "Signup",
                      func: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        _signup();
                      },
                      color: Styling.primaryColor),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onIconPress() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  Widget uploadProfile(Uint8List? image) {
    return image == null
        ? Stack(
            children: [
              // Image.network(
              //   "https://m.media-amazon.com/images/I/11uufjN3lYL._SX90_SY90_.png",
              //   height: 60,
              // ),
              // Image.asset(
              //   "asset/avatar.png",
              //   height: 100.h,
              //   width: 100.w,
              // ),
              Icon(Icons.browse_gallery),
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
                      // child: Image.asset('asset/gallery.png'),
                      child: Icon(Icons.browse_gallery),
                    ),
                  ),
                ),
              ),
            ],
          )
        : Stack(
            children: [
              CircleAvatar(
                minRadius: 50.r,
                maxRadius: 50.r,
                child: ClipOval(
                    child: Image.memory(
                  image,
                  height: 200.h,
                  width: 200.w,
                  fit: BoxFit.cover,
                )),
                // child: ,
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
                    }
                    debugPrint("Image not loaded");
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
                      // child: Image.asset('asset/gallery.png'),
                      child: Icon(Icons.browse_gallery),
                    ),
                  ),
                ),
              ),
            ],
          );
  } // for 1st image
}
