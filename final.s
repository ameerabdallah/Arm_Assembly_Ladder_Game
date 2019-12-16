// EQU DIRECTIVES FOR THE LEFT SIDE (PLAYER 1)
.EQU RL,	21
.EQU GL,	22
.EQU BL,	23
.EQU YL,	24
.EQU BUTTONL,	25

// EQU DIRECTIVES FOR THE RIGHT SIDE (PLAYER 2)
.EQU RR,	4
.EQU GR,	5
.EQU BR,	26
.EQU YR,	27
.EQU BUTTONR,	29

// OTHER DIRECTIVES
.EQU HIGH,	1
.EQU LOW,	0
.EQU IN,	0
.EQU OUT,	1

// LEFT AND WRITE DIRECTIVES
.EQU NONE,	0
.EQU LEFT,	1
.EQU RIGHT,	2

// LEVEL DIRECTIVES
.EQU LEV_ONE,	680
.EQU LEV_TWO,	500
.EQU LEV_THREE,	200
.EQU LEV_FOUR,	100

.global main

.section .rodata
test: .asciz "TEST\n"

.data
startOfLeftTimer: .word 0
startOfRightTimer: .word 0
winner: .word 0			// 0 means NONE 1 means LEFT 2 means RIGHT
buttonPressedL: .word 0
buttonPressedR: .word 0
leftWinsPrint: .asciz "The left player has won!\n"
rightWinsPrint: .asciz "The right player has won!\n"

.align 4
.text
main:	push {lr}

	// initialize wiringpi
	bl wiringPiSetup

	// set up pins with output pin mode
	mov r0, #RL	// RED left
	mov r1, #OUT
	bl pinMode
	mov r0, #RL
	mov r1, #LOW
	bl digitalWrite

	mov r0, #RR	// RED right
	mov r1, #OUT
	bl pinMode
	mov r0, #RR
	mov r1, #LOW
	bl digitalWrite

	mov r0, #GL	// GREEN left
	mov r1, #OUT
	bl pinMode
	mov r0, #GL
	mov r1, #LOW
	bl digitalWrite

	mov r0, #GR	// GREEN right
	mov r1, #OUT
	bl pinMode
	mov r0, #GR
	mov r1, #LOW
	bl digitalWrite

	mov r0, #BL	// BLUE left
	mov r1, #OUT
	bl pinMode
	mov r0, #BL
	mov r1, #LOW
	bl digitalWrite

	mov r0, #BR	// BLUE right
	mov r1, #OUT
	bl pinMode
	mov r0, #BR
	mov r1, #LOW
	bl digitalWrite

	mov r0, #YL	// YELLOW left
	mov r1, #OUT
	bl pinMode
	mov r0, #YL
	mov r1, #LOW
	bl digitalWrite

	mov r0, #YR	// YELLOW right
	mov r1, #OUT
	bl pinMode
	mov r0, #YR
	mov r1, #LOW
	bl digitalWrite


	// SET BUTTON PIN MODES
	mov r0, #BUTTONL
	mov r1, #IN
	bl pinMode

	mov r0, #BUTTONR
	mov r1, #IN
	bl pinMode

	bl startGame
	pop {pc}

startGame:
	push {lr}
	bl millis
	ldr r1, =startOfLeftTimer
	str r0, [r1]

	ldr r0, =gameLeft
	bl piThreadCreate

	bl millis
	ldr r1, =startOfRightTimer
	str r0, [r1]

	ldr r0, =gameRight
	bl piThreadCreate

whileGameRunning:
	ldr r4, =winner
	ldr r4, [r4]
	cmp r4, #NONE
	beq whileGameRunning

	cmp r4, #LEFT
	bleq leftWins

	cmp r4, #RIGHT
	bleq rightWins

	pop {lr}
	bx lr


// Left side of the game
checkButtonPressedL:
	ldr r0, =winner
	ldr r0, [r0]
	cmp r0, #0
	bne stopCheckButtonL

	mov r0, #BUTTONL
	bl digitalRead

	cmp r0, #HIGH		// if(being pressed)
	moveq r0, #1		// set buttonPressedL to true
	movne r0, #0		// set buttonPressedL to false

	ldr r1, =buttonPressedL
	str r0, [r1]

	b checkButtonPressedL

stopCheckButtonL:
	bx lr

gameLeft:
	push {lr}
	ldr r0, =checkButtonPressedL
	bl piThreadCreate

	bl levelOneLeft

	pop {pc}

