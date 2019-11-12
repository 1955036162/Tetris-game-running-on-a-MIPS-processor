# Example for ECE 550 (thanks to Prof. Alvin Lebeck)
# Program to add together list of 9 numbers
# Updated by Tyler Bletsch 2016-05-22
.text                   # Code
.align 2        
.globl main
main:                           # MAIN procedure Entrance
        subu    $sp, 20         #\ Push the stack
        sw      $ra, 16($sp)    # \ Save return address
        sw      $s3, 12($sp)    #  \
        sw      $s2,  8($sp)    #   > Entry Housekeeping
        sw      $s1,  4($sp)    #  /  save registers on stack
        sw      $s0,  0($sp)    # /
        move    $v0, $0         #/ initialize exit code to 0
        move    $s1, $0         #\
        la      $s0, list       # \ Initialization
        la      $s2, msg        # /
        la      $s3, list+36    #/
#                        Main code segment

again:                          #   Begin main loop
        lw      $t6, 0($s0)     #\
        addu    $s1, $s1, $t6   #/  Actual work
                                #    SPIM I/O
        li      $v0, 4          #\
        move    $a0, $s2        # >  Print a string
        syscall                 #/
        li      $v0, 1          #\
        move    $a0, $s1        # >  Print a number
        syscall                 #/
        li      $v0, 4          #\
        la      $a0, nln        # > Print a string (eol)
        syscall                 #/
                                
        addu    $s0, $s0, 4       #\ index update and
        bne     $s0, $s3, again   #/  end of loop


#                        Exit Code
        
        move    $v0, $0         #\
        lw      $s0,  0($sp)    # \
        lw      $s1,  4($sp)    #  \
        lw      $s2,  8($sp)    #   \ Closing Housekeeping
        lw      $s3, 12($sp)    #   /   restore registers
        lw      $ra, 16($sp)    #  / load return address
        addu    $sp, 20         # / Pop the stack
        jr      $ra             #/    exit(0) ;
.end    main                    #  end of program 

#                Data Segment

.data                   # Start of data segment
list:   .word   35, 16, 42, 19, 55, 91, 24, 61, 53
msg:    .asciiz "The sum is "
nln:    .asciiz "\n"

