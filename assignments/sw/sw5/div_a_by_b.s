.data
    IN_A: .word 0x420
    IN_B: .word 0x69
    # 0x420 / 0x69 = 0xA rem 0x6

.text
    lw t0, IN_A         # Input A
    lw t1, IN_B         # Input B
    mv t2, x0           # Quotient (Q)

    beqz t0, END        # 0 / N = 0r0
    beqz t1, ERR        # N / 0 = 0r0

SUB:
    blt  t0, t1, END    # If A < B, goto END
    sub  t0, t0, t1     # A -= B;
    addi t2, t2, 1      # Q += 1;
    j SUB               # Loop!

ERR:
    mv t0, x0           # Set A = 0

END:
    li s0, 0x11000000   # MMIO Address
    sw t2, 0x40(s0)     # Store the Quotient to the 7-Seg
    sw t0, 0x20(s0)     # Store the Remainder (A) to the LEDs