# Aturan umum untuk menjaga plugin Flutter
-keep class io.flutter.plugins.** { *; }

# Aturan untuk TensorFlow Lite (termasuk GPU delegate yang error)
-keep class org.tensorflow.lite.** { *; }
-dontwarn org.tensorflow.lite.**

# Aturan untuk Google ML Kit & library terkait
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.internal.mlkit_* { *; }
-keep class com.google.android.odml.image.** { *; }

# Aturan untuk "ignore" peringatan dari library compile-time
-dontwarn javax.lang.model.**
-dontwarn javax.annotation.processing.**
-dontwarn autovalue.shaded.com.squareup.javapoet.**