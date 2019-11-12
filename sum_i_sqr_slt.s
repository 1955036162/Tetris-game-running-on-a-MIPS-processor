# NOTE this program does not follow calling conventions
	.text
	.align	2
main:
	move 	$14, $0 # i = 0
	move 	$15, $0 # tmp = 0
	move 	$16, $0 # sum = 0


loop:	
	slti	$17, $14, 101	# set if i < 101
	beqz	$17, loop_end
	mul	$15, $14, $14 	# i*i
	add	$16, $16, $15 	# sum+i*i
	addi	$14, $14, 1   	# i++
	b	loop		# go do it again
	
loop_end:
	li	$v0, 4		# 4 = print string
	la	$a0, mystr	# load address of string
	syscall			# print string
	move	$a0, $16	# put result in $a0
	li	$v0, 1		# 1 = print int
	syscall			# print int
	li	$v0, 4		# 4 = print string
	la	$a0, endl	# load address of endl
	syscall			# print string
	jr	$ra	# return 

.data

mystr:  .asciiz "The answer is "
endl:   .asciiz "\n"

