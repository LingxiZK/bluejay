#!/usr/bin/env bash
# 1202.5 电机 (11000KV) + 1S 电池 + GF 65R 桨 最优配置编译脚本
# 机型: Lingxi BL (67g 轻载悬停优化)
#
# 参数配置:
#   POWER_RATING=1       (1S 电池低压保护匹配)
#   RPM_POWER_SLOPE=8    (推力富余,限功率保护 MOS)
#   STARTUP_POWER_MAX=96 (高KV电机BEMF强,启动减冲击)
#   COMM_TIMING=2        (MediumLow,轻载高效)
#   DEMAG_COMP=2         (Low,1S低转速退磁不突出)
#   PWM=48kHz            (小电机开关损耗低)
#
# 用法: ./build_esc_1202_1s.sh
# 产物: Lingxi_BL_1202_1S_normal_m1-m3.hex / Lingxi_BL_1202_1S_reverse_m2-m4.hex

set -e
cd "$(dirname "$0")"

echo "=== 1202.5 电机 (11000KV) 1S 最优配置 ==="

# 关闭启动音
sed -i 's/Eep_Pgm_Beep_Melody: .*/Eep_Pgm_Beep_Melody: DB 255/' src/Bluejay.asm

# 应用最优参数
sed -i 's/^DEFAULT_PGM_POWER_RATING EQU .*/DEFAULT_PGM_POWER_RATING EQU 1          ; 1=1S,2=2S+ — 1202电机1S配置/' src/Settings/BluejaySettings.asm
sed -i 's/^DEFAULT_PGM_RPM_POWER_SLOPE EQU .*/DEFAULT_PGM_RPM_POWER_SLOPE EQU 8       ; 0=Off,1..13 — 1202电机推力富余限功率/' src/Settings/BluejaySettings.asm
sed -i 's/^DEFAULT_PGM_STARTUP_POWER_MAX EQU .*/DEFAULT_PGM_STARTUP_POWER_MAX EQU 96    ; 0..255 — 1202电机高KV启动减冲击/' src/Settings/BluejaySettings.asm
sed -i 's/^DEFAULT_PGM_COMM_TIMING EQU .*/DEFAULT_PGM_COMM_TIMING EQU 2           ; 1=Low..5=High — 轻载高效MediumLow/' src/Settings/BluejaySettings.asm
sed -i 's/^DEFAULT_PGM_DEMAG_COMP EQU .*/DEFAULT_PGM_DEMAG_COMP EQU 2            ; 1=Dis,2=Low,3=High — 1S低转速Low降损耗/' src/Settings/BluejaySettings.asm
sed -i 's/^DEFAULT_PGM_BEEP_STRENGTH EQU .*/DEFAULT_PGM_BEEP_STRENGTH EQU 0/' src/Settings/BluejaySettings.asm

echo "=== 当前设置 ==="
grep -n "^DEFAULT_PGM_" src/Settings/BluejaySettings.asm
echo ""

# 顺时针 (m1-m3)
sed -i 's/^DEFAULT_PGM_DIRECTION EQU ./DEFAULT_PGM_DIRECTION EQU 1/' src/Settings/BluejaySettings.asm
touch src/Settings/BluejaySettings.asm

rm -Rf build
make clean LAYOUT=O MCU=H DEADTIME=10 PWM=48 single_target
built_file=$(ls build/hex/*.hex | head -n 1)
cp "$built_file" "Lingxi_BL_1202_1S_normal_m1-m3.hex"
echo "✅ normal: Lingxi_BL_1202_1S_normal_m1-m3.hex"

# 逆时针 (m2-m4)
sed -i 's/^DEFAULT_PGM_DIRECTION EQU ./DEFAULT_PGM_DIRECTION EQU 2/' src/Settings/BluejaySettings.asm
touch src/Settings/BluejaySettings.asm

rm -Rf build
make clean LAYOUT=O MCU=H DEADTIME=10 PWM=48 single_target
built_file=$(ls build/hex/*.hex | head -n 1)
cp "$built_file" "Lingxi_BL_1202_1S_reverse_m2-m4.hex"
echo "✅ reverse: Lingxi_BL_1202_1S_reverse_m2-m4.hex"

echo ""
echo "=== 编译完成 ==="
ls -lh Lingxi_BL_1202_1S_*.hex
echo ""
echo "烧录命令:"
echo "  M1-M3(正转): cfloader flash Lingxi_BL_1202_1S_normal_m1-m3.hex esc"
echo "  M2-M4(反转): cfloader flash Lingxi_BL_1202_1S_reverse_m2-m4.hex esc"
