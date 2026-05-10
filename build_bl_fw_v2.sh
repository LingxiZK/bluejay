#!/usr/bin/env bash
# v2: 修复抖动 - DEMAG_COMP=Low, COMM_TIMING=MediumLow, PWM=48kHz

run_dir=$(pwd)
script_dir=$(dirname $(realpath $0))
source_path=$script_dir/..
tmpdir=$(mktemp -d 2>/dev/null || mktemp -d -t 'mytmpdir')

trap clean INT

function clean() {
    echo "Done"
    exit
}

pushd $source_path > /dev/null

# 关闭启动音
sed -i 's/Eep_Pgm_Beep_Melody: .*/Eep_Pgm_Beep_Melody: DB 255/' src/Bluejay.asm

# 方案: DEMAG_COMP=2(Low), COMM_TIMING=2(MediumLow), BEEP=0
sed -i 's/^DEFAULT_PGM_DEMAG_COMP EQU .*/DEFAULT_PGM_DEMAG_COMP EQU 2/' src/Settings/BluejaySettings.asm
sed -i 's/^DEFAULT_PGM_COMM_TIMING EQU .*/DEFAULT_PGM_COMM_TIMING EQU 2/' src/Settings/BluejaySettings.asm
sed -i 's/^DEFAULT_PGM_BEEP_STRENGTH EQU .*/DEFAULT_PGM_BEEP_STRENGTH EQU 0/' src/Settings/BluejaySettings.asm

# 顺时针 (m1-m3) 
sed -i 's/^DEFAULT_PGM_DIRECTION EQU ./DEFAULT_PGM_DIRECTION EQU 1/' src/Settings/BluejaySettings.asm
touch src/Settings/BluejaySettings.asm

rm -Rf build
make clean LAYOUT=O MCU=H DEADTIME=10 PWM=48 single_target
built_file=$(ls build/hex/*.hex | head -n 1)
cp "$built_file" "$run_dir/cfbl2.1_esc_v2_normal_m1-m3.hex"

# 逆时针 (m2-m4)
sed -i 's/^DEFAULT_PGM_DIRECTION EQU ./DEFAULT_PGM_DIRECTION EQU 2/' src/Settings/BluejaySettings.asm
touch src/Settings/BluejaySettings.asm

rm -Rf build
make clean LAYOUT=O MCU=H DEADTIME=10 PWM=48 single_target
built_file=$(ls build/hex/*.hex | head -n 1)
cp "$built_file" "$run_dir/cfbl2.1_esc_v2_reverse_m2-m4.hex"

clean
popd > /dev/null
