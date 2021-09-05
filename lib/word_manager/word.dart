import 'dart:convert';
import 'dart:developer';

void tryCatch(Function? f) {
  try {
    f?.call();
  } catch (e, stack) {
    log('$e');
    log('$stack');
  }
}

class FFConvert {
  FFConvert._();
  static T? Function<T extends Object?>(dynamic value) convert =
  <T>(dynamic value) {
    if (value == null) {
      return null;
    }
    return json.decode(value.toString()) as T?;
  };
}

T? asT<T extends Object?>(dynamic value, [T? defaultValue]) {
  if (value is T) {
    return value;
  }
  try {
    if (value != null) {
      final String valueS = value.toString();
      if ('' is T) {
        return valueS as T;
      } else if (0 is T) {
        return int.parse(valueS) as T;
      } else if (0.0 is T) {
        return double.parse(valueS) as T;
      } else if (false is T) {
        if (valueS == '0' || valueS == '1') {
          return (valueS == '1') as T;
        }
        return (valueS == 'true') as T;
      } else {
        return FFConvert.convert<T>(value);
      }
    }
  } catch (e, stackTrace) {
    log('asT<$T>', error: e, stackTrace: stackTrace);
    return defaultValue;
  }

  return defaultValue;
}

class Word {
  Word({
    required this.word,
    required this.explain,
    required this.match,
    required this.example,
    required this.exampleTranslation,
    required this.page,
    required this.day,
  });

  factory Word.fromJson(Map<String, dynamic> jsonRes) => Word(
    word: asT<String>(jsonRes['word'])!,
    explain: asT<String>(jsonRes['explain'])!,
    match: asT<String>(jsonRes['match'])!,
    example: asT<String>(jsonRes['example'])!,
    exampleTranslation: asT<String>(jsonRes['exampleTranslation'])!,
    page: asT<int>(jsonRes['page'])!,
    day: asT<int>(jsonRes['day'])!,
  );

  String word;
  String explain;
  String match;
  String example;
  String exampleTranslation;
  int page;
  int day;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'word': word,
    'explain': explain,
    'match': match,
    'example': example,
    'exampleTranslation': exampleTranslation,
    'page': page,
    'day': day,
  };
}
