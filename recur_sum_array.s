# Example for CPS 104
# Program to add together list of 9 numbers
.text                   # Code
.align 2	
.globl main
main:                           # MAIN procedure Entrance
        subu    $sp, $sp, 40    #\ Push the stack
        sw      $ra, 36($sp)    # \ Save return address
        sw      $s3, 32($sp)    #  \
        sw      $s2, 28($sp)    #   > Entry Housekeeping
        sw      $s1, 24($sp)    #  /  save registers on stack
        sw      $s0, 20($sp)    # /
        sw      $a1, 16($sp)    # /
        sw      $a0, 12($sp)    #/
        move    $v0, $0         #/ initialize exit code to 0
        move    $s1, $0         #\
        la      $a0, list       # \ Initialization
        la      $a1, list+36    # /
        la      $s2, msg        #/
#			Main code segment

	jal sum

	move	$s0, $v0	# save result
        li      $v0, 4          #\
        move    $a0, $s2        # >  Print a string
        syscall                 #/
        li      $v0, 1          #\
        move    $a0, $s0        # >  Print a number
        syscall                 #/
        li      $v0, 4          #\
        la      $a0, nln        # > Print a string (eol)
        syscall                 #/

#			Exit Code
        
	move    $v0, $0         #\
        lw      $s0, 20($sp)    # \
        lw      $s1, 24($sp)    #  \
        lw      $s2, 28($sp)    #   \ Closing Housekeeping
        lw      $s3, 32($sp)    #   /   restore registers
        lw      $ra, 36($sp)    #  / load return address
        addu    $sp, 40         # / Pop the stack
        jr      $ra             #/    exit(0) ;
.end    main			#  end of program 

#input parameters are starting address and ending address
.globl sum

sum:                            #   Begin function
        subu 	$sp, $sp, 40	# create stack frame
	sw	$ra, 36($sp)	# save return address

        lw      $t6, 0($a0)     #\  get first number
        addu    $v0, $v0, $t6   #/  Actual work
                                #    SPIM I/O
                                
        addu    $a0, $a0, 4     #\ index update and
        beq     $a0, $a1, done  #/  check for recursive call

	jal sum			# recursive call

done:
	lw	$ra, 36($sp)	# save return address
        addu 	$sp, $sp, 40	# create stack frame
	jr $ra			# return

#		Data Segment

.data                   # Start of data segment
list:   .word   35, 16, 42, 19, 55, 91, 24, 61, 53
msg:    .asciiz "The sum is "
nln:    .asciiz "\n"
