# Tesseract OCR 4 for Raspberry Pi 3

Prebuilt binary debian packages of Tesseract OCR 4 for Raspberry Pi 3. 

## Version Information

| Name          | Version      |
|:--------------|:-------------|
| Leptonica     | 1.77.0       |
| Tesseract OCR | 4.0.0        |
| Tessdata Fast | 4.0.0        |

## Supported Languages

- Italian, Tamil, Swahili, Persian, Malay, Hindi, Japanese, German, Portoguese, Russian, Simplified Chinese, Arabic, Spanish, and English.
- Tamil, Japanese Japanese_vert, and Arabic for script.

## How to Install

```
git clone https://github.com/thortex/rpi3-tesseract.git
cd rpi3-tesseract
cd release
./install_requires_related2leptonica.sh
./install_requires_related2tesseract.sh
./install_tesseract.sh
```

## Supported Hardwares

| Board                 | Support |
|:----------------------|:--------|
| 3 Model B+            | May Yes |
| 3 Model B             | Yes     |
| 2 Model B v1.2        | May Yes |
| 2 Model B             | No      |
| 1 Model B+            | No      |
| 1 Model B             | No      |
| Model A               | No      |
| Model A+              | No      |
| Zero                  | No      |
| Zero W                | No      |
| Computer Module 1     | No      |
| Computer Module 3     | May Yes |
| Computer Module 3 Lite| May Yes |

## How to Build

```
cd setup
./019_checkinstall.sh
./070_tesseract.sh
```

### CXXFLAGS

| Option | Value                |
|:-------|:---------------------|
|-mtune  | cortex-a53           |
|-march  | armv8-a+crc          |
|-mcpu   | cortex-a53           |
|-mfpu   | crypto-neon-fp-armv8 |


