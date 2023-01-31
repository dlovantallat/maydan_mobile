import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../main.dart';
import '../../utilities/app_utilities.dart';
import '../register/register.dart';
import 'profile.dart';

class ManageSocialMediaScreen extends StatefulWidget {
  final ProfileData profile;

  const ManageSocialMediaScreen({Key? key, required this.profile})
      : super(key: key);

  @override
  State<ManageSocialMediaScreen> createState() =>
      _ManageSocialMediaScreenState();
}

class _ManageSocialMediaScreenState extends State<ManageSocialMediaScreen> {
  MaydanServices get service => GetIt.I<MaydanServices>();
  late ApiResponse<UpdateUser> updateProfile;

  final fbController = TextEditingController();
  final iController = TextEditingController();
  final ytController = TextEditingController();
  final waController = TextEditingController();
  final vController = TextEditingController();

  @override
  void initState() {
    fbController.text = widget.profile.facebook ?? "";
    iController.text = widget.profile.instagram ?? "";
    ytController.text = widget.profile.youtube ?? "";
    waController.text = widget.profile.whatsapp ?? "";
    vController.text = widget.profile.viber ?? "";

    super.initState();
  }

  editProfileFun() async {
    String fb = fbController.text.trim().toString();
    String instagram = iController.text.trim().toString();
    String youtube = ytController.text.trim().toString();

    if (fb.isNotEmpty) {
      if (!Uri.parse(fb).isAbsolute) {
        setSnackBar(context, "url is not right");
        return;
      }
    }

    if (instagram.isNotEmpty) {
      if (!Uri.parse(instagram).isAbsolute) {
        setSnackBar(context, "url is not right");
        return;
      }
    }

    if (youtube.isNotEmpty) {
      if (!Uri.parse(youtube).isAbsolute) {
        setSnackBar(context, "url is not right");
        return;
      }
    }

    String token = await getToken();
    loading(context);
    updateProfile =
        await service.updateSocialMedia(fb, instagram, youtube, token);

    if (!mounted) return;

    if (!updateProfile.requestStatus) {
      if (updateProfile.statusCode == 200) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) {
          return const MainPage(
            index: 4,
          );
        }), (route) => false);
        setSnackBar(context, "yes profile has been updated");
      } else {
        Navigator.pop(context);
        setSnackBar(context, updateProfile.errorMessage);
      }
    } else {
      Navigator.pop(context);
      setSnackBar(context, updateProfile.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "My Account",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsetsDirectional.only(start: 16, end: 16, top: 8),
            child: TextField(
              controller: fbController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                prefixIcon: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 16),
                        child: SvgPicture.asset(
                          fbSvg,
                          semanticsLabel: '',
                        ),
                      ),
                    ],
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsetsDirectional.only(start: 16, end: 16, top: 8),
            child: TextField(
              controller: iController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                prefixIcon: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 16),
                        child: SvgPicture.asset(
                          instagramSvg,
                          semanticsLabel: '',
                        ),
                      ),
                    ],
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsetsDirectional.only(start: 16, end: 16, top: 8),
            child: TextField(
              controller: ytController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                prefixIcon: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 16),
                        child: SvgPicture.asset(
                          ytSvg,
                          semanticsLabel: '',
                        ),
                      ),
                    ],
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(
                start: 16, end: 16, top: 8, bottom: 8),
            child: TextField(
              controller: waController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                prefixIcon: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 16),
                        child: SvgPicture.asset(
                          waSvg,
                          semanticsLabel: '',
                        ),
                      ),
                    ],
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(
                start: 16, end: 16, top: 8, bottom: 8),
            child: TextField(
              controller: vController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                prefixIcon: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 16),
                        child: SvgPicture.asset(
                          waSvg,
                          semanticsLabel: '',
                        ),
                      ),
                    ],
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 32, end: 32),
            child: ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.resolveWith<Size>(
                  (Set<MaterialState> states) {
                    return const Size(double.infinity, 40);
                  },
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              onPressed: editProfileFun,
              child: const Text("Save"),
            ),
          )
        ],
      ),
    );
  }
}
