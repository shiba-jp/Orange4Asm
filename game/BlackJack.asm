;----------------------------------------
;BlackJack
;----------------------------------------
;[How to play]
;
;[Description]
;
;[Memory]
;
;[Machine Code]
;E00:80A04AF4EAF6080A05E90F14C0F22E7F1FEAF6080F14
;E80:AfB10F823AE4EDA06FA814CFF9EF1D0FA5F9EF611A7E1E8F1F
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
	scall	9
confirm	ink	
	jmpf	confirm
	cpi	0
	jmpf	add
blackjack	scall	7
end	jmpf	end
add	scall	A
	call	random
	jmpf	confirm


	org	0x80
random	ldyi	f
addNo	addyi	1
	ink	
	jmpf	addNo
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
