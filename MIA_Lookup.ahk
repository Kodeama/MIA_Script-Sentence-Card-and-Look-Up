;Script made by Kodama MIA
;Youtube: https://www.youtube.com/channel/UCSyzfgzF9AVyfU6GBiVY8wg

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;----------OVERVIEW OF THIS SCRIPT----------
;The set values are values that works well for me, it will most likely be different for you,
;therefor I recommend you to watch my video explaining the script to easily change it for your own liking.
;
;This file consists of three scripts:
;Default trigger: Numpad9
;*Script for making sentence cards

;Default trigger: Numpad8
;*Script for disassemling sentences and/or looking up pitchaccent of one word

;Default trigger: Numpad7
;*Script for looking up pitch accent for an individual word
;--------------------------------------------

;CHANGE THESE VALUES FOR YOUR OWN LIKING
jishoEnabled = true ;Should jisho be enabled? aka bilingual or monolingual search
qolibriCharacterLimit = 0 ; if what the selected word(s) are over this number, skip qolibri and only search in jisho




;Global variables
sleepDuration := 25
isSetup := false
positionsSet := 0
jishoWindow :=

selectedWord :=
originalSelection :=

qolibriX :=
qolibriY :=
jishoX :=
jishoY :=
mouseTempX :=
mouseTempY :=







;For making sentence cards. Select the i+1 word in your sentence,
;The script will then search for it in qolibir and jisho (if jisho isnt disabled)
;Then when it has searched, you will select a definition, either in english from jisho, or from qolibri.
;When you press the left mouse button button, and then release the button, this script will copy that selection and put it in to anki.
;Right now the format of the cards is: i+1 word - definition
;Here is an example for 世界
;世界[せかい]-world​
;
;IF YOU WANT TO CHANGE SOMETTHING:
;Change the position to post the definition: (LINE ???)
;Change the way the definition is written: (LINE ???)

Numpad9::
{
	MouseGetPos, mouseTempX, mouseTempY
	
	if(!isSetup){
		positionsSet++
		if(positionsSet == 1){ ;Qolbri
			MouseGetPos, qolibriX, qolibriY
			if(!jishoEnabled)
				isSetup = true
			return
		}
		if(positionsSet >= 2){ ;Jisho
			isSetup = true
			jishoWindow := WinExist("A")
			MouseGetPos, jishoX, jishoY
			return
		}
	}
	
	;-----Copy Selected-----
	Send, ^c
	callWindow := WinExist("A")
	Sleep sleepDuration
	Send, ^c
	Sleep sleepDuration
	clipboardLen := StrLen(Clipboard)
	originalSelection := Clipboard
	
	;-----Parse Input-----
	clip := Clipboard
	char := SubStr(clip, 1, 1)
	newStr := ""

	counter := 0
	saveChar := 1
	Loop, %clipboardLen%
	{		
		counter++
		char := SubStr(clip, counter, 1)
		if(char == "[")
			saveChar = 0
		
		if(saveChar == 1)
			newStr = %newStr%%char% 
		
		if(char == "]")
			saveChar = 1
	}
	
	;-----Qolbri-----
	Winactivate, ahk_exe qolibri.exe 
	Sleep sleepDuration
	MouseClick, left, %qolibriX%, %qolibriY%
	Sleep sleepDuration
	Send, {BackSpace 20}{Right 20}{BackSpace 20}
	Sleep sleepDuration*2
	Send, %newStr%
	Sleep sleepDuration*2
	Send, {Enter}
	Sleep sleepDuration
	
	
	;-----Jisho-----
	Winactivate, ahk_id %jishoWindow%
	Sleep sleepDuration
	MouseClick, left, %jishoX%, %jishoY%
	Sleep sleepDuration
	Send, {BackSpace 20}{Right 20}{BackSpace 20}
	Sleep sleepDuration*2
	Send, %newStr%
	Sleep sleepDuration*2
	Send, {Enter}
	Sleep sleepDuration
	
	
	;wait for user to select a definition
	selectDefinition()
	
	;-----Return-----
	Winactivate, ahk_exe anki.exe
	MouseMove, %mouseTempX%, %mouseTempY%
	Send, {ShiftDown}{Tab}{ShiftUp}
	Sleep sleepDuration
	Send, %originalSelection%
	Sleep sleepDuration
	Send,  - 
	Sleep sleepDuration
	Send, ^v
	Sleep sleepDuration
}
return

