@
@ GPIO pin toggle and delay
@ By Ulrik Hørlyk Hjort
@
@ Toggle led on gpio pin5 on nucleo-F411RE board
@
.syntax unified
.cpu cortex-m4
.thumb

.data
tick: .long 0x00

.text

.global toggle_pinASM
.global get_tickASM
.global inc_tickASM
.global delayASM


.equ GPIOA_BASE , 0x40020000
.equ ODR_OFFSET, 20
.equ BSSR_OFFSET, 24
.equ GPIO_PIN_5, 0x0020
.equ TICK_FREQ, 1
.equ MAX_DELAY, 0xFFFFFFFFU

@ toggle_pinASM()
toggle_pinASM:
	ldr r1, =(GPIOA_BASE + ODR_OFFSET) @ odr addr
	ldr r0, [r1] @ Load odr
	mvn r0, r0 @ ~odr
	and r1, r0, GPIO_PIN_5
	mvn r0, r0 @ ~odr
	and r2, r0, GPIO_PIN_5
	mov r2, r2, lsl 16
	orr r0, r1, r2
	ldr r1, =(GPIOA_BASE + BSSR_OFFSET) @ bssr addr
	str r0,[r1]
	bx lr

@ inc_tickASM()
inc_tickASM:
	ldr r1,=tick
	ldr r2, [r1]
	add r2,r2, TICK_FREQ
	str r2, [r1]
	ldr r0, [r1]
	bx lr


get_tickASM:
	ldr r1,=tick
	ldr r0, [r1]
	bx lr


@ Add -Wa,-mimplicit-it=thumb
@ delayASM(delayMs)
delayASM:
	push {r4-r5, lr}
	ldr r1,=tick @ Get initial tick
	ldr r2, [r1]
    	add r3,r0, TICK_FREQ
wait:	ldr r4, [r1] @ Get current tick
   	sub r5, r4, r2
	cmp r5, r3
	blt wait @ if delay > (current_tick - initial_tick stay in loop
	pop {r4-r5, pc}
	bx lr
