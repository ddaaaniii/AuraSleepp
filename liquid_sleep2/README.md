# 🌙 Liquid Sleep Flutter — Fiel al diseño HTML original

App premium de frecuencias, relajación y sueño. Réplica exacta del diseño Liquid Glass oscuro.

## Setup

```bash
flutter pub get
flutter run -d ios        # iPhone
flutter run -d android    # Android
flutter build ios --release           # .ipa
flutter build appbundle --release     # .aab Play Store
```

## Pantallas

| Pantalla     | Descripción |
|---|---|
| **Inicio**   | Reproductor principal, Hz grande, visualizador de ondas, timer, presets rápidos |
| **Biblioteca** | 26 frecuencias filtrables por categoría (Delta, Theta, Alpha, Beta, Gamma, Solfeggio) |
| **Mezcla**   | Mezclador de múltiples frecuencias simultáneas |
| **Stats**    | Estadísticas, gráfica semanal, favoritos, streaks |

## Permisos iOS — Info.plist

```xml
<key>UIBackgroundModes</key>
<array><string>audio</string></array>
<key>NSMicrophoneUsageDescription</key>
<string>Para detectar ruido y adaptar sonidos</string>
```

## Permisos Android — AndroidManifest.xml

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
```

## Audio binaural real

El `BinauralEngine` está listo. Para activar tonos reales:
- Opción A: Archivos `.mp3` en `assets/audio/` (un tono por frecuencia)
- Opción B: Plugin nativo dart:ffi + C++ para generación en tiempo real

## Dependencias principales

- `just_audio` — reproducción audio
- `audio_session` — configuración de sesión
- `provider` — estado global
- `flutter_animate` — animaciones 120fps
- `shared_preferences` — persistencia favoritos/volumen
- `vibration` — haptics premium
