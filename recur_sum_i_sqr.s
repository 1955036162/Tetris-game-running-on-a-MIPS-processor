.align 2

.text		
foo:
	subu	$sp, $sp, 32	# stack frame 32 bytes
	sw	$ra, 20($sp)	# save return address
	sw	$fp, 16($sp)	# save old frame pointer
	addu	$fp, $fp, 16	# set up new frame pointer
	
	move	$v0, $zero	# clear return value
	slti	$t0, $a0, 101
	beq	$t0, $zero, done	# if > 100 donot recurse

	mul	$t1, $a0, $a0	# i*i
	sw	$t1, 12($sp)	# save multiply
	addi	$a0, $a0, 1	# i++
	jal	foo		# recurse
	lw	$t1, 12($sp)	# restore multiply
	add	$v0, $v0, $t1	# sum += i*i
	
done:	
	lw	$fp, 16($sp)	# restore old frame ptr
	lw	$ra, 20($sp)	# restore return address
	addu	$sp, $sp, 32	# remove frame		
	jr	$ra
			
.text
.globl main
main:	
	subu	$sp, $sp, 32	# stack frame 32 bytes
	sw	$ra, 20($sp)	# save return address
	sw	$fp, 16($sp)	# save old frame pointer
	addu	$fp, $fp, 16	# set up new frame pointer

	li	$v0, 4		# 4 = print string
	la	$a0, mystr	# load address of string
	syscall			# print string
	li	$a0, 0		# initialize $i
	jal	foo		# call foo
	move	$a0, $v0	# put result in $a0
	li	$v0, 1		# 1 = print int
	syscall			# print int
	li	$v0, 4		# 4 = print string
	la	$a0, endl	# load address of endl
	syscall			# print string

	lw	$fp, 16($sp)	# restore old frame ptr
	lw	$ra, 20($sp)	# restore return address
	addu	$sp, $sp, 32	# remove frame		
	jr	$ra
	
.data

mystr:	.asciiz "The answer is "
endl:	.asciiz "\n"

