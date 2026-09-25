; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ; Îáó÷àëêà ïî ìèêðîêîíòðîëëåðàì AVR è èõ ïðîãðàììèðîâàíèå  ;
; ; íà ÿçûêå Assembler îò Ðîìàíà Çâåçäîïàäîâà                ;
; ; Àâòîð âê: https:;vk.com/zvezdopezdov                    ;
; ; Ãðóïïà âê: https:;vk.com/sitrixcorp                     ;
; ; Êàíàë YouTube:                                           ;
; ; https:;www.youtube.com/channel/UCHyuvaL_iMYifT3ziWEuogg ;
; ; Åñëè âàì ïîìîãëè âèäåî ìîæåòå ïîæåðòâîâàòü ïàðó äîëëàðîâ ;
; ; íà ðàçâèòèå ïðîåêòà íà êîøåëåê Payeer: P27929796  =)     ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.include "m16def.inc" ; Ïîäêëþ÷àåì çàãîëîâî÷íûé ôàéë
.def temp=r16 ; Ïðèñâàèâàåì ñèìâîëè÷åñêèå èìåíà ðåãèñòðàì
.def razr1=r17
.def razr2=r18
.def razr3=r19
.def sys=r20

;;;;;;;;;;;;;;;;/ Óñòàâêè LCD
.equ FREQ = 8000000 ; Çäåñü ãîâîðèì î ÷àñòîòå, íà êîòîðîé ðàáîòàåò ÷èï
.equ HD44780_CLEAR		=0x01 ; Îñòàëüíûå íàñòðîéêè ñ òåõ.äîêîì. è ñëîâàðåì àíãëèöêîãî
.equ HD44780_HOME		=0x02
.equ HD44780_ENTRY_MODE		=0x04
.equ HD44780_EM_SHIFT_CURSOR	=0
.equ HD44780_EM_SHIFT_DISPLAY	=1
.equ HD44780_EM_DECREMENT	=0
.equ HD44780_EM_INCREMENT	=2
.equ HD44780_DISPLAY_ONOFF	=0x08
.equ HD44780_DISPLAY_OFF	=0
.equ HD44780_DISPLAY_ON		=4
.equ HD44780_CURSOR_OFF		=0
.equ HD44780_CURSOR_ON		=2
.equ HD44780_CURSOR_NOBLINK	=0
.equ HD44780_CURSOR_BLINK	=1
.equ HD44780_FUNCTION_SET	=0x20
.equ HD44780_FONT5x7		=0
.equ HD44780_FONT5x10		=4
.equ HD44780_ONE_LINE		=0
.equ HD44780_TWO_LINE		=8
.equ HD44780_4_BIT		=0
.equ HD44780_8_BIT		=16
.equ	LCD_PORT 	= PORTB ; ïîðò, íà êîòîðîì LCD
.equ	LCD_DDR		= DDRB  ; ïîðò, íà êîòîðîì LCD
.equ    LCD_PIN		= PINB ; ïîðò, íà êîòîðîì LCD
.equ	LCD_D4 		= 4 ; Íîãè, íà êàêèõ ÷åãî âèñèò
.equ	LCD_D5 		= 5
.equ 	LCD_D6 		= 6
.equ	LCD_D7 		= 7
.equ	LCD_RS		= 0
.equ	LCD_EN		= 2
;;;;;;;;;;;;;;;/ Êîíåö óñòàâîê LCD

.cseg ; Ïðîãðàììíûé ñåãìåíò
.org 0 ; Íà÷àëî ïðîãðàììíîãî ñåãìåíòà
rjmp Reset ; Ïåðåñêàêèâàåì íà Reset

Reset:
ldi temp, high(ramend) ; 4 ñòðîêè èíèöèàëèçàöèè ñòåêà
out sph, temp
ldi temp, low(ramend) 
out spl, temp
ldi temp, 0xff ; Ïîðò B íà âûõîä íà âñÿêèé ñëó÷àé
out DDRB, temp 
rcall LCD_init ; Âûçûâàåì Èíèöèàëèçàöèþ äèñïëåÿ
ldi sys, 0x30 ; Çàïèñûâàåì öèôðó 0 â ASCII

Proga:
ldi r16, (128+0x00) ; Äàåì êîìàíäó óñòàíîâêè êóðñîðà 1 ñòðîêà, 1 ñèìâîë
; Àäðåñà êàæäîãî çíàêîìåñòà è ñòðîêè â òåõ.äîêå èëè ó ìåíÿ â êîäå ìåòîäîì áóáíà =D
rcall LCD_Com ; Ïîñûëêà êîìàíäû
ldi r16, 'N'
rcall LCD_Dan ; Ïîñûëêà äàííûõ(ñèìâîëîâ), äàëåå àíàëîãè÷íî
ldi r16, 'a'
rcall LCD_Dan
ldi r16, 'z'
rcall LCD_Dan
ldi r16, 'a'
rcall LCD_Dan
ldi r16, 'r'
rcall LCD_Dan
ldi r16, 'e'
rcall LCD_Dan
ldi r16, 'n'
rcall LCD_Dan
ldi r16, 'k'
rcall LCD_Dan
ldi r16, 'o'
rcall LCD_Dan
; ldi r16, 'o'
; rcall LCD_Dan
; ldi r16, 'v'
; rcall LCD_Dan

