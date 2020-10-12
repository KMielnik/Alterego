import 'package:auto_localized/annotations.dart';

@AutoLocalized(
  locales: [
    AutoLocalizedLocale(
      languageCode: 'pl',
      translationsFilePath: 'lang/pl.yaml',
    ),
    AutoLocalizedLocale(
      languageCode: 'en',
      countryCode: 'US',
      translationsFilePath: 'lang/en.yaml',
    ),
  ],
)
class $Strings {}
