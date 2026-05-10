;**** **** **** **** **** **** **** **** **** **** **** **** ****
;
; Bluejay digital ESC firmware for controlling brushless motors in multirotors
;
; Copyleft  2022-2023 Daniel Mosquera
; Copyright 2020-2022 Mathias Rasmussen
; Copyright 2011-2017 Steffen Skaug
;
; This file is part of Bluejay.
;
; Bluejay is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; Bluejay is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with Bluejay.  If not, see <http://www.gnu.org/licenses/>.
;
;**** **** **** **** **** **** **** **** **** **** **** **** ****
;
; Programming defaults
;
;**** **** **** **** **** **** **** **** **** **** **** **** ****

DEFAULT_PGM_RPM_POWER_SLOPE EQU 6       ; 0=Off,1..13 (Power limit factor in relation to rpm)
DEFAULT_PGM_COMM_TIMING EQU 3
DEFAULT_PGM_DEMAG_COMP EQU 3
DEFAULT_PGM_DIRECTION EQU 2
DEFAULT_PGM_BEEP_STRENGTH EQU 0
DEFAULT_PGM_BEACON_STRENGTH EQU 80      ; 0..255
DEFAULT_PGM_BEACON_DELAY EQU 5          ; 1=1m 2=2m 3=5m 4=10m 5=Infinite
DEFAULT_PGM_ENABLE_TEMP_PROT EQU 2

DEFAULT_PGM_POWER_RATING EQU 1          ; 1=1S,2=2S+

DEFAULT_PGM_BRAKE_ON_STOP EQU 0
DEFAULT_PGM_LED_CONTROL EQU 0           ; Byte for LED control. 2 bits per LED,0=Off,1=On

DEFAULT_PGM_STARTUP_POWER_MIN EQU 115
DEFAULT_PGM_STARTUP_BEEP EQU 1          ; 0=Short beep,1=Melody

DEFAULT_PGM_STARTUP_POWER_MAX EQU 90
DEFAULT_PGM_BRAKING_STRENGTH EQU 30

DEFAULT_PGM_SAFETY_ARM EQU 0            ; EDT safety arm is disabled by default
