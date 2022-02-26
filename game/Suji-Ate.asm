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
;⑥3ゲーム終了後に長い音がなり、正解数が数字LEDにされる。
;⑦終了
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
;53:ゲームカウント
;54:正解数
;
;[Machine Code]
;E00:A3804A44A082481A364E9F6080A3E1EA0F2020F2CF25E91A17FA1C0FADF6096A48164A3E1E7FCB
;E80:AfB10F823A140F93F8CF61A0E2A6E2F61F6096A0E1FB9F6096A6E1FB9A0817FC54F20A151E889ECF6096E0A35C3F08FE1A451EAFE7
;----------------------------------------

	org	0x00
init:
	ldyi	3		;ゲームカウント:0を53番地に格納
	ldi	0
	st	
	ldyi	4		;正解数:0を54番地に格納
	st	
start:
	ldyi	0		;PlayerLife50番地に格納
	ldi	2
	st	
	ldi	1		;ゲームカウントをインクリメント
	ldyi	3
	add	
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
	ldyi	4
	ldi	1	
	add			;正解カウントをインクリメント
	st	
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
	ldyi	3
	ld	
	cpi	3		;ゲームカウント:3なら終了
	jmpf	start
	jmpf	finish
finish:
	ldyi	4
	ld	
	outn			;正解数を数字LEDに表示
	scall	0xA
end:
	jmpf	end
