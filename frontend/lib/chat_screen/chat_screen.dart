import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chat_lib;
import '../app_theme.dart';
import '../app_utils.dart';
import '../widgets.dart';

// ignore_for_file: must_be_immutable
class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  types.User chatUser = types.User(id: 'RECEIVER_USER');

  List<types.Message> messageList = [
    types.TextMessage(
        type: types.MessageType.text,
        id: '255:569',
        author: types.User(id: 'RECEIVER_USER'),
        text: "10:30 AM",
        status: types.Status.delivered,
        createdAt: 1745278707472),
    types.TextMessage(
        type: types.MessageType.text,
        id: '255:564',
        author: types.User(id: 'SENDER_USER'),
        text: "10:24 AM",
        status: types.Status.delivered,
        createdAt: 1745278707472),
    types.TextMessage(
        type: types.MessageType.text,
        id: '255:567',
        author: types.User(id: 'SENDER_USER'),
        text: "10:28 AM",
        status: types.Status.delivered,
        createdAt: 1745278707472),
    types.TextMessage(
        type: types.MessageType.text,
        id: '255:565',
        author: types.User(id: 'RECEIVER_USER'),
        text: "10:26 AM",
        status: types.Status.delivered,
        createdAt: 1745278707472)
  ];

  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsetsDirectional.only(
                    start: 22.h,
                    top: 12.h,
                    end: 22.h,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: double.maxFinite,
                          child: chat_lib.Chat(
                            showUserNames: false,
                            disableImageGallery: false,
                            dateHeaderThreshold: 86400000,
                            messages: messageList,
                            user: chatUser,
                            bubbleBuilder: (child,
                                {required message,
                                required nextMessageInGroup}) {
                              return message.author.id == chatUser.id
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.h),
                                          topRight: Radius.circular(20.h),
                                          bottomLeft: Radius.circular(20.h),
                                        ),
                                      ),
                                      child: child)
                                  : Container(
                                      decoration: BoxDecoration(
                                        color: theme
                                            .colorScheme.onPrimaryContainer,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.h),
                                          topRight: Radius.circular(20.h),
                                          bottomRight: Radius.circular(20.h),
                                        ),
                                      ),
                                      child: child,
                                    );
                            },
                            textMessageBuilder: (textMessage,
                                {required messageWidth, required showName}) {
                              return textMessage.author.id == chatUser.id
                                  ? Container(
                                      width: double.maxFinite,
                                      padding: EdgeInsetsDirectional.only(
                                        top: 4.h,
                                        end: 16.h,
                                        bottom: 4.h,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          SizedBox(height: 72.h),
                                          Text(
                                            textMessage.text.toString(),
                                            style: CustomTextStyles
                                                .bodyLargeBlack900ExtraLight
                                                .copyWith(
                                              color: appTheme.black900,
                                            ),
                                          )
                                        ],
                                      ))
                                  : Container(
                                      width: double.maxFinite,
                                      padding: EdgeInsetsDirectional.only(
                                        top: 12.h,
                                        end: 104.h,
                                        bottom: 12.h,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          SizedBox(height: 54.h),
                                          Text(
                                            textMessage.text.toString(),
                                            style: CustomTextStyles
                                                .bodyLargeBlack900ExtraLight
                                                .copyWith(
                                              color: appTheme.black900,
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                            },
                            onSendPressed: (types.PartialText text) {},
                            customBottomWidget: Container(
                              height: 54.h,
                              padding: EdgeInsetsDirectional.symmetric(
                                  horizontal: 10.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomImageView(
                                    imagePath: ImageConstant.imgCameraGray600,
                                    height: 24.h,
                                    width: 24.h,
                                    margin: EdgeInsetsDirectional.only(
                                      start: 6.h,
                                      top: 12.h,
                                    ),
                                  ),
                                  CustomImageView(
                                    imagePath: ImageConstant.imgImage,
                                    height: 24.h,
                                    width: 24.h,
                                    margin: EdgeInsetsDirectional.only(
                                      start: 12.h,
                                      top: 12.h,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.only(
                                        start: 6.h,
                                        bottom: 12.h,
                                      ),
                                      child: CustomTextFormField(
                                        controller: messageController,
                                        hintText: "Add your message ",
                                        hintStyle: CustomTextStyles
                                            .bodyLargeBlack900ExtraLight,
                                        textInputAction: TextInputAction.done,
                                        contentPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                20.h, 10.h, 20.h, 8.h),
                                        borderDecoration:
                                            TextFormFieldStyleHelper
                                                .fillOnPrimaryContainerTL201,
                                        fillColor: theme
                                            .colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.only(
                                      start: 18.h,
                                      top: 6.h,
                                    ),
                                    child: CustomIconButton(
                                      height: 30.h,
                                      width: 30.h,
                                      padding: EdgeInsetsDirectional.all(4.h),
                                      decoration:
                                          IconButtonStyleHelper.fillWhiteA,
                                      child: CustomImageView(
                                        imagePath: ImageConstant.imgSave,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            customStatusBuilder: (message, {required context}) {
                              return Container();
                            },
                          ),
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
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 102.h,
      leadingWidth: 27.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftBlack900,
        height: 16.h,
        width: 16.h,
        margin: EdgeInsetsDirectional.only(start: 11.h),
      ),
      title: Padding(
        padding: EdgeInsetsDirectional.only(start: 15.h),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 80.h,
                  width: 80.h,
                  decoration: BoxDecoration(
                    color: appTheme.whiteA700,
                    borderRadius: BorderRadius.circular(
                      40.h,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: 13.h,
                    top: 8.h,
                    bottom: 17.h,
                  ),
                  child: Column(
                    children: [
                      AppbarTitle(
                        text: "John",
                        margin: EdgeInsetsDirectional.only(end: 70.h),
                      ),
                      AppbarSubtitleTwo(
                        text: "Fitness Coach",
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
      styleType: Style.bgFillOnPrimaryContainer,
    );
  }
}
