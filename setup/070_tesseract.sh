#!/bin/bash -x

LEPT_VER=1.76.0
LEPT_URL=https://github.com/DanBloomberg/leptonica/releases/download/
LEPT_SRC=leptonica-${LEPT_VER}.tar.gz
LEPT_INS_DIR=/usr/local

TESS_VER=4.0.0-beta.3
TESS_URL=https://github.com/tesseract-ocr/tesseract/archive/
TESS_SRC=${TESS_VER}.tar.gz
TESS_INS_DIR=/usr/local

OPT_FLAGS="-mtune=cortex-a53 -march=armv8-a+crc -mcpu=cortex-a53 -mfpu=crypto-neon-fp-armv8 -mfloat-abi=hard"

function remove_old_pkgs() {
    sudo apt-get remove \
	 liblept5 \
	 libleptonica-dev \
	 libtesseract-dev \
	 libtesseract-data \
	 libtesseract3 \
	 tesseract-ocr \
	 tesseract-ocr-eng \
	 tesseract-ocr-equ \
	 tesseract-ocr-jpn \
	 tesseract-ocr-osd
}

function prepare_for_build() {
    sudo apt-get install \
	 asciidoc \
	 gawk \
	 g++ \
	 make \
	 asciidoc \
	 autoconf \
	 autoconf-archive \
	 automake \
	 libtool \
	 pkg-config \
	 libpng-dev \
	 libjpeg-dev \
	 libtiff5-dev \
	 libwebp-dev \
	 zlib1g-dev \
	 libopenjp2-7-dev 
}

function build_leptonica() {
    wget -c ${LEPT_URL}${LEPT_VER}/${LEPT_SRC}
    tar xzf ${LEPT_SRC}
    cd leptonica-${LEPT_VER}
    ./configure \
	--prefix=${LEPT_INS_DIR} \
	--enable-shared=yes \
	--with-zlib \
	--with-libpng \
	--with-jpeg \
	--with-libtiff \
	--with-libwebp \
	--with-libopenjpeg \
	CFLAGS="$OPT_FLAGS"
    make 
}

function install_leptonica() {
    sudo checkinstall -D \
	 --install=yes \
	 --pkgname=leptonica \
	 --provides=leptonica \
	 --pkgversion=${LEPT_VER}
    mv leptonica_${LEPT_VER}-1_armhf.deb ../../release
    cd ..
}

function build_tesseract() {
    wget -c ${TESS_URL}${TESS_SRC}
    tar xzf ${TESS_SRC}
    cd tesseract-${TESS_VER}
    ./autogen.sh
    ./configure \
	--prefix=${TESS_INS_DIR} \
	--enable-embedded=yes \
	--enable-openmp=yes \
	--enable-shared=yes \
	CXXFLAGS="$OPT_FLAGS" \
	CFLAGS="$OPT_FLAGS"
    make
}

function install_tesseract() {
    sudo mkdir /usr/local/share/tessdata
    sudo checkinstall -D \
	 --install=yes \
	 --pkgname=tesseract-ocr \
	 --provides=tesseract-ocr \
	 --pkgversion=${TESS_VER}
    mv tesseract-ocr_${TESS_VER}-1_armhf.deb ../../release/
    cd ..
    sudo ldconfig
}

function get_tessdata() {
    git clone https://github.com/tesseract-ocr/tessdata_fast.git
}

function install_tessdata() {
    D=/usr/local/share/tessdata
    cd tessdata_fast
    # Italian, Tamil, Swahili, Persian, Malay, Hindi, Japanese, German, 
    # Portoguese, Russian, Simplified Chinese, Arabic, Spanish, English
    echo -e "install:" > Makefile
    echo -e "\tmkdir $D" >> Makefile
    for l in ita tam swa fas msa hin jpn jpn_vert deu por rus chi_sim \
		 chi_sim_vert ara spa fra eng osd; do
	echo -e "\tinstall ${l}.traineddata $D" >> Makefile
    done
    sudo checkinstall -D \
	 --install=yes \
	 --pkgname=tesseract-data \
	 --provides=tesseract-data \
	 --pkgversion=${TESS_VER}
    mv tesseract-data_${TESS_VER}-1_armhf.deb ../release
    cd script
    D=/usr/local/share/tessdata/script
    echo -e "install:" > Makefile
    echo -e "\tmkdir $D" >> Makefile
    for l in Tamil Japanese Japanese_vert Arabic; do
	echo -e "\tinstall ${l}.traineddata $D" >> Makefile
    done
    sudo checkinstall -D \
	 --install=yes \
	 --pkgname=tesseract-script-data \
	 --provides=tesseract-script-data \
	 --pkgversion=${TESS_VER}
    mv tesseract-script-data_${TESS_VER}-1_armhf.deb ../../release
    cd ../..
}

remove_old_pkgs;
prepare_for_build;
build_leptonica;
install_leptonica;
build_tesseract;
install_tesseract;
get_tessdata;
install_tessdata;
exit;
