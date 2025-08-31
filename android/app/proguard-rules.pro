# ==============================================================================
# Aturan Flutter Standar
# Melindungi jembatan antara kode Dart dan Native Flutter.
# ==============================================================================
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.embedding.engine.** { *; }
-keep class io.flutter.embedding.engine.plugins.** { *; }
-keep class io.flutter.plugin.common.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.engine.FlutterJNI

# ==============================================================================
# Aturan untuk Class yang Dipanggil via Native (JNI)
# Penting untuk plugin seperti hand_landmarker yang menggunakan JNI.
# ==============================================================================
-keepclasseswithmembernames class * {
    native <methods>;
}

# ==============================================================================
# Aturan untuk Machine Learning (TFLite & ML Kit)
# Melindungi kelas-kelas yang dibutuhkan untuk inferensi model.
# ==============================================================================
-keep class org.tensorflow.lite.** { *; }
-dontwarn org.tensorflow.lite.**
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.internal.mlkit_* { *; }
-keep class com.google.android.odml.image.** { *; }

# ==============================================================================
# Aturan untuk WebView
# Menjaga class yang sering digunakan oleh plugin webview_flutter.
# ==============================================================================
-keep class * extends android.webkit.WebViewClient { *; }
-keep class * extends android.webkit.WebChromeClient { *; }
-keep public class com.google.android.gms.ads.identifier.AdvertisingIdClient {
    public static com.google.android.gms.ads.identifier.AdvertisingIdClient$Info getAdvertisingIdInfo(android.content.Context);
}
-keep public class com.google.android.gms.ads.identifier.AdvertisingIdClient$Info {
    public java.lang.String getId();
    public boolean isLimitAdTrackingEnabled();
}

# ==============================================================================
# Aturan Pengecualian Peringatan (Warning Exclusions)
# Mengatasi error "Missing class" dari library compile-time.
# ==============================================================================
-dontwarn javax.lang.model.**
-dontwarn javax.annotation.processing.**
-dontwarn autovalue.shaded.com.squareup.javapoet.**

# Jika Anda menggunakan library serialisasi JSON seperti GSON (sering jadi dependensi)
# -keep class com.google.gson.** { *; }