levelOneLeft:

	mov r0, #1
	bl delay

	ldr r0, =buttonPressedL
	ldr r0, [r0]

	cmp r0, #1

	beq buttonPressed1L

	bl millis
	ldr r1, =startOfLeftTimer
	ldr r1, [r1]

	mov r4, #0
	sub r4, r0, r1

	cmp r4, #LEV_ONE

	mov r0, #YL
	blge togglePin
	blge millis
	ldrgt r1, =startOfLeftTimer
	strgt r0, [r1]

	ldr r0, =buttonPressedL
	ldr r0, [r0]

	cmp r0, #1

	beq buttonPressed1L
	bne buttonNotPressed1L



buttonPressed1L:
	mov r0, #LEV_ONE
	bl delay

	mov r0, #YL
	bl digitalRead
	cmp r0, #HIGH


	beq levelTwoLeft

	// if the light wasn't on while the button was pressed, run the code below
	mov r0, #RIGHT
	ldr r1, =winner
	str r0, [r1]
	bx lr

buttonNotPressed1L:

	b levelOneLeft

	bx lr



levelTwoLeft:

	mov r0, #1
	bl delay

	ldr r0, =buttonPressedL
	ldr r0, [r0]

	cmp r0, #1

	beq buttonPressed2L


	bl millis
	ldr r1, =startOfLeftTimer
	ldr r1, [r1]

	mov r4, #0
	sub r4, r0, r1

	cmp r4, #LEV_TWO

	mov r0, #BL
	blge togglePin
	blge millis
	ldrgt r1, =startOfLeftTimer
	strgt r0, [r1]

	ldr r0, =buttonPressedL
	ldr r0, [r0]

	cmp r0, #1

	beq buttonPressed2L
	bne buttonNotPressed2L



buttonPressed2L:
	mov r0, #LEV_TWO
	bl delay

	mov r0, #BL
	bl digitalRead
	cmp r0, #HIGH

	beq levelThreeLeft

	// if the light wasn't on while the button was pressed, run the code below
	mov r0, #RIGHT
	ldr r1, =winner
	str r0, [r1]
	bx lr

buttonNotPressed2L:

	b levelTwoLeft

	bx lr


levelThreeLeft:

	mov r0, #1
	bl delay

	ldr r0, =buttonPressedL
	ldr r0, [r0]

	cmp r0, #1

	beq buttonPressed3L

	bl millis
	ldr r1, =startOfLeftTimer
	ldr r1, [r1]

	mov r4, #0
	sub r4, r0, r1

	cmp r4, #LEV_THREE

	mov r0, #GL
	blge togglePin
	blge millis
	ldrgt r1, =startOfLeftTimer
	strgt r0, [r1]

	ldr r0, =buttonPressedL
	ldr r0, [r0]

	cmp r0, #1

	beq buttonPressed3L
	bne buttonNotPressed3L



buttonPressed3L:
	mov r0, #LEV_THREE
	bl delay

	mov r0, #GL
	bl digitalRead
	cmp r0, #HIGH

	beq levelFourLeft

	// if the light wasn't on while the button was pressed, run the code below
	mov r0, #RIGHT
	ldr r1, =winner
	str r0, [r1]
	bx lr

buttonNotPressed3L:

	b levelThreeLeft
	bx lr

levelFourLeft:

	mov r0, #1
	bl delay

	ldr r0, =buttonPressedL
	ldr r0, [r0]

	cmp r0, #1

	beq buttonPressed4L

	bl millis
	ldr r1, =startOfLeftTimer
	ldr r1, [r1]

	mov r4, #0
	sub r4, r0, r1

	cmp r4, #LEV_FOUR

	mov r0, #RL
	blge togglePin
	blge millis
	ldrgt r1, =startOfLeftTimer
	strgt r0, [r1]

	ldr r0, =buttonPressedL
	ldr r0, [r0]

	cmp r0, #1

	beq buttonPressed4L
	bne buttonNotPressed4L


buttonPressed4L:
	mov r0, #LEV_FOUR
	bl delay

	mov r0, #RL
	bl digitalRead
	cmp r0, #HIGH

	moveq r0, #LEFT

	// if the light wasn't on while the button was pressed, run the code below
	movne r0, #RIGHT
	ldr r1, =winner
	str r0, [r1]
	bx lr

buttonNotPressed4L:

	b levelFourLeft
	bx lr


// End of left side of game


// Right side of the game

checkButtonPressedR:
	ldr r0, =winner
	ldr r0, [r0]
	cmp r0, #0
	bne stopCheckButtonR

	mov r0, #BUTTONR
	bl digitalRead

	cmp r0, #HIGH		// if(being pressed)
	moveq r0, #1		// set buttonPressedR to true
	movne r0, #0		// set buttonPressedR to false

	ldr r1, =buttonPressedR
	str r0, [r1]

	b checkButtonPressedR

