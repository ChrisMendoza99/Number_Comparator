;Written by Christopher A. Mendoza
	.align
	.text
	.global main
;For Port 2
P2IN .field 0x40004C01,32 ; Port 2 Input
P2OUT .field 0x40004C03,32 ; Port 2 Output
P2DIR .field 0x40004C05,32 ; Port 2 Direction
P2REN .field 0x40004C07,32 ; Port 2 Resistor Enable
P2DS .field 0x40004C09,32 ; Port 2 Drive Strength
P2SEL0 .field 0x40004C0B,32 ; Port 2 Select 0
P2SEL1 .field 0x40004C0D,32 ; Port 2 Select 1

;For Port 3
P3IN .field 0x40004C20,32 ; Port 3 Input
P3OUT .field 0x40004C22,32 ; Port 3 Output
P3DIR .field 0x40004C24,32 ; Port 3 Direction
P3REN .field 0x40004C26,32 ; Port 3 Resistor Enable
P3SEL0 .field 0x40004C2A,32 ; Port 3 Select 0
P3SEL1 .field 0x40004C2C,32 ; Port 3 Select 1

;For Port 4
P4IN .field 0x40004C21,32 ; Port 4 Input
P4OUT .field 0x40004C23,32 ; Port 4 Output
P4DIR .field 0x40004C25,32 ; Port 4 Direction
P4REN .field 0x40004C27,32 ; Port 4 Resistor Enable
P4SEL0 .field 0x40004C2B,32 ; Port 4 Select 0
P4SEL1 .field 0x40004C2D,32 ; Port 4 Select 1

;For Port 5
P5IN .field 0x40004C40,32 ; Port 5 Input
P5OUT .field 0x40004C42,32 ; Port 5 Output
P5DIR .field 0x40004C44,32 ; Port 5 Direction
P5REN .field 0x40004C46,32 ; Port 5 Resistor Enable
P5SEL0 .field 0x40004C4A,32 ; Port 5 Select 0
P5SEL1 .field 0x40004C4C,32 ; Port 5 Select 1

RED 	.equ 0x80
BLUE 	.equ 0x20
GREEN 	.equ 0x40

DELAY	.equ 0xFFFF
;------------------------Main function w. Loop--------------------------------------------------------------------------
main:
    mov r4, #0
    mov r5, #0
    bl Port2_Init
    bl Port3_Init
    bl Port4_Init
    bl Port5_Init
loop
;Check for an input
	bl Port5_Input
	cmp r0, #0x40
	beq sw1pressed
	cmp r0, #0x80
	beq sw2pressed
	cmp r0, #0x00
	beq nopressed
;If switch one is pressed go here
sw1pressed
	add r4, r4, #1
	lsl r6, r4, #4
	ldr r1, P4OUT
	mov r0, r6
	mov r8, #DELAY
	bl delay
	strb r0, [r1]
	bl compare_check
	b loop
;If switch two is pressed go here
sw2pressed
	add r5, r5, #1
	lsl r7, r5, #4

	ldr r1, P2OUT
	mov r0, r7
	mov r8, #DELAY
	bl delay
	strb r0, [r1]
	bl compare_check
	b loop
;Otherwise dont do anything
nopressed
	b loop

;--------------------------Here we will check the comparison between the two values-------------------------
compare_check:
	cmp r4, r5
	bgt greater
	cmp r4, r5
	blt less
	cmp r4, r5
	beq equal

greater
	mov r0, #RED
	ldr r1, P3OUT
	strb r0, [r1]
	bx lr
less
	mov r0, #BLUE
	ldr r1, P3OUT
	strb r0, [r1]
	bx lr
equal
	mov r0, #GREEN
	ldr r1, P3OUT
	strb r0, [r1]
	bx lr
;--------------------------Psuedo Delay------------------------------------------------------------------------------
delay:
	nop
	nop
	nop
	nop
	nop
	subs r8, #1
	bne delay
	bx lr
;-----------------------PORT 2 Init-------------------------------------------------------------------------------------
Port2_Init:
    ;For port 2
	ldr r1, P2SEL0
	mov r0, #0x00
	strb r0, [r1]

	ldr r1, P2SEL1
	mov r0, #0x00
	strb r0, [r1]

	ldr r1, P2DS
	mov r0, #0xF0
	strb r0, [r1]

	ldr r1, P2DIR
	mov r0, #0xF0
	strb r0, [r1]

	ldr r1, P2OUT
	mov r0, #0x00
	strb r0, [r1]
	bx lr
;-----------------------PORT 3 Init-------------------------------------------------------------------------------------
Port3_Init:
	;For port 4
	ldr r1, P3SEL0
	mov r0, #0x00
	strb r0, [r1]

	ldr r1, P3SEL1
	mov r0, #0x00
	strb r0, [r1]

	ldr r1, P3DIR
	mov r0, #0xE0
	strb r0, [r1]

	ldr r1, P3OUT
	mov r0, #0x00
	strb r0, [r1]
	bx lr
	;-----------------------PORT 4 Init-------------------------------------------------------------------------------------
Port4_Init:
	;For port 4
	ldr r1, P4SEL0
	mov r0, #0x00
	strb r0, [r1]

	ldr r1, P4SEL1
	mov r0, #0x00
	strb r0, [r1]

	ldr r1, P4DIR
	mov r0, #0xF0
	strb r0, [r1]

	ldr r1, P4OUT
	mov r0, #0x00
	strb r0, [r1]
	bx lr
;-----------------------PORT 5 Init-------------------------------------------------------------------------------------
Port5_Init:
	;For input port 5
	ldr r1, P5SEL0
	mov r0, #0x00
	strb r0, [r1]
	ldr r1, P5SEL1
	mov r0, #0x00
	strb r0, [r1]
	;set the direction to output
	ldr r1, P5DIR
	mov r0, #0x00
	strb r0, [r1]
	;enable resistor
	ldr r1, P5REN
	mov r0, #0xC0
	strb r0, [r1]
	;pull up
	ldr r1, P5OUT
	mov r0, #0xC0
	strb r0, [r1]
	bx lr
;--------------------Check the Input from P5IN-------------------------------------------------------------------------
Port5_Input:
	ldr r1, P5IN
	ldrb r0, [r1]
	and r0, r0, #0xC0
	bx lr
	.end





