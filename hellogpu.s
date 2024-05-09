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

lui $a0, IO_BASE_ADDR
;; Invoke subroutine to draw a flat triangle
li $s0, 0xFFFF00	; Param Color
li $s1, 200				; x1
li $s2, 40				; y1
li $s3, 288				; x2
li $s4, 56				; y2
li $s5, 224				; x3
li $s6, 200				; y3
jal DrawFlatTriangle
nop

LoopForever:
	j LoopForever
	nop
	
;; Flat triangle subroutine
;; ----------------------------------------
;; Args:
;; $a0 = IO_BASE_ADDR (IO ports at 0x1F80****)
;; $s0 = Color (Ex: 0xBBGGRR)
;; $s1 = x1
;; $s2 = y1
;; $s3 = x2
;; $s4 = y2
;; $s5 = x3
;; $s6 = y3
;; ----------------------------------------
DrawFlatTriangle:
	lui $t0, 0x2000		; Command: 0x20 Flat triangle
	or	$t1, $t0			; Command | Color
	sw	$t1, GP0($a0)	; Write to GP0 (Command + Color)

	; Vertex 1
	sll		$s2, $s2, 16			; y1 <<= 16
	andi	$s1, $s1, 0xFFFF	; x1 &= 0xFFFF
	or		$t1, $s1, $s2			; x1 | y1
	sw		$t1, GP0($a0)			; Write to GP0 (Vertex 1)

	; Vertex 2
	sll		$s4, $s4, 16			; y2 <<= 16
	andi	$s3, $s3, 0xFFFF	; x2 &= 0xFFFF
	or		$t1, $s3, $s4			; x2 | y2
	sw		$t1, GP0($a0)			; Write to GP0 (Vertex 2)

	; Vertex 3
	sll		$s6, $s6, 16			; y3 <<= 16
	andi	$s5, $s5, 0xFFFF	; x3 &= 0xFFFF
	or		$t1, $s5, $s6			; x3 | y3
	sw		$t1, GP0($a0)			; Write to GP0 (Vertex 3)

	; return to caller
	jr $ra
	nop

Exit:
.close
