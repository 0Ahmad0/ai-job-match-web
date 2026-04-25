import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../data/services/gemini_service.dart';

class PlatformChatSheet extends StatefulWidget {
  const PlatformChatSheet({super.key});

  @override
  State<PlatformChatSheet> createState() => _PlatformChatSheetState();
}

class _PlatformChatSheetState extends State<PlatformChatSheet> {
  final TextEditingController _inputCtrl = TextEditingController();
  final List<_ChatMessage> _messages = [];
  bool _loading = false;

  late final GeminiService _gemini;

  @override
  void initState() {
    super.initState();
    _gemini = Get.isRegistered<GeminiService>()
        ? Get.find<GeminiService>()
        : Get.put(GeminiService(), permanent: true);
    _messages.add(
      _ChatMessage(
        role: _ChatRole.bot,
        text: 'chatbot_welcome'.tr,
      ),
    );
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty || _loading) return;

    setState(() {
      _messages.add(_ChatMessage(role: _ChatRole.user, text: text));
      _loading = true;
      _inputCtrl.clear();
    });

    final localeCode = (Get.locale?.languageCode ?? 'en').toLowerCase();
    final reply = await _gemini.askPlatformAssistant(
      text,
      preferredLanguageCode: localeCode,
    );

    if (!mounted) return;
    setState(() {
      _messages.add(
        _ChatMessage(
          role: _ChatRole.bot,
          text: reply.isEmpty ? 'chatbot_fallback'.tr : reply,
        ),
      );
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.74,
        padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 14.h),
        decoration: BoxDecoration(
          color: context.theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(999.r),
              ),
            ),
            10.verticalSpace,
            Text('chatbot_title'.tr, style: context.textTheme.titleMedium),
            12.verticalSpace,
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isUser = msg.role == _ChatRole.user;
                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 8.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.h,
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      decoration: BoxDecoration(
                        color: isUser
                            ? context.theme.primaryColor.withValues(alpha: 0.15)
                            : context.theme.cardColor,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color:
                              context.theme.dividerColor.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text(msg.text),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputCtrl,
                    minLines: 1,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'chatbot_input_hint'.tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                8.horizontalSpace,
                SizedBox(
                  width: 46.w,
                  height: 46.w,
                  child: FloatingActionButton(
                    elevation: 0,
                    onPressed: _loading ? null : _send,
                    child: _loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum _ChatRole { user, bot }

class _ChatMessage {
  final _ChatRole role;
  final String text;

  _ChatMessage({required this.role, required this.text});
}
