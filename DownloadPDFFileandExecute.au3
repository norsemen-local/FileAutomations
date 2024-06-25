#include <Inet.au3>
#include <Array.au3>
#include <MsgBoxConstants.au3>
#include <InetConstants.au3>
#include <WinAPIFiles.au3>
#include <Timers.au3>

#comments-start
******************************************************************************************************************
*  The script's overall purpose is to automate the process of downloading a PDF file from a website,             *
*  performing specific actions on the downloaded file, such as opening and scrolling through it,                 *
*  and then deleting the file. Additionally, it simulates random mouse movements                                 *
*  and clicks to mimic user activity on the computer.                                                            *
*                                                                                                                *
*                                                                                                                *
*                                  The Script created by SilentProcess                                           *
******************************************************************************************************************
#comments-End

Func generateMouseMovement()
; Set the time period to 1 minute (60000 milliseconds)
    Local $iTimePeriod = 6000

    ; Get the start time
    Local $hTimer = TimerInit()

    ; Run the loop for the specified time period
    While TimerDiff($hTimer) < $iTimePeriod
        ; Generate random coordinates for mouse movement within the screen bounds
        Local $iX = Random(0, @DesktopWidth, 1)
        Local $iY = Random(0, @DesktopHeight, 1)

        ; Move the mouse to the random coordinates
        MouseMove($iX, $iY, 10) ; The third parameter is the speed of the movement

        ; Pause for a short random time between movements
        Sleep(Random(500, 1500))

        ; Randomly decide whether to click the mouse
        If Random(0, 1, 1) = 1 Then
            MouseClick("left")
        EndIf
    WEnd
EndFunc

Func fileDownload($sURL)
	; Open Browser
		MouseMove(408,881,50)
	Sleep(10000)
	MouseClick("left")
	
	; Navigate to the Address bar
	MouseMove(172,52,40)
	Sleep(15000)
	MouseClick("left")
	
	; Insert url to the address bar and click enter
	send($sURL  &"{ENTER}")

	; save the pdf file using the icon
	MouseMove(1559,89,40)
	Sleep(30000)
	MouseClick("left")
	Sleep(2000)

	; Replace white spaces with underscore and save it
	Send("^a")
	Send("^c")
	local $fileName = ClipGet()
	local $strManipulation = StringReplace($fileName, " ", "_")
	ClipPut($strManipulation)
	Send("^V")
	Send("{ENTER}")
	Sleep(25000)
	Send("!{F4}") ; Exit browser
EndFunc   ;==>Example


Func getPDFLink()
	
	; URL of the website to read text from
	Local $url =
	
	; Read the content of the website
	Local $sData = _INetGetSource($url)

	; Check if data was successfully retrieved
	If @error Then
		return ""
	EndIf

	; Parse the content by delimiter (comma)
	Local $aArray = StringSplit($sData, ",")

	; Check if the parsing was successful
	If @error Then
		return ""
	EndIf

	; Remove the first element of the array which contains the count of elements
	_ArrayDelete($aArray, 0)

	; Pick a random line from the array
	Local $iRandomIndex = Random(1, UBound($aArray) - 1, 1)
	Return $aArray[$iRandomIndex]
EndFunc




Global $url = ""
while $url = ""
	$url = getPDFLink()
	sleep(500)
WEnd

fileDownload($url)
Sleep(1500)
; Step 3: Navigate to the Downloads folder
$filename = ClipGet() &".pdf"
Send("#r")
Sleep(500)
Send(@UserProfileDir & "\Downloads\"& $fileName  &"{ENTER}")


Sleep(7000)
MouseMove(762,439)
	MouseClick("left")

MouseWheel("down",13)
Sleep(2000)
MouseWheel("down",23)
Sleep(2000)
MouseWheel("down",9)
Sleep(2000)
MouseWheel("up",5)
Sleep(7000)
MouseWheel("up",25)

; Step 5: Close the PDF file (assuming default PDF viewer)
Send("!{F4}")
Sleep(1000)

FileDelete(@UserProfileDir & "\Downloads\"& $fileName)
Sleep(1000)

generateMouseMovement()
