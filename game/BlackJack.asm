;----------------------------------------
;BlackJack
;----------------------------------------
;[How to play]
;・長い音の後、0以外のボタンでカード引く
;・1回目のカードを引いた後、0を押すと確定、0以外で次のカードルーレットが回るので任意のボタンで引く
;・数字LEDには初回の値と、2回目以降の足された値を表示
;・通常LEDには、2回目以降に引いた値を2進数で表示（点灯）
;・引いた値がFになった場合はその場でBlackJack
;・引いた値がFを超えた場合はブレイク（数字LEDに桁上がりの点が点灯する）
;
;[Description]
;
;[Memory]
;50:引いたカードの値
;5E:2進数LEDの表示用
;
;[Machine Code]
;E00:80A04AF4EAF6080A050F12C0F20E7F1DEAF6080F12
;E80:AFB10F82E93AE4EDA06FAA14CFFA0F1B0FA7FA0F611A7E1E8F1D
;----------------------------------------
	org	0x00
init	ldi	0
	ldyi	0
	st	
	ldyi	F
	st	
first	scall	A
	call	random
	ldyi	0
	ld	
confirm	ink	
	jmpf	confirm
	cpi	0
	jmpf	addVal
blackjack	scall	7
end	jmpf	end
addVal	scall	A
	call	random
	jmpf	confirm


	org	0x80
random	ldyi	F
addNo	addyi	1
	ink	
	jmpf	addNo
	scall	9
	ay	
	ldyi	E
	st	
	scall	D
	ldyi	0
	add	
	jmpf	error
	outn	
	st	
	cpi	F
	jmpf	keyWaiting
	jmpf	blackjack
keyWaiting	ink	
	jmpf	keyLeave
	jmpf	keyWaiting
keyLeave	ret	
error	outn	
	ldyi	7
	scall	1
	scall	8
	jmpf	end
