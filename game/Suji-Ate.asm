;----------------------------------------
;数当てゲーム
;----------------------------------------
;[How to play]
;①実行すると短い音が鳴る
;②任意の数字キーを押すと長い音がでて2進LEDの3が光る
;  ここでA~Fまでの任意の数字をコンピューターが選ぶ
;③Playerは数字キーを押下しコンピューターが選んだ数字を当てる
;　・選んだ数字がCOMより小さい場合は6番のLEDが点灯
;　・選んだ数字がCOMより大きい場合は0番のLEDが点灯
;④3回目で失敗すると負けとなりエラー音がなる
;⑤1秒後に①に戻る
;
;[Description]
;0x00番地からメイン処理を実装
;0x80番地からサブルーチンを格納
;初期設定メモリ無し
;
;[Memory]
;50:Life
;51:Computerの選択値
;52:Playerの入力値
;----------------------------------------

	org	0x00
init:
	ldyi	0		;PlayerLife50番地に登録
	ldi	2
	st	
decideComNo:
	scall	9
	call	selectComNumber	;A～Fまでの乱数を51番地に格納
	ldyi	3
	scall	1
	scall	0xA
player:	
	ink	
	jmpf	player
	abyz	
inkey:
	ink	
	jmpf	leaveKey
	jmpf	inkey
leaveKey:
	scall	9
	outn	
	ldyi	1
	sub			;結果値＝COMの選択値―Player選択値
	jmpf	high		;結果値＝負数：Player値が大きい
	cpi	0
	jmpf	low		;結果値 !＝0：Player値が小さい
	call	ledOff		;結果値 ＝0：正解！
	ldyi	3
	scall	1
	scall	7
	jmpf	postProc	;後処理してゲーム繰り返し


	org	0x80
selectComNumber:		;乱数選択サブルーチン
	ldyi	0xf
addOne:
	addyi	1
	ink
	jmpf	addOne		;キーが押されるまでまで1を足す
	ay	
	ldyi	1		;押されたら入力値を51番地に格納
	st	
keyWait:
	ink			;キーが離されたかチェック
	jmpf	keyLeave
	jmpf	keyWait
keyLeave:
	ret	
ledOff:				;HighLow用のLED消灯サブルーチン
	ldyi	0
	scall	2
	ldyi	6
	scall	2
	ret	
high:				;High時用処理、残機チェックに続く
	call	ledOff
	ldyi	0
	scall	1
	jmpf	lifeCheck
low:				;Low時用処理、残機チェックに続く
	call	ledOff
	ldyi	6
	scall	1
	jmpf	lifeCheck
lifeCheck:			;残機チェック

	ldyi	0
	ldi	1
	sub			;50番地の残機数から1引く
	jmpf	gameOver	;結果＝負数の場合ゲームオーバー
	st			;残機がある場合、更新値をメモリに格納して次の入力に戻る
	jmpf	player
gameOver:		        ;ゲームオーバー処理
	ldyi	1
	ld	
	outn	
	scall	8
postProc:			;後処理

	ldi	9
	scall	0xC
	call	ledOff
	scall	0
	jmpf	init
