import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../routes/app_routes.dart';
import '../widgets.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.maxFinite,
        height: SizeUtils.height,
        decoration: AppDecoration.column0,
        child: SafeArea(
          child: SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsetsDirectional.only(top: 14.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          height: 104.h,
                          width: 292.h,
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "GYM",
                                      style: theme.textTheme.displayLarge,
                                    ),
                                    TextSpan(
                                      text: " PRO",
                                      style: theme.textTheme.displayLarge,
                                    )
                                  ],
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Align(
                                alignment: AlignmentDirectional.bottomCenter,
                                child: Padding(
                                  padding:
                                      EdgeInsetsDirectional.only(bottom: 18.h),
                                  child: Text(
                                    "Achieve Greatness",
                                    style: CustomTextStyles
                                        .titleLargePoppinsPrimary,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildGetStartedSection(context),
    );
  }

  /// Section Widget
  Widget _buildGetStartedSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 50.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomElevatedButton(
            height: 46.h,
            text: "GET STARTED",
            margin: EdgeInsetsDirectional.only(bottom: 12.h),
            buttonTextStyle: CustomTextStyles.headlineSmallPoppinsWhiteA700,
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.authenticationScreen);
            },
          )
        ],
      ),
    );
  }
}
