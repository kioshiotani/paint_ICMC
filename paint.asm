jmp main

pos : var #1
static pos, #0
color : var #1
static color, #0


main:
	call draw_cursor
	loadn r0, #39
	loadn r1, #'#'
	outchar r1, r0

	
	main_loop:
	call mv_cursor
	jmp main_loop	


;--------------------------------------------------
;switch_color_down
;--------------------------------------------------
switch_color_down:
	push FR
	push r0
	push r1 
	push r2

	load r0, color
	loadn r1, #0
	
	cmp r0, r1
	jeq reset_color_down
	
	loadn r2, #256
	sub r0, r0, r2
	store color, r0
	loadn r1, #39
	loadn r2, #'#'
	add r2, r2, r0
	outchar r2, r1

	end_color_down:
	pop r2
	pop r1
	pop r0
	pop FR
	rts

	reset_color_down:
	loadn r0, #3584
	store color, r0
	loadn r1, #39
	loadn r2, #'#'
	outchar r2, r1

	jmp end_color_down

;--------------------------------------------------
;END switch_color_down
;--------------------------------------------------

;--------------------------------------------------
;switch_color_up
;--------------------------------------------------
switch_color_up:
	push FR
	push r0
	push r1 
	push r2

	load r0, color
	loadn r1, #3584
	
	cmp r0, r1
	jeq reset_color_up
	
	loadn r2, #256
	add r0, r0, r2
	store color, r0
	loadn r1, #39
	loadn r2, #'#'
	add r2, r2, r0
	outchar r2, r1

	end_color_up:
	pop r2
	pop r1
	pop r0
	pop FR
	rts

	reset_color_up:
	loadn r0, #0
	store color, r0
	loadn r1, #39
	loadn r2, #'#'
	outchar r2, r1

	jmp end_color_up
	
;--------------------------------------------------
;END switch_color_up
;--------------------------------------------------

;--------------------------------------------------
;erase
;--------------------------------------------------
erase:
	push FR
	push r0
	push r1
	push r2

	load r0, pos
	loadn r1, #screen0
	loadn r2, #' '
	
	add r1, r1, r0
	storei r1, r2
	

	end_erase:
	pop r2
	pop r1
	pop r0
	pop FR
	rts
;--------------------------------------------------
;END erase
;--------------------------------------------------

;--------------------------------------------------
;paint
;--------------------------------------------------
paint:
	push FR
	push r0
	push r1
	push r2
	push r3

	load r0, pos
	loadn r1, #screen0
	loadn r2, #'#'	
	load r3, color
	add r2, r2, r3

	add r1, r1, r0
	storei r1, r2
	
	outchar r2, r0	

	pop r3
	pop r2
	pop r1 
	pop r0
	pop FR
	rts
;--------------------------------------------------
;END paint
;--------------------------------------------------

;--------------------------------------------------
;mv_cursor
;--------------------------------------------------
mv_cursor:
	push FR
	push r0
	push r1
	push r2	
	push r3
	push r4
	
	load r3, pos
	mov r4, r3
	loadn r2, #40

	inchar r0

	;mv_left	
	loadn r1, #'a'
	cmp r0, r1
	jne mv_right
	
	mod r0, r3, r2
	loadn r1, #0
	cmp r0, r1
	jeq end_mv_cursor

	dec r3
		
	jmp move

	mv_right:
	loadn r1, #'d'
	cmp r0, r1
	jne mv_down

	mod r0, r3, r2
	loadn r1, #39
	cmp r0, r1
	jeq end_mv_cursor

	inc r3

	cmp r3, r1
	jeq end_mv_cursor


	jmp move

	mv_down:
	loadn r1, #'s'
	cmp r0, r1
	jne mv_up

	loadn r0, #1160
	cmp r3, r0
	jeg end_mv_cursor

	add r3, r3, r2
	jmp move

	mv_up:
	loadn r1, #'w'
	cmp r0, r1
	jne paint_mv

	loadn r0, #39
	cmp r3, r0
	jel end_mv_cursor

	sub r3, r3, r2
	
	loadn r1, #39
	cmp r3, r1
	jeq end_mv_cursor

	jmp move

	paint_mv:
	loadn r1, #'p'
	cmp r0, r1
	jne erase_mv

	call paint
	jmp end_mv_cursor

	erase_mv:
	loadn r1, #'o'
	cmp r0, r1
	jne switch_color_u

	call erase
	jmp end_mv_cursor

	switch_color_u:
	loadn r1, #'i'
	cmp r0, r1
	jne switch_color_d

	call switch_color_up
	jmp end_mv_cursor

	switch_color_d:
	loadn r1, #'u'
	cmp r0, r1
	jne end_mv_cursor

	call switch_color_down
	jmp end_mv_cursor

	move:
	store pos, r4
	call erase_cursor	
	store pos, r3
	call draw_cursor

	end_mv_cursor:
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	pop FR
	rts

;--------------------------------------------------
;END mv_cursor
;--------------------------------------------------

;--------------------------------------------------
;draw_cursor
;--------------------------------------------------
draw_cursor:
	push FR
	push r0
	push r1

	load r0, pos
	loadn r1, #'&'	
	outchar r1, r0

	pop r1
	pop r0
	pop FR
	rts
;--------------------------------------------------
;END draw_cursor
;--------------------------------------------------

;--------------------------------------------------
;erase_cursor
;--------------------------------------------------
erase_cursor:
	push FR
	push r0
	push r1
	push r2

	load r0, pos
	loadn r2, #screen0
	add r2, r2, r0	
	loadi r1, r2
	outchar r1, r0

	pop r2
	pop r1 
	pop r0
	pop FR
	rts
;--------------------------------------------------
;END erase_cursor
;--------------------------------------------------


;--------------------------------------------------
;screen
;--------------------------------------------------
screen0  : string "                                       "
screen1  : string "                                       "
screen2  : string "                                       "
screen3  : string "                                       "
screen4  : string "                                       "
screen5  : string "                                       "
screen6  : string "                                       "
screen7  : string "                                       "
screen8  : string "                                       "
screen9  : string "                                       "
screen10 : string "                                       "
screen11 : string "                                       "
screen12 : string "                                       "
screen13 : string "                                       "
screen14 : string "                                       "
screen15 : string "                                       "
screen16 : string "                                       "
screen17 : string "                                       "
screen18 : string "                                       "
screen19 : string "                                       "
screen20 : string "                                       "
screen21 : string "                                       "
screen22 : string "                                       "
screen23 : string "                                       "
screen24 : string "                                       "
screen25 : string "                                       "
screen26 : string "                                       "
screen27 : string "                                       "
screen28 : string "                                       "
screen29 : string "                                       "
screen30 : string "                                       "
screen31 : string "                                       "
screen32 : string "                                       "
screen33 : string "                                       "
screen34 : string "                                       "
screen35 : string "                                       "
screen36 : string "                                       "
screen37 : string "                                       "
screen38 : string "                                       "
screen39 : string "                                       "





;--------------------------------------------------
;END screen
;--------------------------------------------------

; 0 branco							0000 0000
; 256 marrom						0001 0000
; 512 verde							0010 0000
; 768 oliva							0011 0000
; 1024 azul marinho					0100 0000
; 1280 roxo							0101 0000
; 1536 teal							0110 0000
; 1792 prata						0111 0000
; 2048 cinza						1000 0000
; 2304 vermelho						1001 0000
; 2560 lima							1010 0000
; 2816 amarelo						1011 0000
; 3072 azul							1100 0000
; 3328 rosa							1101 0000
; 3584 aqua							1110 0000












