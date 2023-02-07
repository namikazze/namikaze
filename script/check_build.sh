#!/usr/bin/env bash

msg() {
    echo -e "\e[1;32m$*\e[0m"
}

name_rom=$(grep init $CIRRUS_WORKING_DIR/build.sh -m 1 | cut -d / -f 4)
device=$(grep lunch $CIRRUS_WORKING_DIR/build.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)

build_gagal=$(grep 'FAILED:' $WORKDIR/rom/$name_rom/build.log -m1 || true)
if [[ $build_gagal == *'FAILED:'* ]]; then
    cd $WORKDIR/rom/$name_rom
    msg ⛔ Build gagal...
    curl -F document=@build.log "https://api.telegram.org/bot${TG_TOKEN}/sendDocument" \
    -F chat_id="${TG_CHAT_ID}" \
    -F "disable_web_page_preview=true" \
    -F "parse_mode=html" \
    -F caption="⛔ ${device} Build $name_rom error..."
fi

build_berhasil=$(grep '#### build completed successfully' $WORKDIR/rom/$name_rom/build.log -m1 || true)
if [[ $build_berhasil == *'#### build completed successfully'* ]]; then
    msg ✅ Build selesai 100%
else
    msg ❌ Build belum selesai...
    echo Build ROM gagal! kami melanjutkan dengan mengunggah ccache...
fi
