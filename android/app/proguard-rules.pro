# === Razorpay Fix ===

# Prevent R8 from removing required proguard annotations
-keep class proguard.annotation.Keep
-keep class proguard.annotation.KeepClassMembers

# Keep all Razorpay classes and their members
-keep class com.razorpay.** { *; }

# Avoid warning logs
-dontwarn com.razorpay.**
