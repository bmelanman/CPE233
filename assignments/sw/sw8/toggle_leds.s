.text
##########################
# Program:
#       Toggle LEDs on Interrupt
# Brief:
#       Toggles each of the 16 LEDs if the LED's corresponding
#       switch is HIGH when an interrupt occurs.
# Modifies:
#       s0, t0, t1
#Start####################
MAIN:
    # Load Addresses
    li s0, 0x11000000       # Load switches address
    la t0, ISR              # Get the ISR address

    # Enable Interrupts
    csrrw x0, mtvec, t0     # Store the address to mtvec
    li t0, 8                # Load interrupt enable flag
    csrrw x0, mstatus, t0   # Set the enable interrupts flag

WAIT:
    # Wait for an interrupt
    j WAIT

ISR:
    lw t0, 0x00(s0)    # Read switches
    lw t1, 0x20(s0)    # Read current LED values

    xor t1, t0, t1  # Toggle the LEDs

    sw t1, 0x20(s0)    # Write the new value back to the LEDs
    mret            # Return from the interrupt