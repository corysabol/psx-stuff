.psx
.create "hellogpu.bin", 0x80010000
.org 0x80010000

;--------------------
; IO Port
;--------------------
IO_BASE_ADDR equ 0x1F80

;--------------------
; GPU Registers
;--------------------
GP0 equ 0x1810
GP1 equ 0x1814

Main:
	lui $t0, IO_BASE_ADDR
	
	;; Display control setup
	;; ----------------------------------------
	;; 1. GP1: Reset GPU
	li $t1, 0x00000000	; Command 0x00 reset gpu
	sw $t1, GP1($t0)		; Write the previous gpu packet to GP1

	;; 2. GP2: Display enable
	li $t1, 0x03000000	; 03..00 enable display
	sw $t1, GP1($t0)		; write the command to GP1

	;; 3. GP1: Display mode (320x240, 15-bit, NTSC)
	li $t1, 0x08000001
	sw $t1, GP1($t0)

	;; 4. GP1: Horizontal range
	li $t1, 0x06C60260
	sw $t1, GP1($t0)

	;; 5. GP1: Vertical range
	li $t1, 0x07042018
	sw $t1, GP1($t0)

	;; VRAM Access
	;; Send commands to GP0 to setup the drawing area
	;; (Command = 8-bit msb, Parameter = 24-bit lsb)
	;; CCPPPPPP CC=Command PP=Parameter
	;; ----------------------------------------
	li $t1, 0xE1000400		; E1 = Draw mode settings
	sw $t1, GP0($t0)

	li $t1, 0xE3000000		; E3 = Drawing area top left %YYYYYYYYYYXXXXXXXXXX (10 bit for Y and 10 for X)
	sw $t1, GP0($t0)

	li $t1, 0xE403BD3F		; E4 = Drawing area bottom right - same arg format as above
	sw $t1, GP0($t0)

	li $t1, 0xE5000000		; E5 = Drawing offset - %YYYYYYYYYYXXXXXXXXXX
	sw $t1, GP0($t0)

	;; Clear the screen
	;; ----------------------------------------
	;; 1. GP0: Fill rectangle on the display area
	;; Memory transfer command - GP0(02) Fill rectangle in VRAM
	
	;; Set the color
	li $t1, 0x020000FF	; 02 = Fill Rect in VRAM (Param Color)
	sw $t1, GP0($t0)
	;; Set the top left corner
	li $t1, 0x00000000
	sw $t1, GP0($t0)
	;; Set the Width+Height
	li $t1, 0x00EF013F
	sw $t1, GP0($t0)

	;; Draw a flat-shaded triangle
	;; ----------------------------------------
	
LoopForever:
	j LoopForever
	nop
	
Exit:
.close