ldi r16, (128+0x40) ; Òèêàåì öèôåðêîé íà 2 ñòðîêå äèñïëåÿ, 1 ñèìâîë
rcall LCD_Com ; Ïîñûëàåì êîìàíäó(ê 128 ïðèáàâëÿåòñÿ çíàêîìåñòî ïî äàòàøèòó)
mov r16, sys ; Êîïèðóåì ðåãèñòð sys, ò.ê. òàì íàøè öèôðû õðàíÿòñÿ
rcall LCD_Dan ; Ïîñûëàåì äàííûå
rcall Smena_Cifri ; Óâåëè÷èâàåì öèôðó íà 1 (Äëÿ íàãëÿäíîñòè), íèæå àíàëîãè÷íî

ldi r16, (128+0x15) ; Òèêàåì öèôåðêîé íà 3 ñòðîêå äèñïëåÿ, 2 ñèìâîë
rcall LCD_Com
mov r16, sys
rcall LCD_Dan
rcall Smena_Cifri

ldi r16, (128+0x56) ; Òèêàåì öèôåðêîé íà 4 ñòðîêå äèñïëåÿ, 3 ñèìâîë
rcall LCD_Com
mov r16, sys
rcall LCD_Dan
rcall Smena_Cifri

rcall Delay ; Äåðãàåì çàäåðæêó(÷òîáû íå íàäîåäàòü äèñïëåþ)
rjmp Proga ; Âîçâðàùàåìñÿ ê íà÷àëó îñíîâíîé ïðîãðàììû

Smena_Cifri: ; Ïîäïðîãðàììà èçìåíåíèÿ öèôðû
inc sys ; Óâåëè÷èâàåì öèôðó íà 1
cpi sys, 0x3A ; Ïðîâåðÿåì, íå âûøëà ëè çà ïðåäåëû
breq Smena_Cifri0
ret
Smena_Cifri0: ; Åñëè âûøëà çà ïðåäåëû ñíîâà óñòàíàâëèâàåì 0
ldi sys, 0x30 ; 0x30 Ñîîòâåòñòâóåò öèôðå 0 â ASCII(Èëè äàòàøèòó LCD)
ret

Delay: ; Çàäåðæêà(ñòàíäàðòíàÿ)
ldi razr1, 255
ldi razr2, 255
ldi razr3, 10
PDelay:
dec razr1
brne PDelay
dec razr2
brne PDelay
dec razr3
brne PDelay
ret

;;;;;;;;;;;;;;;/ Ïîäïðîãðàììû LCD
LCD_Init: ; Ïîäïðîãðàììà èíèöèàëèçàöèè äèñïëåÿ
	sbi		LCD_DDR, LCD_D4 ; Ãîâîðèì âñåì íîãàì ïîðòà, ÷òî îíè íà âûõîä
	sbi		LCD_DDR, LCD_D5
	sbi		LCD_DDR, LCD_D6
	sbi		LCD_DDR, LCD_D7	
	sbi		LCD_DDR, LCD_RS
	sbi		LCD_DDR, LCD_EN
	cbi		LCD_PORT, LCD_RS ; Îïðîêèäûâàåì RS è EN íà çåìëþ
	cbi		LCD_PORT, LCD_EN
	ldi		r16, 100
	rcall	WaitMiliseconds ; Æäåì 15-40 ìñ, ÷òîáû äèñïëåé óñïåë âêëþ÷èòñÿ îò ïèòàíèÿ
	ldi		r17, 3
InitLoop:
	ldi		r16, 0x03 ; D4 è D5 ïîäíèìàåì íà +5, îñòàëüíûå 0
	rcall	LCD_WriteNibble ; Îòïðàâëÿåì â ïîðò
	ldi		r16, 5
	rcall	WaitMiliseconds
	dec		r17
	brne	InitLoop ; Ïåðåõîäèì åñëè íå ðàâíî 0 (Ýòîò êóñîê íàäî ïðîäåëàòü 3 ðàçà)
	ldi		r16, 0x02 ; D5 íà +5, îñòàëüíûå 0
	rcall	LCD_WriteNibble ; Îòïðàâëÿåì â ïîðò
	ldi		r16, 1
	rcall	WaitMiliseconds ; Íåìíîãî ïîäîæäåì
	ldi		r16, HD44780_FUNCTION_SET | HD44780_FONT5x7 | HD44780_TWO_LINE | HD44780_4_BIT
	rcall	LCD_Com
	ldi		r16, HD44780_DISPLAY_ONOFF | HD44780_DISPLAY_OFF
	rcall	LCD_Com
	ldi		r16, HD44780_CLEAR
	rcall	LCD_Com
	ldi		r16, HD44780_ENTRY_MODE |HD44780_EM_SHIFT_CURSOR | HD44780_EM_INCREMENT
	rcall	LCD_Com
	ldi		r16, HD44780_DISPLAY_ONOFF | HD44780_DISPLAY_ON | HD44780_CURSOR_OFF | HD44780_CURSOR_NOBLINK
	rcall	LCD_Com ; Ñ äàííûìè íàñòðîéêàìè ðàçáèðàòüñÿ ïî äàòàøèòó, èáî ïèñàíèíû ïî íèì ìíîãî
	; ïðè÷åì â ðàçíûõ êîíôèãóðàöèÿõ...
	ret ; Âûõîä èç ïîäïðîãðàììû
