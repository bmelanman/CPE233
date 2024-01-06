.text
##########################
# Program:
#       Toggle LEDs on Interrupt
# Brief:
#       Toggles each of the 16 LEDs if the LED's corresponding
#       switch is HIGH when an interrupt occurs. If the switches 
#       are not changed between two interrupts, all LEDs are turned
#       off until `Button 0` is pressed.
# Modifies:
#       s0, t0, t1
#Start####################
MAIN:
    li s0, 0x11000000   # Load switches address
    
    mv s3, x0           # Clear s3 for switch comparisons

    la t0, ISR          # Get the ISR address
    csrrw x0, mtvec, t0 # Store the address to mtvec
    csrw mstatus, x0    # Clear mstatus
    call TOGGLE_ISR     # Enable interrupts

RUN:
    j RUN               # Wait for an interrupt

STOP:
    call TOGGLE_ISR     # Disable the ISR
LOOP:
    lw   t0, 0x200(s2)  # Read from the buttons
    andi t0, t0, 1      # Get button 0 (bit 0)
    beqz t0, LOOP       # Loop until its pressed (bit 0 == 1)

    sw s3, 0x20(s0)     # Write the prev switches to the LEDs
    call TOGGLE_ISR     # Re-enable the ISR

    j  RUN              # Resume normal operation

ISR:
    lw t0, 0x00(s0)     # Read switches

    beq t0, s3, STOP    # Stop if current switches are equal to previous

    lw t1, 0x20(s0)     # Read current LED values
    xor t1, t0, t1      # Toggle the LEDs

    mv s3, t1           # Save a copy of the switches for comparison
    sw t1, 0x20(s0)        # Write the new values back to the LEDs

    j RUN               # Return from the interrupt

##########################
# Subroutine: Toggle Interrupts
# Modifies: t0, t1
###Start##################
TOGGLE_ISR:
    li    t0, 0x8           # Bit 4 -> ISR_EN flag
    csrrc t1, mstatus, t0   # Read mstatus and clear ISR_EN
    andi  t1, t1, t0        # Mask ISR_EN
    xori  t1, t1, t0        # Toggle ISR_EN
    csrrs x0, mstatus, t1   # Write ISR_EN
    ret
###End####################