stopCheckButtonR:
	bx lr

gameRight:
	push {lr}
	ldr r0, =checkButtonPressedR
	bl piThreadCreate

	bl levelOneRight

	pop {pc}

levelOneRight:

	mov r0, #1
	bl delay

	ldr r0, =buttonPressedR
	ldr r0, [r0]

	cmp r0, #1

	beq buttonPressed1R


	bl millis
	ldr r1, =startOfRightTimer
	ldr r1, [r1]

	mov r4, #0
	sub r4, r0, r1

	cmp r4, #LEV_ONE

	mov r0, #YR
	blge togglePin
	blge millis
	ldrgt r1, =startOfRightTimer
	strgt r0, [r1]

	ldr r0, =buttonPressedR
	ldr r0, [r0]

	cmp r0, #1

	beq buttonPressed1R
	bne buttonNotPressed1R



buttonPressed1R:
	mov r0, #LEV_ONE
	bl delay

	mov r0, #YR
	bl digitalRead
	cmp r0, #HIGH


	beq levelTwoRight

	// if the light wasn't on while the button was pressed, run the code below
	mov r0, #LEFT
	ldr r1, =winner
	str r0, [r1]
	bx lr

buttonNotPressed1R:

	b levelOneRight
	bx lr


levelTwoRight:

	mov r0, #1
	bl delay


	ldr r0, =buttonPressedR
	ldr r0, [r0]

	cmp r0, #1

	beq buttonPressed2R

	bl millis
	ldr r1, =startOfRightTimer
	ldr r1, [r1]

	mov r4, #0
	sub r4, r0, r1

	cmp r4, #LEV_TWO

	mov r0, #BR
	blge togglePin
	blge millis
	ldrgt r1, =startOfRightTimer
	strgt r0, [r1]

	ldr r0, =buttonPressedR
	ldr r0, [r0]

	cmp r0, #1

	beq buttonPressed2R
	bne buttonNotPressed2R



buttonPressed2R:
	mov r0, #LEV_TWO
	bl delay

	mov r0, #BR
	bl digitalRead
	cmp r0, #HIGH

	beq levelThreeRight

	// if the light wasn't on while the button was pressed, run the code below
	mov r0, #LEFT
	ldr r1, =winner
	str r0, [r1]
	bx lr

buttonNotPressed2R:

	b levelTwoRight
	bx lr


levelThreeRight:
	mov r0, #1
	bl delay

	ldr r0, =buttonPressedR
	ldr r0, [r0]

	cmp r0, #1

	beq buttonPressed3R

	bl millis
	ldr r1, =startOfRightTimer
	ldr r1, [r1]

	mov r4, #0
	sub r4, r0, r1

	cmp r4, #LEV_THREE

	mov r0, #GR
	blge togglePin
	blge millis
	ldrgt r1, =startOfRightTimer
	strgt r0, [r1]

	ldr r0, =buttonPressedR
	ldr r0, [r0]

	cmp r0, #1

	beq buttonPressed3R
	bne buttonNotPressed3R



buttonPressed3R:
	mov r0, #LEV_THREE
	bl delay

	mov r0, #GR
	bl digitalRead
	cmp r0, #HIGH

	beq levelFourRight

	// if the light wasn't on while the button was pressed, run the code below
	mov r0, #LEFT
	ldr r1, =winner
	str r0, [r1]
	bx lr

buttonNotPressed3R:

	b levelThreeRight
	bx lr

levelFourRight:

	mov r0, #1
	bl delay

	ldr r0, =buttonPressedR
	ldr r0, [r0]

	cmp r0, #1

	beq buttonPressed4R

	bl millis
	ldr r1, =startOfRightTimer
	ldr r1, [r1]

	mov r4, #0
	sub r4, r0, r1

	cmp r4, #LEV_FOUR

	mov r0, #RR
	blge togglePin
	blge millis
	ldrgt r1, =startOfRightTimer
	strgt r0, [r1]

	ldr r0, =buttonPressedR
	ldr r0, [r0]

	cmp r0, #1

	beq buttonPressed4R
	bne buttonNotPressed4R


buttonPressed4R:
	mov r0, #LEV_FOUR
	bl delay

	mov r0, #RR
	bl digitalRead
	cmp r0, #HIGH

	moveq r0, #RIGHT

	// if the light wasn't on while the button was pressed, run the code below
	movne r0, #LEFT
	ldr r1, =winner
	str r0, [r1]
	bx lr

buttonNotPressed4R:

	b levelFourRight
	bx lr



// End of right side of game

