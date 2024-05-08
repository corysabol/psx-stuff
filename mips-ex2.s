.psx
.create "mips-ex2.bin", 0x80010000
.org 0x80010000

Main:
	li $t0, 0x01 ; load 1
	move $t1, $zero

Loop:
	add  $t1, $t0, $t1	; add $t0 to $t1 and store in $t1
	addi $t0, $t0, 1	; increment the counter
	ble  $t0, 10, Loop	; if t0 <= t2
	nop			; nop delay after branch is needed

End:
.close
