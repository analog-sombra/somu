import 'dart:ui';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:somu/states/dailystate.dart';

import '../themes/colors.dart';

void erroralert(BuildContext context, String title, String subTitle) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: subTitle,
        contentType: ContentType.failure,
      ),
    ),
  );
}

void susalert(BuildContext context, String title, String subTitle) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: subTitle,
        contentType: ContentType.success,
      ),
    ),
  );
}

void comingalert(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: "Upcoming",
        message: "This feature is coming soon in next release",
        contentType: ContentType.help,
      ),
    ),
  );
}

void addTodo(
  BuildContext context,
  WidgetRef ref,
  TextEditingController title,
  TextEditingController description,
) {
  final formKey = GlobalKey<FormState>();
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        contentPadding: const EdgeInsets.all(5),
        backgroundColor: whiteColor,
        content: Container(
          width: MediaQuery.of(context).size.width - 50,
          padding: const EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "ADD TODO",
                      textScaleFactor: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: roseColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: FaIcon(
                        FontAwesomeIcons.xmark,
                        color: blackColor.withOpacity(0.65),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty || value == "") {
                          return 'Enter the title..';
                        }
                        return null;
                      },
                      controller: title,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xfff3f4f6),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "Title",
                        hintStyle: TextStyle(
                          color: Colors.black.withOpacity(0.45),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty || value == "") {
                          return 'Enter the Description..';
                        }
                        return null;
                      },
                      controller: description,
                      minLines: 5,
                      maxLines: 5,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xfff3f4f6),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "Description",
                        hintStyle: TextStyle(
                          color: Colors.black.withOpacity(0.45),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Spacer(),
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(roseColor),
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            await ref
                                .watch(dailyState)
                                .addTodo(title.text, description.text, context);
                            title.clear();
                            description.clear();
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          "ADD",
                          textScaleFactor: 1,
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

void deleteTodo(BuildContext context, WidgetRef ref, int id) async {
  return await showDialog(
    context: context,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        contentPadding: const EdgeInsets.all(5),
        backgroundColor: whiteColor,
        content: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Delete!",
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: blackColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w500),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Are you sure you want to delete this todo?',
                  style: TextStyle(
                    color: blackColor.withOpacity(0.55),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                  textScaleFactor: 1,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(greenColor),
                      ),
                      child: const Text(
                        "Delete",
                        textScaleFactor: 1,
                        style: TextStyle(color: whiteColor, fontSize: 16),
                      ),
                      onPressed: () {
                        ref.watch(dailyState).deleteTodo(id, context);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(roseColor),
                      ),
                      child: const Text(
                        "Cencel",
                        textScaleFactor: 1,
                        style: TextStyle(color: whiteColor, fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}

void completeTodo(BuildContext context, WidgetRef ref, int id) async {
  return await showDialog(
    context: context,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        contentPadding: const EdgeInsets.all(5),
        backgroundColor: whiteColor,
        content: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Complete!",
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: blackColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w500),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Are you sure you want to mark this todo as completed?',
                  style: TextStyle(
                    color: blackColor.withOpacity(0.55),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                  textScaleFactor: 1,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(greenColor),
                      ),
                      child: const Text(
                        "Completed",
                        textScaleFactor: 1,
                        style: TextStyle(color: whiteColor, fontSize: 16),
                      ),
                      onPressed: () async {
                        await ref.watch(dailyState).completeTodo(id, context);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(roseColor),
                      ),
                      child: const Text(
                        "Cencel",
                        textScaleFactor: 1,
                        style: TextStyle(color: whiteColor, fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}