leftWins:
	push {lr}
	ldr r0, =leftWinsPrint
	bl printf

	mov r0, #YL
	mov r1, #HIGH
	bl digitalWrite
	mov r0, #GL
	mov r1, #HIGH
	bl digitalWrite
	mov r0, #BL
	mov r1, #HIGH
	bl digitalWrite
	mov r0, #RL
	mov r1, #HIGH
	bl digitalWrite

	mov r0, #YR
	mov r1, #LOW
	bl digitalWrite
	mov r0, #GR
	mov r1, #LOW
	bl digitalWrite
	mov r0, #BR
	mov r1, #LOW
	bl digitalWrite
	mov r0, #RR
	mov r1, #LOW
	bl digitalWrite

	mov r0, #100
	bl delay

	mov r0, #YL
	mov r1, #LOW
	bl digitalWrite
	mov r0, #GL
	mov r1, #LOW
	bl digitalWrite
	mov r0, #BL
	mov r1, #LOW
	bl digitalWrite
	mov r0, #RL
	mov r1, #LOW
	bl digitalWrite

	mov r0, #100
	bl delay

	mov r0, #YL
	mov r1, #HIGH
	bl digitalWrite
	mov r0, #GL
	mov r1, #HIGH
	bl digitalWrite
	mov r0, #BL
	mov r1, #HIGH
	bl digitalWrite
	mov r0, #RL
	mov r1, #HIGH
	bl digitalWrite

	mov r0, #100
	bl delay

	mov r0, #YL
	mov r1, #LOW
	bl digitalWrite
	mov r0, #GL
	mov r1, #LOW
	bl digitalWrite
	mov r0, #BL
	mov r1, #LOW
	bl digitalWrite
	mov r0, #RL
	mov r1, #LOW
	bl digitalWrite

	mov r0, #600
	bl delay

	mov r0, #YL
	mov r1, #HIGH
	bl digitalWrite
	mov r0, #GL
	mov r1, #HIGH
	bl digitalWrite
	mov r0, #BL
	mov r1, #HIGH
	bl digitalWrite
	mov r0, #RL
	mov r1, #HIGH
	bl digitalWrite


	pop {lr}
	bx lr

rightWins:
	push {lr}
	ldr r0, =rightWinsPrint
	bl printf

	mov r0, #YL
	mov r1, #LOW
	bl digitalWrite
	mov r0, #GL
	mov r1, #LOW
	bl digitalWrite
	mov r0, #BL
	mov r1, #LOW
	bl digitalWrite
	mov r0, #RL
	mov r1, #LOW
	bl digitalWrite

	mov r0, #YR
	mov r1, #HIGH
	bl digitalWrite
	mov r0, #GR
	mov r1, #HIGH
	bl digitalWrite
	mov r0, #BR
	mov r1, #HIGH
	bl digitalWrite
	mov r0, #RR
	mov r1, #HIGH
	bl digitalWrite

	mov r0, #100
	bl delay

	mov r0, #YR
	mov r1, #LOW
	bl digitalWrite
	mov r0, #GR
	mov r1, #LOW
	bl digitalWrite
	mov r0, #BR
	mov r1, #LOW
	bl digitalWrite
	mov r0, #RR
	mov r1, #LOW
	bl digitalWrite

	mov r0, #100
	bl delay

	mov r0, #YR
	mov r1, #HIGH
	bl digitalWrite
	mov r0, #GR
	mov r1, #HIGH
	bl digitalWrite
	mov r0, #BR
	mov r1, #HIGH
	bl digitalWrite
	mov r0, #RR
	mov r1, #HIGH
	bl digitalWrite

	mov r0, #100
	bl delay

	mov r0, #YR
	mov r1, #LOW
	bl digitalWrite
	mov r0, #GR
	mov r1, #LOW
	bl digitalWrite
	mov r0, #BR
	mov r1, #LOW
	bl digitalWrite
	mov r0, #RR
	mov r1, #LOW
	bl digitalWrite

	mov r0, #600
	bl delay

	mov r0, #YR
	mov r1, #HIGH
	bl digitalWrite
	mov r0, #GR
	mov r1, #HIGH
	bl digitalWrite
	mov r0, #BR
	mov r1, #HIGH
	bl digitalWrite
	mov r0, #RR
	mov r1, #HIGH
	bl digitalWrite


	pop {lr}
	bx lr


togglePin:
	push {r0, lr}

	bl digitalRead
	cmp r0, #HIGH
	moveq r1, #LOW
	movne r1, #HIGH
	pop {r0}
	bl digitalWrite	// If led is not on, turn it on, if it is on, turn it off

	pop {lr}
	bx lr
