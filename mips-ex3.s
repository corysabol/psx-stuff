.psx
.create "mips-ex3.bin", 0x80010000
.org 0x80010000

Main:
	move $t2, $zero ; init res
	li $t0, 0x1B	; numerator
	li $t1, 0x03	; denominator

While:
	blt   $t0, $t1, EndWhile ; If $t0 < $t1, end while
	nop			 ; needed after branch
	subu  $t0, $t0, $t1	 ; $t0 = $t0 - St1
	addiu $t2, $t2, 0x01	 ; $t2++
	b While			 ; Unconditional branch to While loop label above
	nop			 ; needed after branch

EndWhile:
Exit:
.close
