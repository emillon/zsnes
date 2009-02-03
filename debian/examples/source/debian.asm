; Copyright (C) 2001 Steven Fuller <relnev@atdot.org>
;
; This program is free software; you can redistribute it and/or
; modify it under the terms of the GNU General Public License
; as published by the Free Software Foundation; either version 2
; of the License, or (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
;
; See the GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

.org $8000
.nmi _nmi
.reset Start
.name "Debian Demo "

; v1.0
; Show a logo

Start:
	sei 
	phk
	pld
	clc
	xce

	rep #$30	; X/Y = 16, A = 8
	sep #$20

	jsr vblwait
	
	jsr CommonInit
	
	lda #$01  ; Mode 1
	sta $2105
	
	lda #$01
	sta $4200
	lda #$ff
	sta $4201	
	lda #$81	; Initialize control pad
	sta $4212


	stz $2133


	ldy #$0000
	ldx #$0000
	stz $2121
setpal:	
	lda PAL,x
	sta $2122	; 1st byte
	inx		; next
	lda PAL,x	; 2nd byte
	sta $2122
	inx	
	iny
	cpy PALc
	bne setpal	; no? try again

	lda #$01	; Activate BG1
	sta $212C

	lda #$80
	sta $2115
	
; BG1 Tilemap (at $0000)	
;	lda #$00        ; BG1 tilemap pos
;	sta $2107
;	
;	ldx #$1000
;	stx $2116
;	ldx #$0000
;ll2:
;	ldy TILEMAP, x
;	sty $2118
;	inx
;	inx
;	cpx #$0800
;	bne ll2

; BG1 Tilemap (at $0000)
	lda #$00
	sta $2107
	
	ldx #$0000
	stx $2116

	ldx #$1801
	stx $4300
	ldx #TILEMAP
	stx $4302
	lda #$00
	sta $4304
	ldx #$0800
	stx $4305
	lda #$01
	sta $420B

; BG1 Tiledata (at $1000)
	lda #$01
	sta $210B
		
	ldx #$1000
	stx $2116
	
	ldx #$1801
	stx $4300
	ldx #TILES
	stx $4302
	lda #$00
	sta $4304
	ldx TILESc
	stx $4305
	lda #$01
	sta $420B

; BG1 Tile data (at $1000)
;	lda #$01
;	sta $210B
;	
;	ldx #$2000
;	stx $2116 
;	
;	ldx #$0000
;ll1:	
;	ldy TILES, x
;	sty $2118
;	inx
;	inx
;	cpx TILESc
;	bmi ll1

	;jsr vblwait
				
	lda #%00001111	; turn the screen on
	sta $2100	
	
	cli		; enable interrupts, i guess

			
main:
	jsr vblwait
_joypad:
	lda $4212
	and #$01
	bne _joypad
	lda $4219
	and #$10
	beq main

	jmp main

vblwait:
;	clc
;	lda $4210
;	adc #$80
;	bcc _vblwait
	lda $4210
	bpl vblwait
	lda $4210
	rts

; Just set some stuff to default values
CommonInit:
	lda #$80
	sta $2100
        stz $2101
        stz $2102
        stz $2103
        stz $2104
        stz $2105
        stz $2106
        stz $2107
        stz $2108
        stz $2109
        stz $210a
        stz $210b
        stz $210c
        stz $210d
        stz $210d
        stz $210e
        stz $210e
        stz $210f
        stz $210f
        stz $2110
        stz $2110
        stz $2111
        stz $2111
        stz $2112
        stz $2112
        stz $2113
        stz $2113
        stz $2114
        stz $2114
        lda #$80
        sta $2115
        stz $2116
        stz $2117
        stz $211a
        stz $211b
        lda #$01
        sta $211b
        stz $211c
        stz $211c
        stz $211d
        stz $211d
        stz $211e
        lda #$01
        sta $211e
        stz $211f
        stz $211f
        stz $2120
        stz $2120
        stz $2121
        stz $2123
        stz $2124
        stz $2125
        stz $2126
        stz $2127
        stz $2128
        stz $2129
        stz $212a
        stz $212b
        stz $212c
        stz $212d
        stz $212e
        stz $212f
        stz $4200
        lda #$ff
        sta $4201
        stz $4202
        stz $4203
        stz $4204
        stz $4205
        stz $4206
        stz $4207
        stz $4208
        stz $4209
        stz $420a
        stz $420b
        stz $420c
        stz $420d
        rts

PALc: 	.dw 16
PAL:	.incbin "deb.col"

TILESc:	.dw 9696
TILES:	
.incbin "deb.set"

TILEMAP: ; 2048 bytes
.incbin "deb.map"

_nmi: rti


; ZSNES hack (so it shows up as lorom)
.bank 1
.org $FFF0
.db $00, $00, $00, $00, $00, $00, $00, $00
.db $00, $00, $00, $00, $00, $00, $00, $00