;------------------------------------------------------------------------------
LCD_Dan: ; Ïîäïðîãðàììà îòïðàâêè äàííûõ(ñèìâîëîâ)
	sbi		LCD_PORT, LCD_RS ; Ïîäíèìàåì RS íà +5
	push	r16 ; Çàïèõèâàåì r16 â ñòåê
	swap	r16 ; Ìåíÿåì òåòðàäû r16
	rcall	LCD_WriteNibble ; Âûçûâàåì çàïèñü
	pop		r16 ; Âûäåðãèâàåì r16 èç ñòåêà
	rcall	LCD_WriteNibble ; Âûçûâàåì çàïèñü
	clr		XH ; ×èñòèì XH
	ldi		XL, LOW(FREQ/80000) ; À ñþäà ðàñ÷èòàííîå ÷èñëî
	rcall	Wait4xCycles ; Âûçûâàåì çàäåðæêó
	ret
;------------------------------------------------------------------------------
LCD_Com: ; Ïîäïðîãðàììà ïîñûëîê êîìàíäû, òèïà î÷èñòèòü äèñïëåé, óñòàíîâèòü ïîçèöèþ è ò.ä.
	cbi		LCD_PORT, LCD_RS ; Îïðîêèäûâàåì RS íà çåìëþ
	push	r16 ; Çàïèõèâàåì r16 â ñòåê
	swap	r16 ; Ìåíÿåì òåòðàäû r16
	rcall	LCD_WriteNibble ; Âûçûâàåì çàïèñü
	pop		r16 ; Âûäåðãèâàåì r16 èç ñòåêà
	rcall	LCD_WriteNibble ; Âûçûâàåì çàïèñü
	ldi		r16,2 
	rcall	WaitMiliseconds ; Âûçûâàåì çàäåðæêó
	ret
;------------------------------------------------------------------------------
LCD_WriteNibble: ; Çäåñü ìû äåðãàåì íîãè ïîðòà, òî åñòü ïðîèçâîäèì çàïèñü
	sbi		LCD_PORT, LCD_EN ; Ïîäíÿëè EN íà +5
	sbrs	r16, 0
	cbi		LCD_PORT, LCD_D4
	sbrc	r16, 0
	sbi		LCD_PORT, LCD_D4	
	sbrs	r16, 1
	cbi		LCD_PORT, LCD_D5
	sbrc	r16, 1
	sbi		LCD_PORT, LCD_D5	
	sbrs	r16, 2
	cbi		LCD_PORT, LCD_D6
	sbrc	r16, 2
	sbi		LCD_PORT, LCD_D6	
	sbrs	r16, 3
	cbi		LCD_PORT, LCD_D7
	sbrc	r16, 3
	sbi		LCD_PORT, LCD_D7
	cbi		LCD_PORT, LCD_EN ; Îïðîêèíóëè EN íà çåìëþ
	ret
;------------------------------------------------------------------------------
 WaitMiliseconds: ; Çàäåðæêè
   push r16 ; Çàñîâûâàåì ðåãèñòð r16 â ñòåê
 WaitMsLoop: 
   ldi    XH,HIGH(FREQ/17777) ; Çàñîâûâàåì ÷èñëî â ñòàðøèé ðåãèñòð
   ldi    XL,LOW(FREQ/17777) ; Çàñîâûâàåì ÷èñëî â ìëàäøèé ðåãèñòð
   rcall  Wait4xCycles ; Âûçûâàåì çàäåðæêó
   ldi    XH,HIGH(FREQ/17777) ; Çàñîâûâàåì ÷èñëî â ñòàðøèé ðåãèñòð
   ldi    XL,LOW(FREQ/17777) ; Çàñîâûâàåì ÷èñëî â ìëàäøèé ðåãèñòð
   rcall  Wait4xCycles ; Âûçûâàåì çàäåðæêó
   dec    r16 ; Ïîíèæàåì r16 íà 1
   brne   WaitMsLoop ; Ïåðåéòè íà ìåòêó, åñëè íå ðàâíî 0
   pop    r16 ; Âûòàñêèâàåì ðåãèñòð r16 èç ñòåêà
   ret
 ;------------------------------------------------------------------------------
 Wait4xCycles: ; Çàäåðæêà â 4 öèêëà
   sbiw   XH:XL, 1 ; Ïîíèæàåì ðåãèñòðîâóþ ïàðó íà 1
   brne   Wait4xCycles ; Ïåðåõîäèì åñëè íå ðàâíî 0
   ret ; Âûõîä èç ïîäïðîãðàììû 
;;;;;;;;;;;;;;;/ Êîíåö ïîäïðîãðàìì LCD