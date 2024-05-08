.psx
.create "factorial.bin", 0x80010000
.org 0x80010000

Main:
	li $a0, 6 ; num
	jal Factorial
	nop

LoopForever:
	j LoopForever
	nop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Subroutine to compute the factorial ;;
;; Arg: num ($a0)                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Factorial:
	li $t1, 1 ; i
	li $t3, 1 ; temp
	li $t4, 1 ; sum

WhileOutter:
	bgt $t1, $a0, WhileOuterEnd
	nop

	move $t4, $zero
	move $t2, $zero

WhileInner:
	bge $t2, $t1, WhileInnerEnd
	nop

	add $t4, $t4, $t3
	addi $t2, $t2, 1
	j WhileInner
	nop

WhileInnerEnd:
	move $t3, $t4
	addi $t1, $t1, 1

	j WhileOutter
	nop

WhileOuterEnd:
	move $v0, $t4
	; Return from the subroutine
	jr $ra

End:
.close
