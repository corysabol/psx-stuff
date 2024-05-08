.psx
.create "mips-ex1.bin", 0x80010000
.org 0x80010000

Main:
	; Load $t0 with imm decimal value 1
	li $t0, 0x01
	li $t1, 0x100
	li $t2, 0x11

End:
.close

