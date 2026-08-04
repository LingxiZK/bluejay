#!/usr/bin/env bash
# 重载版 ESC 固件编译脚本
# 修改: RPM_POWER_SLOPE=10, STARTUP_POWER_MAX=110, DEMAG=2, TIMING=2, BEEP=0
# 用途: 增加负载时的启动力度，尽量保持巡航效率

set -e
cd "$(dirname "$0")"

echo "=== 当前设置 ==="
grep -n "^DEFAULT_PGM_" src/Settings/BluejaySettings.asm
echo ""

# 关闭启动音
sed -i 's/Eep_Pgm_Beep_Melody: .*/Eep_Pgm_Beep_Melody: DB 255/' src/Bluejay.asm

# 顺时针 (m1-m3)
sed -i 's/^DEFAULT_PGM_DIRECTION EQU ./DEFAULT_PGM_DIRECTION EQU 1/' src/Settings/BluejaySettings.asm
touch src/Settings/BluejaySettings.asm

rm -Rf build
make clean LAYOUT=O MCU=H DEADTIME=10 PWM=48 single_target
built_file=$(ls build/hex/*.hex | head -n 1)
cp "$built_file" "cfbl2.1_esc_heavy_normal_m1-m3.hex"
echo "✅ normal: cfbl2.1_esc_heavy_normal_m1-m3.hex"

# 逆时针 (m2-m4)
sed -i 's/^DEFAULT_PGM_DIRECTION EQU ./DEFAULT_PGM_DIRECTION EQU 2/' src/Settings/BluejaySettings.asm
touch src/Settings/BluejaySettings.asm

rm -Rf build
make clean LAYOUT=O MCU=H DEADTIME=10 PWM=48 single_target
built_file=$(ls build/hex/*.hex | head -n 1)
cp "$built_file" "cfbl2.1_esc_heavy_reverse_m2-m4.hex"
echo "✅ reverse: cfbl2.1_esc_heavy_reverse_m2-m4.hex"

echo ""
echo "=== 编译完成 ==="
ls -lh cfbl2.1_esc_heavy_*.hex
echo ""
echo "烧录命令:"
echo "  M1-M3(正转): cfloader flash cfbl2.1_esc_heavy_normal_m1-m3.hex esc"
echo "  M2-M4(反转): cfloader flash cfbl2.1_esc_heavy_reverse_m2-m4.hex esc"
