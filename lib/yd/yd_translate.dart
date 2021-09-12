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

class YDTranslateResult {
  YDTranslateResult({
    this.errorCode,
    this.query,
    this.translation,
    this.basic,
    this.web,
    this.dict,
    this.webdict,
    this.l,
    this.tSpeakUrl,
    this.speakUrl,
  });

  factory YDTranslateResult.fromJson(Map<String, dynamic> jsonRes) {
    final List<String>? translation =
    jsonRes['translation'] is List ? <String>[] : null;
    if (translation != null) {
      for (final dynamic item in jsonRes['translation']!) {
        if (item != null) {
          tryCatch(() {
            translation.add(asT<String>(item)!);
          });
        }
      }
    }

    final List<Web>? web = jsonRes['web'] is List ? <Web>[] : null;
    if (web != null) {
      for (final dynamic item in jsonRes['web']!) {
        if (item != null) {
          tryCatch(() {
            web.add(Web.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }
    return YDTranslateResult(
      errorCode: asT<String?>(jsonRes['errorCode']),
      query: asT<String?>(jsonRes['query']),
      translation: translation,
      basic: jsonRes['basic'] == null
          ? null
          : Basic.fromJson(asT<Map<String, dynamic>>(jsonRes['basic'])!),
      web: web,
      dict: jsonRes['dict'] == null
          ? null
          : Dict.fromJson(asT<Map<String, dynamic>>(jsonRes['dict'])!),
      webdict: jsonRes['webdict'] == null
          ? null
          : Webdict.fromJson(asT<Map<String, dynamic>>(jsonRes['webdict'])!),
      l: asT<String?>(jsonRes['l']),
      tSpeakUrl: asT<String?>(jsonRes['tSpeakUrl']),
      speakUrl: asT<String?>(jsonRes['speakUrl']),
    );
  }

  String? errorCode;
  String? query;
  List<String>? translation;
  Basic? basic;
  List<Web>? web;
  Dict? dict;
  Webdict? webdict;
  String? l;
  String? tSpeakUrl;
  String? speakUrl;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'errorCode': errorCode,
    'query': query,
    'translation': translation,
    'basic': basic,
    'web': web,
    'dict': dict,
    'webdict': webdict,
    'l': l,
    'tSpeakUrl': tSpeakUrl,
    'speakUrl': speakUrl,
  };
}

class Basic {
  Basic({
    this.phonetic,
    this.ukPhonetic,
    this.usphonetic,
    this.ukSpeech,
    this.usSpeech,
    this.explains,
  });

  factory Basic.fromJson(Map<String, dynamic> jsonRes) {
    final List<String>? explains =
    jsonRes['explains'] is List ? <String>[] : null;
    if (explains != null) {
      for (final dynamic item in jsonRes['explains']!) {
        if (item != null) {
          tryCatch(() {
            explains.add(asT<String>(item)!);
          });
        }
      }
    }
    return Basic(
      phonetic: asT<String?>(jsonRes['phonetic']),
      ukPhonetic: asT<String?>(jsonRes['uk-phonetic']),
      usphonetic: asT<String?>(jsonRes['us-phonetic']),
      ukSpeech: asT<String?>(jsonRes['uk-speech']),
      usSpeech: asT<String?>(jsonRes['us-speech']),
      explains: explains,
    );
  }

  String? phonetic;
  String? ukPhonetic;
  String? usphonetic;
  String? ukSpeech;
  String? usSpeech;
  List<String>? explains;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'phonetic': phonetic,
    'uk-phonetic': ukPhonetic,
    'us-phonetic': usphonetic,
    'uk-speech': ukSpeech,
    'us-speech': usSpeech,
    'explains': explains,
  };
}

class Web {
  Web({
    this.key,
    this.value,
  });

  factory Web.fromJson(Map<String, dynamic> jsonRes) {
    final List<String>? value = jsonRes['value'] is List ? <String>[] : null;
    if (value != null) {
      for (final dynamic item in jsonRes['value']!) {
        if (item != null) {
          tryCatch(() {
            value.add(asT<String>(item)!);
          });
        }
      }
    }
    return Web(
      key: asT<String?>(jsonRes['key']),
      value: value,
    );
  }

  String? key;
  List<String>? value;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'key': key,
    'value': value,
  };
}

class Dict {
  Dict({
    this.url,
  });

  factory Dict.fromJson(Map<String, dynamic> jsonRes) => Dict(
    url: asT<String?>(jsonRes['url']),
  );

  String? url;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'url': url,
  };
}

class Webdict {
  Webdict({
    this.url,
  });

  factory Webdict.fromJson(Map<String, dynamic> jsonRes) => Webdict(
    url: asT<String?>(jsonRes['url']),
  );

  String? url;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'url': url,
  };
}
