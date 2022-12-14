import 'package:flutter/material.dart';
import 'package:latihan_soal_flutter/constants/r.dart';
import 'package:latihan_soal_flutter/helpers/preference_helper.dart';
import 'package:latihan_soal_flutter/helpers/user_email.dart';
import 'package:latihan_soal_flutter/models/network_response.dart';
import 'package:latihan_soal_flutter/models/user_by_email.dart';
import 'package:latihan_soal_flutter/providers/auth_provider.dart';
import 'package:latihan_soal_flutter/view/auth/login_page.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);
  static String route = 'register_page';

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

enum Gender { lakilaki, perempuan }

class _EditProfilePageState extends State<EditProfilePage> {
  String gender = 'Laki-laki';

  List<String> classSlta = ['10', '11', '12'];
  String selectedClass = '10';
  final emailController = TextEditingController();
  final schoolNameController = TextEditingController();
  final fullNameController = TextEditingController();

  onTapGender(Gender genderInput) {
    if (genderInput == Gender.lakilaki) {
      gender = 'Laki-laki';
    } else {
      gender = 'Perempuan';
    }
    setState(() {});
  }

  initDataUser() async {
    emailController.text = UserEmail.getUserEmail()!;
    final dataUser = await PreferenceHelper().getUserData();
    fullNameController.text = dataUser?.userName ?? '';
    schoolNameController.text = dataUser?.userAsalSekolah ?? '';
    gender = dataUser!.userGender!;
    selectedClass = dataUser.kelas!;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xfff0f3f5),
      appBar: AppBar(
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.only(
        //   bottomLeft: Radius.circular(25.0),
        //   bottomRight: Radius.circular(25.0),
        // )),
        elevation: 0,
        // backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Edit Akun',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: ButtonLogin(
            radius: 8,
            onTap: () async {
              final json = {
                "email": emailController.text,
                "nama_lengkap": fullNameController.text,
                "nama_sekolah": schoolNameController.text,
                "kelas": selectedClass,
                "gender": gender,
                "foto": UserEmail.getUserPhotoUrl(),
              };

              final provider = Provider.of<AuthProvider>(context, listen: false);
              final result = await provider.postUpdateUser(json);
              if (result.status == Status.success) {
                final registerResult = UserByEmail.fromJson(result.data!);
                if (registerResult.status == 1) {
                  await PreferenceHelper().setUserData(registerResult.data!);
                  Navigator.pop(context, true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                        Text(registerResult.message!)));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text('Terjadi kesalahan, silahkan ulangi kembali')));
              }
            },
            backgroundColor: R.colors.primary,
            borderColor: R.colors.primary,
            child: Text(
              R.strings.perbaharuiAkun,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EditProfileTextField(
                controller: emailController,
                hintText: 'Email Anda',
                title: 'Email',
                enabled: false,
              ),
              EditProfileTextField(
                hintText: 'Nama Lengkap Anda',
                title: 'Nama Lengkap',
                controller: fullNameController,
              ),
              SizedBox(height: 5),
              Text(
                'Jenis Kelamin',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: R.colors.greySubtitle,
                ),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: gender.toLowerCase() == 'Laki-laki'.toLowerCase()
                              ? R.colors.primary
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              width: 1,
                              color: R.colors.greyBorder,
                            ),
                          ),
                        ),
                        onPressed: () {
                          onTapGender(Gender.lakilaki);
                        },
                        child: Text(
                          'Laki-laki',
                          style: TextStyle(
                            fontSize: 14,
                            color: gender.toLowerCase() == 'Laki-laki'.toLowerCase()
                                ? Colors.white
                                : Color(0xff282828),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: gender.toLowerCase() == 'Perempuan'.toLowerCase()
                              ? R.colors.primary
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              width: 1,
                              color: R.colors.greyBorder,
                            ),
                          ),
                        ),
                        onPressed: () {
                          onTapGender(Gender.perempuan);
                        },
                        child: Text(
                          'Perempuan',
                          style: TextStyle(
                            fontSize: 14,
                            color: gender.toLowerCase() == 'Perempuan'.toLowerCase()
                                ? Colors.white
                                : Color(0xff282828),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text(
                'Kelas',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: R.colors.greySubtitle,
                ),
              ),
              SizedBox(height: 5),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    border: Border.all(
                      color: R.colors.greyBorder,
                    )),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      value: selectedClass,
                      items: classSlta
                          .map((e) => DropdownMenuItem<String>(
                                child: Text(e),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (String? val) {
                        selectedClass = val!;
                        setState(() {});
                      }),
                ),
              ),
              SizedBox(height: 5),
              EditProfileTextField(
                hintText: 'Nama Sekolah',
                title: 'Nama Sekolah',
                controller: schoolNameController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditProfileTextField extends StatelessWidget {
  const EditProfileTextField({
    Key? key,
    required this.title,
    required this.hintText,
    this.controller,
    this.enabled = true,
  }) : super(key: key);
  final String title;
  final String hintText;
  final bool enabled;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: R.colors.greySubtitle,
            ),
          ),
          SizedBox(height: 5),
          TextField(
            enabled: enabled,
            controller: controller,
            decoration: InputDecoration(
                // border: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(
                  color: R.colors.greyHintText,
                )),
          ),
        ],
      ),
    );
  }
}
