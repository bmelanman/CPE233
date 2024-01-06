.data
    IN_A:  .word 0x3A6C
    #IN_A:  .word 0xFFFFF
    OUT_A: .word

.text
##########################
# Program:
#       Binary Coded Decimal (BCD) Converter
# Brief:
#       Reads a 16-bit unsigned value from the input array address in the data segment
#       and converts it to BCD (binary coded decimal) form using the DIV10 subroutine.
# Modifies:
#       s0, s1, a0
#Start####################
MAIN:
    lhu a0, IN_A         # Input (A uint16 hex value)
    mv  s0, x0           # Number of bytes to shift
    mv  s1, x0           # Output (The input in BCD form)

LOOP:
    beqz a0, END        # Repeat until empty

    call DIV10         # Divide input by 10 (DIV10 subroutine call)

    sll a1, a1, s0      # Shift remainder a byte per tens place
    addi s0, s0, 4      # Increment byte shift after each tens place
    add s1, s1, a1      # Add to the output

    j LOOP              # Loop!

##########################
# Subroutine: Divide a given Numerator by 10
# Modifies: a0, a1, t1, t2
# Args:
#       a0 - Numerator
# Ret:
#       a0 - Quotient
#       a1 - Remainder
###Start##################
DIV10:
    beq  a0, x0, RET    # Check for input = 0

    mv t1, a0           # Copy input to calc (input * 0x199A)
    mv a1, a0           # Copy input to find remainder at the end
    mv a0, x0           # Clear the quotient

##### Error correction
    li t2, 0x4000       
    sltu t3, t2, t1
    sub t1, t1, t3

    li t2, 0x8000
    sltu t3, t2, t1
    sub t1, t1, t3

    li t2, 0xc000
    sltu t3, t2, t1
    sub t1, t1, t3

    li t2, 0x199A       # ( (1 << 16) / 10 ) = 0x199A

##### Calculate quotient = ( input * 0x199A ) >> 16
DIV10_LOOP:             # Calculate ( input * 0x199A )
    andi t3, t2, 0x1    # if ( t2 & 0xF == 1) { a0 += t1; }
    beqz t3, DIV10_SKIP_ADD
    add a0, a0, t1

DIV10_SKIP_ADD:
    slli t1, t1, 1      # t1 <<= 1
    srli t2, t2, 1      # t2 >>= 1
    bnez t2, DIV10_LOOP # Loop while ( t2 != 0 )

    srli a0, a0, 16     # Calculate ( Q >> 16 )

##### Calculate remainder = divisor - ( q * 2 ) - ( q * 8 )
    slli t2, a0, 1      # q * 2
    sub a1, a1, t2      # d -= ( q * 2 )

    slli t2, t2, 2      # q * 8
    sub a1, a1, t2      # d -= ( q * 8 )

RET:
    ret
###End####################

END:
    la s0, OUT_A        # Output Address
    sw s1, 0x0(s0)      # Store the BCD to the output array
#End####################