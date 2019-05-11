import 'dart:ui' show Locale;

class TranslationBundle {
  const TranslationBundle(this.parent);
  final TranslationBundle parent;

  String get welcome => parent?.welcome;

  String get emailLabel => parent?.emailLabel;

  String get nextButtonLabel => parent?.nextButtonLabel;

  String get cancelButtonLabel => parent?.cancelButtonLabel;

  String get passwordLabel => parent?.passwordLabel;

  String get forgotPassword => parent?.forgotPassword;

  String get signInLabel => parent?.signInLabel;

  String get signInTitle => parent?.signInTitle;

  String get signOutLabel => parent?.signOutLabel;

  String get signOutTitle => parent?.signOutTitle;

  String get signUpTitle => parent?.signUpTitle;

  String get verifyInLabel => parent?.verifyInLabel;

  String get nextLabel => parent?.nextLabel;

  String get previousLabel => parent?.previousLabel;

  String get recoverPasswordTitle => parent?.recoverPasswordTitle;

  String get recoverHelpLabel => parent?.recoverHelpLabel;

  String get sendButtonLabel => parent?.sendButtonLabel;

  String get nameLabel => parent?.nameLabel;

  String get saveLabel => parent?.saveLabel;

  String get errorOccurred => parent?.errorOccurred;

  recoverDialog(String email) => parent?.recoverDialog(email);

  String get phoneNumberLabel => parent?.phoneNumberLabel;

  String get smsCodeLabel => parent?.smsCodeLabel;

  String get reSendLabel => parent?.reSendLabel;

  String get userProfileTitle => parent?.userProfileTitle;

  String get skipLabel => parent?.skipLabel;

  String get verifyedInLabel => parent?.verifyedInLabel;

  String get unverifyedInLabel => parent?.unverifyedInLabel;

  String get verifyEmailTitle => parent?.verifyEmailTitle;

  String get completeLabel => parent?.completeLabel;

  String get verifyEmailErrorText => parent?.verifyEmailErrorText;

  String get clickEmailLinkText => parent?.clickEmailLinkText;

  String get sendVerifyEmailLinkText => parent?.sendVerifyEmailLinkText;

  String get verificationEmailTitle => parent?.verificationEmailTitle;
}

//ignore: camel_case_types
class _Bundle_en extends TranslationBundle {
  const _Bundle_en() : super(null);

  @override
  String get welcome => r'Welcome';
  
  @override
  String get emailLabel => r'Email';

  @override
  String get passwordLabel => r'Password';

  @override
  String get nextButtonLabel => r'NEXT';

  @override
  String get cancelButtonLabel => r'CANCEL';

  @override
  String get signInLabel => r'SIGN IN';

  @override
  String get signInTitle => r'Sign In';

  @override
  String get signOutLabel => r'SIGN OUT';

  @override
  String get signOutTitle => r'Sign Out';

  @override
  String get signUpTitle => r'Sign Up';

  @override
  String get verifyInLabel => r'VERIFY';

  @override
  String get nextLabel => r'NEXT';

  @override
  String get previousLabel => r'PREVIOUS';

  @override
  String get saveLabel => r'SAVE';

  @override
  String get forgotPassword => 'Forgot Password ?';

  @override
  String get recoverPasswordTitle => r'Recover password';

  @override
  String get recoverHelpLabel =>
      r'Get instructions sent to this email ' +
      'that explain how to reset your password';

  @override
  String get sendButtonLabel => r'SEND';

  @override
  String get nameLabel => r'Full Name';

  @override
  String get errorOccurred => r'An error occurred';

  @override
  recoverDialog(String email) {
    return 'Follow the instructions sent to $email to recover your password';
  }

  @override
  String get phoneNumberLabel => r'Phone Number';

  @override
  String get smsCodeLabel => r'SMS Code';

  @override
  String get reSendLabel => r'RESEND';

  @override
  String get userProfileTitle => r'User Profile';

  @override
  String get skipLabel => r'SKIP';

  @override
  String get verifyedInLabel => r'VERIFYED';

  @override
  String get unverifyedInLabel => r'UNVERIFYED';

  @override
  String get verifyEmailTitle => r'email not verified !';

  @override
  String get completeLabel => r'COMPLETE';

  @override
  String get verifyEmailErrorText => r'verification failed. did not receive email ?';

  @override
  String get clickEmailLinkText => r'sent successfully. please click on the link in the email.';

  @override
  String get sendVerifyEmailLinkText => r'sending a verification link to your email.';

  @override
  String get verificationEmailTitle => r'Verification Email';
}

//ignore: camel_case_types
class _Bundle_ar extends TranslationBundle {
  const _Bundle_ar() : super(null);

  @override
  String get welcome => r'مرحبا بكم';

  @override
  String get emailLabel => r'البريد الإلكتروني'; 

  @override
  String get passwordLabel => r'كلمة المرور'; 

  @override
  String get nextButtonLabel => r'التالي'; 

  @override
  String get cancelButtonLabel => r'إلغاء'; 

  @override
  String get signInLabel => r'الدخول'; 

  @override
  String get signInTitle => r'الدخول'; 

  @override
  String get signUpTitle => r'التسجيل'; 

  @override
  String get signOutLabel => r'الخروج'; 

  @override
  String get signOutTitle => r'الخروج'; 

  @override
  String get verifyInLabel => r'التحقق'; 

  @override
  String get nextLabel => r'التالي'; 

  @override
  String get previousLabel => r'السابق'; 

  @override
  String get saveLabel => r'حفظ'; 

  @override
  String get forgotPassword => 'اضعت كلمة المرور؟'; 

  @override
  String get recoverPasswordTitle => r'استرجاع كلمة مرور'; 

  @override
  String get recoverHelpLabel =>
      r'الحصول على التعليمات من خلال البريد الإلكتروني' +
      ' لشرح كيفية إعادة اختيار كلمة المرور'; 
  @override
  String get sendButtonLabel => r'ارسل'; 

  @override
  String get nameLabel => r'اسم الكامل'; 

  @override
  String get errorOccurred => r'حدث خطأ'; 

  @override
  recoverDialog(String email) {
    return ' لاسترجاع كلمة المرور $email اتبع الخطوات المرسلة'; 
  }

  @override
  String get phoneNumberLabel => r'رقم الهاتف'; 

  @override
  String get smsCodeLabel => r'رمز الرسالة النصية'; 

  @override
  String get reSendLabel => r'إعادة ارسال'; 

  @override
  String get userProfileTitle => r'تفاصيل المستخدم'; 

  @override
  String get skipLabel => r'تخطي'; 

  @override
  String get verifyedInLabel => r'تم التحقق'; 

  @override
  String get unverifyedInLabel => r'لم يتم التحقق';

  @override
  String get verifyEmailTitle => r'لم يتم التحقق من البريد الإلكتروني!'; 

  @override
  String get completeLabel => r'تمت العملية'; 

  @override
  String get verifyEmailErrorText => r'لم ينحج التحقق, لم يستقبل البريد الإلكتروني؟';

  @override
  String get clickEmailLinkText => r'تم الارسال بنجاح  يرجى الضغط على الرابط في البريد الإلكتروني.';

  @override
  String get sendVerifyEmailLinkText => r'جاري الارسال رابط التحقق إلى البريد الإلكتروني.';

  @override
  String get verificationEmailTitle => r'رسالة التحقق'; 
}

TranslationBundle translationBundleForLocale(Locale locale) {
  switch (locale.languageCode) {
    case 'ar':
      return const _Bundle_ar();
    case 'en':
      return const _Bundle_en();
  }
  return const TranslationBundle(null);
}
