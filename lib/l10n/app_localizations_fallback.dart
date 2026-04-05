import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension AppLocalizationsFallback on AppLocalizations {
  String get _languageCode => localeName.split('_').first;

  String _choose(Map<String, String> values) {
    return values[_languageCode] ?? values['en'] ?? values.values.first;
  }

  String get counsellorTyping => _choose({
        'en': 'Counsellor is typing',
        'si': 'උපදේශකයා ටයිප් කරමින් සිටී',
        'ta': 'ஆசனையாளர் தட்டச்சு செய்துகொள்கிறார்',
      });

  String get counsellorSarah => _choose({
        'en': 'Counsellor Sarah',
        'si': 'උපදේශක සාරා',
        'ta': 'ஆசனையாளர் சரா',
      });

  String get chatGreeting => _choose({
        'en': 'Hello! How are you feeling today?',
        'si': 'හෙලෝ! අද ඔබට කෙසේ දැනේද?',
        'ta': 'வணக்கம்! இன்று நீங்கள் எப்படி உணர்கிறீர்கள்?',
      });

  String get chatFeelingAnxious => _choose({
        'en': 'I\'m feeling a bit anxious about work.',
        'si': 'මට රැකියාව ගැන ටිකක් උතුරු හැඟීමක් තියෙන්නේ.',
        'ta': 'எனக்கு வேலை பற்றி கொஞ்சம் பதற்றம் உள்ளது.',
      });

  String get chatResponseWorkStress => _choose({
        'en':
            'That\'s completely understandable. Work stress can be overwhelming. Can you tell me more about what\'s causing this anxiety?',
        'si':
            'ඒ දේ අවබෝධ කරගන්න පුළුවන්. වැඩ පීඩාව අවධානයට පත් කළ හැක. මෙම තත්ත්වය කැටි කරන හේතුව දැක්වන්න පුළුවන්ද?',
        'ta':
            'அது புரிந்துகொள்ளத்தக்கது. வேலை அழுத்தம் மிகக் கடுமையாக இருக்கலாம். இந்த பதற்றம் ஏற்பட காரணம் என்ன என்று கூற முடியுமா?',
      });

  String get chatPresentationWorry => _choose({
        'en':
            'I have a big presentation coming up and I\'m worried about messing up.',
        'si':
            'මට විශාල ඉදිරිපත් කිරීමක් තියෙනවා, ඒක අසාර්ථක වෙනවාද කියලා මා බිය වෙලා ඉන්නේ.',
        'ta':
            'எனக்கு ஒரு பெரிய விளக்கக்காட்சி உள்ளது, அதை தவறவிடுவேன் என்று நான் அஞ்சுகிறேன்.',
      });

  String get chatPreppingAnxiety => _choose({
        'en':
            'It\'s normal to feel nervous about presentations. Let\'s explore some strategies to help you prepare and manage your anxiety.',
        'si':
            'ඉදිරිපත් කිරීම් ගැන සැකයක් දැනීම සාමාන්‍යයි. සූදානම් වීමට සහ ඔබේ පීඩා කළමනාකරණය කිරීමට අපි උපාය මාර්ග සෙවීමට ඉඩ සලසමු.',
        'ta':
            'விளக்கக்காட்சிகளுக்கு பதற்றமாக உணருவது சாதாரணம். தயார் செய்ய மற்றும் உங்கள் பதற்றத்தை நிர்வகிக்க சில உத்திகள் இப்போது பார்க்கலாம்.',
      });

  String get chatFollowUpResponse => _choose({
        'en':
            'Thank you for sharing that. Remember, it\'s okay to feel this way. We can work through this together.',
        'si':
            'ඔබ ඒ ගැන බෙදාගත්තේට ස්තුතියි. මේ ලෙස හැඟීමක් දැනීම සාමාන්‍යයි. අපි එය එක්ව එකට විසඳමු.',
        'ta':
            'அதைப் பகிர்ந்ததற்கு நன்றி. இப்படி உணருவது ஏற்கத்தக்கது. நாம் இதை ஒன்றாய் மனம் நிறுத்தி சமாளிக்கலாம்.',
      });

  String get chatAutoResponse => _choose({
        'en': 'I\'m here to help with that. Let\'s discuss what\'s going on.',
        'si':
            'ඒ ගැන මට උදව් කිරීමට මට සූදානම්. අපි සිදුවෙන්නේ කුමක්ද කියා කතා කරමු.',
        'ta':
            'இந்த குறித்து உதவ நான் தயாராக இருக்கிறேன். நடக்கிறதைப் பற்றி பேசலாம்.',
      });

  String get shareFeelingHint => _choose({
        'en': 'Share how you\'re feeling...',
        'si': 'ඔබට ලැබෙන හැඟීම් බෙදා ගන්න...',
        'ta': 'நீங்கள் எப்படி உணர்கிறீர்கள் என்பதை பகிர십시오...',
      });

  String get quickReplyCravings => _choose({
        'en': 'I\'m struggling with cravings',
        'si': 'මට කැමති කම්පනයන්ටට වටිනවා',
        'ta': 'எனக்கு ஆசைகள் கொண்ட போதையில் கடுமையாக இருக்கிறது',
      });

  String get quickReplyCopingStrategies => _choose({
        'en': 'I need coping strategies',
        'si': 'මට වටින උපාය මඟ පෙන්වන්න',
        'ta': 'நான் சமாளிப்பு உருவாக்க வேண்டும்',
      });

  String get quickReplyTriggered => _choose({
        'en': 'I\'m feeling triggered',
        'si': 'මම හදිසියට හැඟීම් දැනෙයි',
        'ta': 'நான் தூண்டப்பட்டதாக உணர்கிறேன்',
      });

  String get quickReplyRelapse => _choose({
        'en': 'I want to talk about relapse',
        'si': 'මට නැවත ප්‍රතිලාභ ගැන කතා කරන්න ඕනෑයි',
        'ta': 'மீண்டும் தளர்ச்சி பற்றி பேச விரும்புகிறேன்',
      });

  String get quickReplyProud => _choose({
        'en': 'I\'m proud of my progress',
        'si': 'මගේ ප්‍රගතිය ගැන මට ගෞරවයි',
        'ta': 'என் முன்னேற்றத்தைப் பற்றி நான் பெருமையாக இருக்கிறேன்',
      });

  String get emergencyContactInitiated => _choose({
        'en': 'Emergency contact initiated',
        'si': 'හදිසි සම්බන්ධතා ආරම්භ කරන ලදී',
        'ta': 'அவசர தொடர்பு துவங்கிவிட்டது',
      });

  String get appointmentsAndBooking => _choose({
        'en': 'Appointments & Booking',
        'si': 'ඇපොයින්ට්මන්ට් සහ වෙන්කිරීම',
        'ta': 'பயணிகள் மற்றும் முன்பதிவுகள்',
      });

  String get yourAppointments => _choose({
        'en': 'Your Appointments',
        'si': 'ඔබගේ ඇපොයින්ට්මන්ට්',
        'ta': 'உங்கள் பயணிகள்',
      });

  String get upcoming => _choose({
        'en': 'Upcoming',
        'si': 'ඉදිරි',
        'ta': 'மூன்றாவது',
      });

  String get completed => _choose({
        'en': 'Completed',
        'si': 'සම්පූර්ණයි',
        'ta': 'முடிந்தது',
      });

  String get scheduledSessions => _choose({
        'en': 'Scheduled Sessions',
        'si': 'පෙළගැස්වූ සැසි',
        'ta': 'நிகழ்கால அமர்வுகள்',
      });

  String get bookNewAppointment => _choose({
        'en': 'Book New Appointment',
        'si': 'නව ඇපොයින්ට්මන්ට් වෙන් කරන්න',
        'ta': 'புதிய பயணியைப் பதிவு செய்யவும்',
      });

  String get cancellationPolicy => _choose({
        'en': 'Cancellation Policy',
        'si': 'අවලංගු කිරීමේ ප්‍රතිපත්තිය',
        'ta': 'ரத்து கொள்கை',
      });

  String get cancellationPolicyText => _choose({
        'en':
            'Please cancel appointments at least 24 hours in advance to avoid any inconvenience.',
        'si':
            'කරුණාකර අපහසුතාව වලට පත්වීමට පෙර පැය 24 කට අව්වත් ඇපොයින්ට්මන්ට් අවලංගු කරන්න.',
        'ta':
            'எதையாவது தொந்தரவு ஏற்பட விட 24 மணி நேரத்திற்கு முன் பிற்படுத்தவும்.',
      });

  String get selectCounsellor => _choose({
        'en': 'Select Counsellor:',
        'si': 'උපදේශකයා තෝරන්න:',
        'ta': 'ஆசனையாளரை தேர்ந்தெடுக்கவும்:',
      });

  String get chooseCounsellor => _choose({
        'en': 'Choose counsellor',
        'si': 'උපදේශකයා තෝරන්න',
        'ta': 'ஆசனையாளரை தேர்ந்தெடுக்கவும்',
      });

  String get preferredDate => _choose({
        'en': 'Preferred Date:',
        'si': 'ප්‍රියතම දිනය:',
        'ta': 'விரும்பிய தேதி:',
      });

  String get selectDate => _choose({
        'en': 'Select date',
        'si': 'දිනය තෝරන්න',
        'ta': 'தேதியைத் தேர்ந்தெடுக்கவும்',
      });

  String get sessionType => _choose({
        'en': 'Session Type:',
        'si': 'සැසිය වර්ගය:',
        'ta': 'அமர்வு வகை:',
      });

  String get videoCall => _choose({
        'en': 'Video Call',
        'si': 'වීඩියෝ ඇමතුම',
        'ta': 'வீடியோ அழைப்பு',
      });

  String get phone => _choose({
        'en': 'Phone',
        'si': 'දුරකථන',
        'ta': 'தொலைபேசி',
      });

  String get available => _choose({
        'en': 'Available',
        'si': 'ලබා ගත හැකි',
        'ta': 'கிடைக்கும்',
      });

  String get withLabel => _choose({
        'en': 'With',
        'si': 'සමඟ',
        'ta': 'உடன்',
      });

  String get dateLabel => _choose({
        'en': 'Date:',
        'si': 'දිනය:',
        'ta': 'தேதி:',
      });

  String get timeLabel => _choose({
        'en': 'Time:',
        'si': 'වේලාව:',
        'ta': 'நேரம்:',
      });

  String get methodLabel => _choose({
        'en': 'Method:',
        'si': 'ආකාරය:',
        'ta': 'முறை:',
      });

  String get statusLabel => _choose({
        'en': 'Status:',
        'si': 'තත්ත්වය:',
        'ta': 'நிலையை:',
      });

  String get appointmentRequestSent => _choose({
        'en': 'Appointment request sent! Confirmation coming soon.',
        'si': 'ඇපොයින්ට්මන්ට් ඉල්ලීම යවයි! තහවුරු කිරීම සමීපයෙන් පැමිණේ.',
        'ta':
            'அரைகாலத்தில் தங்கள் பயணியின் கோரிக்கை அனுப்பப்பட்டது! உறுதிப்படுத்தல் விரைவில் வரும்.',
      });

  String get confirmationSent => _choose({
        'en':
            'A confirmation will be sent to your email and phone number on file.',
        'si': 'ඔබගේ විද්‍යුත් තැපැල් හා දුරකථන අංකයට තහවුරු කිරීම යවනු ලැබේ.',
        'ta':
            'உங்கள் மின்னஞ்சல் மற்றும் தொலைபேசி எண்ணுக்கு உறுதிப்படுத்தல் அனுப்பப்படும்.',
      });

  String get confirmBooking => _choose({
        'en': 'Confirm Booking',
        'si': 'වෙන්කිරීම තහවුරු කිරීම',
        'ta': 'பதிவு செய்யவும்',
      });

  String get appointmentConfirmed => _choose({
        'en': 'Appointment confirmed!',
        'si': 'ඇපොයින්ට්මන්ට් තහවුරු කරන ලදී!',
        'ta': 'பயணி உறுதிசெய்யப்பட்டது!',
      });

  String get confirmed => _choose({
        'en': 'Confirmed',
        'si': 'තහවුරු කරන ලදී',
        'ta': 'உறுதிசெய்யப்பட்டது',
      });

  String get pending => _choose({
        'en': 'Pending',
        'si': 'පැවසුණු',
        'ta': 'தருகின்றது',
      });

  String get counsellingSession => _choose({
        'en': 'Counselling Session',
        'si': 'උපදේශන සැසිය',
        'ta': 'ஆசனைஅமர்வு',
      });

  String get supportGroupMeeting => _choose({
        'en': 'Support Group Meeting',
        'si': 'සහාය කණ්ඩායම් හමුව',
        'ta': 'ஆதரவு குழு சந்திப்பு',
      });

  String get followUpSession => _choose({
        'en': 'Follow-up Session',
        'si': 'අනුගමන සැසිය',
        'ta': 'பின்தொடர் அமர்வு',
      });

  String get inPerson => _choose({
        'en': 'In-Person',
        'si': 'සිරස්මූඛ',
        'ta': 'முகாமुखி',
      });

  String get phoneCall => _choose({
        'en': 'Phone Call',
        'si': 'දුරකථන ඇමතුම',
        'ta': 'தொலைபேசி அழைப்பு',
      });

  String get bookNewAppointmentButton => _choose({
        'en': 'Request Appointment',
        'si': 'ඇපොයින්ට්මන්ට් ඉල්ලීම කරන්න',
        'ta': 'பயணிக்கு வேண்டுகோள் செய்யவும்',
      });

  String get bookWithLabelPattern => _choose({
        'en': 'Book with {name}',
        'si': '{name} සමඟ වෙන් කරගන්න',
        'ta': '{name} உடன் பதிவு செய்யவும்',
      });

  String bookWithLabel(String name) =>
      bookWithLabelPattern.replaceAll('{name}', name);

  String get cancelLabel => _choose({
        'en': 'Cancel',
        'si': 'අවලංගු කරන්න',
        'ta': 'ரத்து',
      });

  String get appointmentCanceled => _choose({
        'en': 'Cancel',
        'si': 'අවලංගු කරන්න',
        'ta': 'ரத்து',
      });

  String get closeLabel => _choose({
        'en': 'Close',
        'si': 'මූලය',
        'ta': 'மூடு',
      });

  String get appointmentBookedWithPattern => _choose({
        'en': 'Appointment booked with {name}!',
        'si': '{name} සමඟ ඇපොයින්ට්මන්ට් වෙන්කරන ලදී!',
        'ta': '{name} உடன் பயணிக்கு பதிவு செய்துவிட்டது!',
      });

  String appointmentBookedWith(String name) =>
      appointmentBookedWithPattern.replaceAll('{name}', name);
}