selectDefinition(){
	KeyWait, LButton,D
	KeyWait, LButton
	Sleep 50
	Send ^c
	Sleep 50
}
return








Numpad8::
{
	MouseGetPos, mouseTempX, mouseTempY
	
	if(!isSetup){
		positionsSet++
		if(positionsSet == 1){ ;Qolbri
			MouseGetPos, qolibriX, qolibriY
			if(!jishoEnabled)
				isSetup = true
			return
		}
		if(positionsSet >= 2){ ;Jisho
			isSetup = true
			jishoWindow := WinExist("A")
			MouseGetPos, jishoX, jishoY
			return
		}
	}
	
	;-----Copy Selected-----
	Send, ^c
	callWindow := WinExist("A")
	Sleep sleepDuration
	Send, ^c
	Sleep sleepDuration
	clipboardLen := StrLen(Clipboard)
	
	;-----Parse Input-----
	clip := Clipboard
	char := SubStr(clip, 1, 1)
	newStr := ""

	counter := 0
	saveChar := 1
	Loop, %clipboardLen%
	{		
		counter++
		char := SubStr(clip, counter, 1)
		if(char == "[")
			saveChar = 0
		
		if(saveChar == 1)
			newStr = %newStr%%char% 
		
		if(char == "]")
			saveChar = 1
	}
	;MsgBox, %newStr%
	
	;-----Qolbri-----
	if(StrLen(newStr) <= qolibriCharacterLimit){
		Winactivate, ahk_exe qolibri.exe 
		Sleep sleepDuration
		MouseClick, left, %qolibriX%, %qolibriY%
		Sleep sleepDuration
		Send, {BackSpace 20}{Right 20}{BackSpace 20}
		Sleep sleepDuration*2
		Send, %newStr%
		Sleep sleepDuration*2
		Send, {Enter}
		Sleep sleepDuration
	}
	
	
	;-----Jisho-----
	if(jishoEnabled){
		Winactivate, ahk_id %jishoWindow%
		Sleep sleepDuration
		MouseClick, left, %jishoX%, %jishoY%
		Sleep sleepDuration
		Send, {BackSpace 20}{Right 20}{BackSpace 20}
		Sleep sleepDuration*2
		Send, %newStr%
		Sleep sleepDuration*2
		Send, {Enter}
		Sleep sleepDuration
	}
	
	
	;-----Return-----
	Winactivate, ahk_id %callWindow%
	MouseMove, %mouseTempX%, %mouseTempY%
}
return












;Pitch accent lookup
;Only search for one word in qolibri
Numpad7::
{
	MouseGetPos, mouseTempX, mouseTempY
	
	if(!isSetup){
		positionsSet++
		if(positionsSet == 1){ ;Qolbri
			MouseGetPos, qolibriX, qolibriY
			if(!jishoEnabled)
				isSetup = true
			return
		}
		if(positionsSet >= 2){ ;Jisho
			isSetup = true
			jishoWindow := WinExist("A")
			MouseGetPos, jishoX, jishoY
			return
		}
	}
	
	;-----Copy Selected-----
	Send, ^c
	callWindow := WinExist("A")
	Sleep sleepDuration
	Send, ^c
	Sleep sleepDuration
	clipboardLen := StrLen(Clipboard)
	
	;-----Parse Input-----
	clip := Clipboard
	char := SubStr(clip, 1, 1)
	newStr := ""

	counter := 0
	saveChar := 1
	Loop, %clipboardLen%
	{		
		counter++
		char := SubStr(clip, counter, 1)
		if(char == "[")
			saveChar = 0
		
		if(saveChar == 1)
			newStr = %newStr%%char% 
		
		if(char == "]")
			saveChar = 1
	}
	
	;-----Qolbri-----
	Winactivate, ahk_exe qolibri.exe 
	Sleep sleepDuration
	MouseClick, left, %qolibriX%, %qolibriY%
	Sleep sleepDuration
	Send, {BackSpace 20}{Right 20}{BackSpace 20}
	Sleep sleepDuration*2
	Send, %newStr%
	Sleep sleepDuration*2
	Send, {Enter}
	Sleep sleepDuration
	
	;-----Return-----
	Winactivate, ahk_id %callWindow%
	MouseMove, %mouseTempX%, %mouseTempY%
}
return



