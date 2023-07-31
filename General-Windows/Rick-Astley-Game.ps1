#https://genius.com/Rick-astley-never-gonna-give-you-up-lyrics

$Timer = [System.Diagnostics.Stopwatch]::StartNew()

$global:Timer_Start_Time = $Timer

$1 = Read-Host "We're no strangers to ________"

$Global:Score = 0

if ($1 -eq 'love'){

Write-Host "Correct!" -ForegroundColor 'Green'

$Global:Score = $Score + 1

Write-Host "Your score is: $Score" -ForegroundColor 'Yellow'

}

else{

Write-Host "Wrong, the answer is 'love'" -ForegroundColor 'Red'

$Global:Score = $Score + 0

Write-Host "Your score is: $Score" -ForegroundColor 'Yellow'

}

############################################################

$2 = Read-Host "You know the _____________ and so do I"

if ($2 -eq 'rules'){

Write-Host "Correct!" -ForegroundColor 'Green'

$Global:Score = $Score + 1

Write-Host "Your score is: $Score" -ForegroundColor 'Yellow'

}

else{

Write-Host "Wrong, the answer is 'rules'" -ForegroundColor 'Red'

$Global:Score = $Score + 0

Write-Host "Your score is: $Score" -ForegroundColor 'Yellow'

}

############################################################

$Commitments = "commitment's"

$3 = Read-Host "A full _______________ what I'm thinking of"

if ($3 -eq "commitment's"){

Write-Host "Correct!" -ForegroundColor 'Green'

$Global:Score = $Score + 1

Write-Host "Your score is: $Score" -ForegroundColor 'Yellow'

}

else{

Write-Host "Wrong, the answer is $Commitments" -ForegroundColor 'Red'

$Global:Score = $Score + 0

Write-Host "Your score is: $Score" -ForegroundColor 'Yellow'

}

############################################################

$4 = Read-Host "You wouldn't get this from any other _____________"

if ($4 -eq "guy"){

Write-Host "Correct!" -ForegroundColor 'Green'

$Global:Score = $Score + 1

Write-Host "Your score is: $Score" -ForegroundColor 'Yellow'

}

else{

Write-Host "Wrong, the answer is 'guy'" -ForegroundColor 'Red'

$Global:Score = $Score + 0

Write-Host "Your score is: $Score" -ForegroundColor 'Yellow'

}

############################################################

$5 = Read-Host "I just wanna tell you how I'm _______________"

if ($4 -eq "guy"){

Write-Host "Correct!" -ForegroundColor 'Green'

$Global:Score = $Score + 1

Write-Host "Your score is: $Score" -ForegroundColor 'Yellow'

}

else{

Write-Host "Wrong, the answer is 'guy'" -ForegroundColor 'Red'

$Global:Score = $Score + 0

Write-Host "Your score is: $Score" -ForegroundColor 'Yellow'

}

############################################################

$6 = Read-Host "Gotta make you _______________"

if ($6 -eq "understand"){

Write-Host "Correct!" -ForegroundColor 'Green'

$Global:Score = $Score + 1

Write-Host "Your score is: $Score" -ForegroundColor 'Yellow'

}

else{

Write-Host "Wrong, the answer is 'understand'" -ForegroundColor 'Red'

$Global:Score = $Score + 0

Write-Host "Your score is: $Score" -ForegroundColor 'Yellow'

}

############################################################

$7 = Read-Host "Never _______________________"

if ($7 -eq "gonna give you up"){

Write-Host "Correct!" -ForegroundColor 'Green'

$Global:Score = $Score + 1

Write-Host "Your score is: $Score" -ForegroundColor 'Yellow'

}

else{

Write-Host "Wrong, the answer is 'gonna give you up'" -ForegroundColor 'Red'

$Global:Score = $Score + 0

Write-Host "Your score is: $Score" -ForegroundColor 'Yellow'

}

############################################################

$8 = Read-Host "Never _______________________"

if ($8 -eq "gonna let you down"){

Write-Host "Correct!" -ForegroundColor 'Green'

$Global:Score = $Score + 4

Write-Host "Your score is: $Score" -ForegroundColor 'Yellow'

}

else{

Write-Host "Wrong, the answer is 'gonna let you down'" -ForegroundColor 'Red'

$Global:Score = $Score + 0

Write-Host "Your score is: $Score" -ForegroundColor 'Yellow'

}

#########################################################

$10 = Read-Host "Never _______________________"

if ($10 -eq "gonna run around and desert you"){

Write-Host "Correct!" -ForegroundColor 'Green'

$Global:Score = $Score + 6

Write-Host "Your score is: $Score" -ForegroundColor 'Yellow'

}

else{

Write-Host "Wrong, the answer is 'gonna run around and desert you'" -ForegroundColor 'Red'

$Global:Score = $Score + 0

Write-Host "Your score is: $Score" -ForegroundColor 'Yellow'

}

############################################################

$11 = Read-Host "Never _______________________"

if ($11 -eq "gonna make you cry"){

Write-Host "Correct!" -ForegroundColor 'Green'

$Global:Score = $Score + 4

Write-Host "Your score is: $Score" -ForegroundColor 'Yellow'

}

else{

Write-Host "Wrong, the answer is 'gonna make you cry'" -ForegroundColor 'Red'

$Global:Score = $Score + 0

Write-Host "Your score is: $Score" -ForegroundColor 'Yellow'

}

############################################################

$12 = Read-Host "Never _______________________"

if ($12 -eq "gonna say goodbye"){

Write-Host "Correct!" -ForegroundColor 'Green'

$Global:Score = $Score + 3

Write-Host "Your score is: $Score" -ForegroundColor 'Yellow'

}

else{

Write-Host "Wrong, the answer is 'gonna say goodbye'" -ForegroundColor 'Red'

$Global:Score = $Score + 0

Write-Host "Your score is: $Score" -ForegroundColor 'Yellow'

}

############################################################

$13 = Read-Host "Never _______________________"

if ($13 -eq "gonna tell a lie and hurt you"){

Write-Host "Correct!" -ForegroundColor 'Green'

$Global:Score = $Score + 7

Write-Host "Your score is: $Score" -ForegroundColor 'Yellow'

}

else{

Write-Host "Wrong, the answer is 'gonna tell a lie and hurt you'" -ForegroundColor 'Red'

$Global:Score = $Score + 0

Write-Host "Your score is: $Score" -ForegroundColor 'Yellow'

}

$Time_Elapsed = $Timer_Start_Time.Elapsed

	$Timer = $([string]::Format("`{0:d2}:{1:d2}:{2:d2}",
	$Time_Elapsed.hours,
	$Time_Elapsed.minutes,
	$Time_Elapsed.seconds))

	$Timer_New = [int]$Timer

$Timer.Stop

Write-Host "Game complete in '$Timer'!"

Start-Process chrome.exe "https://www.youtube.com/watch?v=dQw4w9WgXcQ&pp=ygUXbmV2ZXIgZ29ubmEgZ2l2ZSB5b3UgdXA%3D"
