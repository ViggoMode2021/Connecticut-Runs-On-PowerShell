$Word_Object = New-Object -ComObject Word.Application # Start Word Process
$Word_Object.Visible = $False # Run 'silently'

$Desktop_Path = [Environment]::GetFolderPath("Desktop") # Get Desktop path from environment variable

$Date = Get-Date # Get today's date

$Today_Date = $Date.ToString('MM-dd-yy') # Convert date to string

$Day_Of_Week = (Get-Date).DayOfWeek # Get day of the week

$Current_Time = (Get-Date).ToString('T') # Get current time

$Current_Month = (Get-Culture).DateTimeFormat.GetMonthName((Get-Date).Month) # Get current month

$Test_Path = Test-Path -Path "$Desktop_Path\TimeSheets\$Current_Month" # Check to see if TimeSheet folder with current month subdirectory is on desktop and if

if($Test_Path -eq $True){

Write-Host "TimeSheets folder already exists." # If the above exists, write message to host and continue

}

else{

New-Item -ItemType Directory -Path $Desktop_Path\TimeSheets\$Current_Month # Create TimeSheet folder with current month subdirectory on desktop

Write-Host "TimeSheets folder created for the month of $Current_Month."

}if($Day_Of_Week -eq "Monday"){ # Run on Mondays

Copy-Item "$Desktop_Path\Blank-Time-Sheet.doc" -Destination "$Desktop_Path\TimeSheets\$Current_Month\Time-Sheet-Week-Of-Monday-$Today_Date.doc" # Make copy of timesheet for current week and save in TimeSheets/Current_Month subfolder

$Find_Monday_Date = “Monday-Date” # Find 'Monday-Date' text in blank timesheet

$Replace_Monday_Date = $Today_Date # Delegate that 'Monday-Date' will be replaced with the actual date

$Find_Monday_Time_In = "Monday-Time-In" # Find 'Monday-Time' text in blank timesheet

$Replace_Monday_Time_In = $Current_Time # Delegate that 'Monday-Time' text will be replaced by current time

$Find_Monday_Total = "Monday-Total" # Find 'Monday-Total' in current timesheet

$Clock_Out_Time = [DateTime]"5:00 PM" # Convert clock out time to datetime format

$Clock_Out_Time_With_Lunch = [DateTime]"4:30 PM" # Subtract 30 minutes from total time worked in order to account for lunch break

$Current_Time = [DateTime]$Current_Time # Convert current time to datetime format

$Total_Time_Worked = New-TimeSpan -Start $Current_Time -End $Clock_Out_Time_With_Lunch # Create timespan from current time to clock out time

$Total_Time_Worked = [String]$Total_Time_Worked # Convert to string

$Total_Time_Worked_Monday = "Mon-Total:" + "`n`n`n$Total_Time_Worked" # Append "Mon-Total:" to $Total_Time_Worked

$Document_Object = $Word_Object.Documents.Open(“$Desktop_Path\TimeSheets\$Current_Month\Time-Sheet-Week-Of-Monday-$Today_Date.doc”) # Reopen doc
$Object_Selection = $Word_Object.Selection # Select objects

$ReplaceAll = 2
$FindContinue = 1
$MatchCase = $False
$MatchWholeWord = $True
$MatchWildcards = $False
$MatchSoundsLike = $False
$MatchAllWordForms = $False
$Forward = $True
$Wrap = $FindContinue
$Format = $False

$Object_Selection.Find.Execute($Find_Monday_Date, $MatchCase,
  $MatchWholeWord,$MatchWildcards,$MatchSoundsLike,
  $MatchAllWordForms,$Forward,$Wrap,$Format, $Replace_Monday_Date,
  $ReplaceAll) # Write Monday's date to timesheet

$Object_Selection.Find.Execute($Find_Monday_Time_In, $MatchCase,
  $MatchWholeWord,$MatchWildcards,$MatchSoundsLike,
  $MatchAllWordForms,$Forward,$Wrap,$Format, $Replace_Monday_Time_In,
  $ReplaceAll) # Write Monday's clock in time to timesheet

$Object_Selection.Find.Execute($Find_Monday_Total, $MatchCase,
  $MatchWholeWord,$MatchWildcards,$MatchSoundsLike,
  $MatchAllWordForms,$Forward,$Wrap,$Format, $Total_Time_Worked_Monday,
  $ReplaceAll) # Write Monday's total time to timesheet

}

if($Day_Of_Week -eq "Tuesday"){ # Similar as above but for Tuesday

$Today_Date = $Date.ToString('MM-dd-yy')

$Today_Date = [DateTime]$Today_Date

$Yesterday = $Today_Date.AddDays(-1)

$Yesterday = $Yesterday.ToString('MM-dd-yy')

$Find_Tuesday_Date = “Tuesday-Date”

$Replace_Tuesday_Date = $Today_Date

$Find_Tuesday_Time_In = "Tuesday-Time-In"

$Replace_Tuesday_Time_In = $Current_Time

$Find_Tuesday_Total = "Tuesday-Total"

$Clock_Out_Time = [DateTime]"5:00 PM"

$Clock_Out_Time_With_Lunch = [DateTime]"4:30 PM"

$Current_Time = [DateTime]$Current_Time

$Total_Time_Worked = New-TimeSpan -Start $Current_Time -End $Clock_Out_Time_With_Lunch 

$Total_Time_Worked = [String]$Total_Time_Worked

$Total_Time_Worked_Tuesday = "Tues-Total:" + "`n`n`n$Total_Time_Worked"

$Document_Object = $Word_Object.Documents.Open(“$Desktop_Path\TimeSheets\$Current_Month\Time-Sheet-Week-Of-Monday-$Yesterday.doc”)
$Object_Selection = $Word_Object.Selection

$ReplaceAll = 2
$FindContinue = 1
$MatchCase = $False
$MatchWholeWord = $True
$MatchWildcards = $False
$MatchSoundsLike = $False
$MatchAllWordForms = $False
$Forward = $True
$Wrap = $FindContinue
$Format = $False

$Object_Selection.Find.Execute($Find_Tuesday_Date, $MatchCase,
  $MatchWholeWord,$MatchWildcards,$MatchSoundsLike,
  $MatchAllWordForms,$Forward,$Wrap,$Format,$Replace_Tuesday_Date,
  $ReplaceAll)

$Object_Selection.Find.Execute($Find_Tuesday_Time_In, $MatchCase,
  $MatchWholeWord,$MatchWildcards,$MatchSoundsLike,
  $MatchAllWordForms,$Forward,$Wrap,$Format, $Replace_Tuesday_Time_In,
  $ReplaceAll)

$Object_Selection.Find.Execute($Find_Tuesday_Total, $MatchCase,
  $MatchWholeWord,$MatchWildcards,$MatchSoundsLike,
  $MatchAllWordForms,$Forward,$Wrap,$Format, $Total_Time_Worked_Tuesday,
  $ReplaceAll)

}

if($Day_Of_Week -eq "Wednesday"){

$Today_Date = $Date.ToString('MM-dd-yy')

$Today_Date = [DateTime]$Today_Date

$Monday = $Today_Date.AddDays(-2)

$Monday = $Monday.ToString('MM-dd-yy')

$Find_Wednesday_Date = “Wednesday-Date”

$Replace_Wednesday_Date = $Today_Date

$Find_Wednesday_Time_In = "Wednesday-Time-In"

$Replace_Wednesday_Time_In = $Current_Time

$Find_Wednesday_Total = "Wednesday-Total"

$Clock_Out_Time = [DateTime]"5:00 PM"

$Clock_Out_Time_With_Lunch = [DateTime]"4:30 PM"

$Current_Time = [DateTime]$Current_Time

$Total_Time_Worked = New-TimeSpan -Start $Current_Time -End $Clock_Out_Time_With_Lunch 
$Total_Time_Worked = [String]$Total_Time_Worked

$Total_Time_Worked_Wednesday = "Wed-Total:" + "`n`n`n$Total_Time_Worked"

$Document_Object = $Word_Object.Documents.Open(“$Desktop_Path\TimeSheets\$Current_Month\Time-Sheet-Week-Of-Monday-$Monday.doc”)
$Object_Selection = $Word_Object.Selection

$ReplaceAll = 2
$FindContinue = 1
$MatchCase = $False
$MatchWholeWord = $True
$MatchWildcards = $False
$MatchSoundsLike = $False
$MatchAllWordForms = $False
$Forward = $True
$Wrap = $FindContinue
$Format = $False

$Object_Selection.Find.Execute($Find_Wednesday_Date, $MatchCase,
  $MatchWholeWord,$MatchWildcards,$MatchSoundsLike,
  $MatchAllWordForms,$Forward,$Wrap,$Format,$Replace_Wednesday_Date,
  $ReplaceAll)

$Object_Selection.Find.Execute($Find_Wednesday_Time_In, $MatchCase,
  $MatchWholeWord,$MatchWildcards,$MatchSoundsLike,
  $MatchAllWordForms,$Forward,$Wrap,$Format,$Replace_Wednesday_Time_In,
  $ReplaceAll)

$Object_Selection.Find.Execute($Find_Wednesday_Total, $MatchCase,
  $MatchWholeWord,$MatchWildcards,$MatchSoundsLike,
  $MatchAllWordForms,$Forward,$Wrap,$Format, $Total_Time_Worked_Wednesday,
  $ReplaceAll)

}

if($Day_Of_Week -eq "Thursday"){

$Today_Date = $Date.ToString('MM-dd-yy')

$Today_Date = [DateTime]$Today_Date

$Monday = $Today_Date.AddDays(-3)

$Monday = $Monday.ToString('MM-dd-yy')

$Find_Thursday_Date = “Thursday-Date”

$Replace_Thursday_Date = $Today_Date

$Find_Thursday_Time_In = "Thursday-Time-In"

$Replace_Thursday_Time_In = $Current_Time

$Find_Thursday_Total = "Thursday-Total"

$Clock_Out_Time = [DateTime]"5:00 PM"

$Clock_Out_Time_With_Lunch = [DateTime]"4:30 PM"

$Current_Time = [DateTime]$Current_Time

$Total_Time_Worked = New-TimeSpan -Start $Current_Time -End $Clock_Out_Time_With_Lunch
$Total_Time_Worked = [String]$Total_Time_Worked

$Total_Time_Worked_Thursday = "Thurs-Total:" + "`n`n`n$Total_Time_Worked"

$Document_Object = $Word_Object.Documents.Open(“$Desktop_Path\TimeSheets\$Current_Month\Time-Sheet-Week-Of-Monday-$Monday.doc”)
$Object_Selection = $Word_Object.Selection

$ReplaceAll = 2
$FindContinue = 1
$MatchCase = $False
$MatchWholeWord = $True
$MatchWildcards = $False
$MatchSoundsLike = $False
$MatchAllWordForms = $False
$Forward = $True
$Wrap = $FindContinue
$Format = $False

$Object_Selection.Find.Execute($Find_Thursday_Date, $MatchCase,
  $MatchWholeWord,$MatchWildcards,$MatchSoundsLike,
  $MatchAllWordForms,$Forward,$Wrap,$Format,$Replace_Thursday_Date,
  $ReplaceAll)

$Object_Selection.Find.Execute($Find_Thursday_Time_In, $MatchCase,
  $MatchWholeWord,$MatchWildcards,$MatchSoundsLike,
  $MatchAllWordForms,$Forward,$Wrap,$Format, $Replace_Thursday_Time_In,
  $ReplaceAll)

$Object_Selection.Find.Execute($Find_Thursday_Total, $MatchCase,
  $MatchWholeWord,$MatchWildcards,$MatchSoundsLike,
  $MatchAllWordForms,$Forward,$Wrap,$Format, $Total_Time_Worked_Thursday,
  $ReplaceAll)

}

if($Day_Of_Week -eq "Friday"){

$Today_Date = $Date.ToString('MM-dd-yy')

$Today_Date = [DateTime]$Today_Date

$Monday = $Today_Date.AddDays(-4)

$Monday = $Monday.ToString('MM-dd-yy')

$Find_Friday_Date = “Friday-Date”

$Find_Friday_Date = $Today_Date

$Find_Friday_Time_In = "Friday-Time-In"

$Replace_Friday_Time_In = $Current_Time

$Find_Friday_Total = "Friday-Total"

$Clock_Out_Time = [DateTime]"5:00 PM"

$Clock_Out_Time_With_Lunch = [DateTime]"4:30 PM"

$Current_Time = [DateTime]$Current_Time

$Total_Time_Worked = New-TimeSpan -Start $Current_Time -End $Clock_Out_Time_With_Lunch
$Total_Time_Worked = [String]$Total_Time_Worked

$Total_Time_Worked_Friday = "Fri-Total:" + "`n`n`n$Total_Time_Worked"

$Document_Object = $Word_Object.Documents.Open(“$Desktop_Path\TimeSheets\$Current_Month\Time-Sheet-Week-Of-Monday-$Monday.doc”)
$Object_Selection = $Word_Object.Selection

$ReplaceAll = 2
$FindContinue = 1
$MatchCase = $False
$MatchWholeWord = $True
$MatchWildcards = $False
$MatchSoundsLike = $False
$MatchAllWordForms = $False
$Forward = $True
$Wrap = $FindContinue
$Format = $False

$Object_Selection.Find.Execute($Find_Friday_Date, $MatchCase,
  $MatchWholeWord,$MatchWildcards,$MatchSoundsLike,
  $MatchAllWordForms,$Forward,$Wrap,$Format,$Replace_Friday_Date,
  $ReplaceAll)

$Object_Selection.Find.Execute($Find_Friday_Time_In, $MatchCase,
  $MatchWholeWord,$MatchWildcards,$MatchSoundsLike,
  $MatchAllWordForms,$Forward,$Wrap,$Format, $Replace_Friday_Time_In,
  $ReplaceAll)

$Object_Selection.Find.Execute($Find_Friday_Total, $MatchCase,
  $MatchWholeWord,$MatchWildcards,$MatchSoundsLike,
  $MatchAllWordForms,$Forward,$Wrap,$Format, $Total_Time_Worked_Friday,
  $ReplaceAll)

# Get Monday minutes and hours

$Document_Object = $Word_Object.Documents.Open(“$Desktop_Path\TimeSheets\$Current_Month\Time-Sheet-Week-Of-Monday-$Monday.doc”)

$Monday_Time = $Document_Object.Tables[1].Cell(3,2).range.text

$Monday_Time_Worked = $Monday_Time.IndexOf("Mon-Total:")

$Total_Monday_Time_Worked = $Monday_Time.Substring($Monday_Time_Worked+10)

$Total_Monday_Time_Worked = $Total_Monday_Time_Worked -replace '\s',''

$Total_Monday_Time_Worked_Hours = $Total_Monday_Time_Worked.Substring(0,2)

Write-Host "Total Monday hours: $Total_Monday_Time_Worked_Hours"

$Total_Monday_Time_Worked_Hours = [int]$Total_Monday_Time_Worked_Hours

$Total_Monday_Time_Worked_Minutes = $Total_Monday_Time_Worked.Substring(3,3)

$Total_Monday_Time_Worked_Minutes = $Total_Monday_Time_Worked_Minutes.replace(":", "")

$Total_Monday_Time_Worked_Minutes = [int]$Total_Monday_Time_Worked_Minutes

# Get Tuesday minutes and hours

$Document_Object = $Word_Object.Documents.Open(“$Desktop_Path\TimeSheets\$Current_Month\Time-Sheet-Week-Of-Monday-$Monday.doc”)

$Tuesday_Time = $Document_Object.Tables[1].Cell(3,3).range.text

$Tuesday_Time_Worked = $Tuesday_Time.IndexOf("Tues-Total:")

$Total_Tuesday_Time_Worked = $Tuesday_Time.Substring($Tuesday_Time_Worked+11)

$Total_Tuesday_Time_Worked = $Total_Tuesday_Time_Worked -replace '\s',''

$Total_Tuesday_Time_Worked_Hours = $Total_Tuesday_Time_Worked.Substring(0,2)

Write-Host "Total Tuesday hours: $Total_Tuesday_Time_Worked_Hours"

$Total_Tuesday_Time_Worked_Hours = [int]$Total_Tuesday_Time_Worked_Hours

$Total_Tuesday_Time_Worked_Minutes = $Total_Tuesday_Time_Worked.Substring(3,3)

$Total_Tuesday_Time_Worked_Minutes = $Total_Tuesday_Time_Worked_Minutes.replace(":", "")

$Total_Tuesday_Time_Worked_Minutes = [int]$Total_Tuesday_Time_Worked_Minutes

# Get Wednesday minutes and hours

$Document_Object = $Word_Object.Documents.Open(“$Desktop_Path\TimeSheets\$Current_Month\Time-Sheet-Week-Of-Monday-$Monday.doc”)

$Wednesday_Time = $Document_Object.Tables[1].Cell(3,4).range.text

$Wednesday_Time_Worked = $Wednesday_Time.IndexOf("Wed-Total:")

$Total_Wednesday_Time_Worked = $Wednesday_Time.Substring($Wednesday_Time_Worked+10)

$Total_Wednesday_Time_Worked = $Total_Wednesday_Time_Worked -replace '\s',''

$Total_Wednesday_Time_Worked_Hours = $Total_Wednesday_Time_Worked.Substring(0,2)

Write-Host "Total Wednesday hours: $Total_Wednesday_Time_Worked_Hours"

$Total_Wednesday_Time_Worked_Hours = [int]$Total_Wednesday_Time_Worked_Hours

$Total_Wednesday_Time_Worked_Minutes = $Total_Wednesday_Time_Worked.Substring(3,3)

$Total_Wednesday_Time_Worked_Minutes = $Total_Wednesday_Time_Worked_Minutes.replace(":", "")

$Total_Wednesday_Time_Worked_Minutes = [int]$Total_Wednesday_Time_Worked_Minutes

# Get Thursday minutes and hours

$Document_Object = $Word_Object.Documents.Open(“$Desktop_Path\TimeSheets\$Current_Month\Time-Sheet-Week-Of-Monday-$Monday.doc”)

$Thursday_Time = $Document_Object.Tables[1].Cell(3,5).range.text

$Thursday_Time_Worked = $Thursday_Time.IndexOf("Thurs-Total:")

$Total_Thursday_Time_Worked = $Thursday_Time.Substring($Thursday_Time_Worked+12)

$Total_Thursday_Time_Worked = $Total_Thursday_Time_Worked -replace '\s',''

$Total_Thursday_Time_Worked_Hours = $Total_Thursday_Time_Worked.Substring(0,2)

Write-Host "Total Thursday hours: $Total_Thursday_Time_Worked_Hours"

$Total_Thursday_Time_Worked_Hours = [int]$Total_Thursday_Time_Worked_Hours

$Total_Thursday_Time_Worked_Minutes = $Total_Thursday_Time_Worked.Substring(3,3)

$Total_Thursday_Time_Worked_Minutes = $Total_Thursday_Time_Worked_Minutes.replace(":", "")

$Total_Thursday_Time_Worked_Minutes = [int]$Total_Thursday_Time_Worked_Minutes

# Get Friday minutes and hours

$Document_Object = $Word_Object.Documents.Open(“$Desktop_Path\TimeSheets\$Current_Month\Time-Sheet-Week-Of-Monday-$Monday.doc”)

$Friday_Time = $Document_Object.Tables[1].Cell(3,6).range.text

$Friday_Time_Worked = $Friday_Time.IndexOf("Fri-Total:")

$Total_Friday_Time_Worked = $Friday_Time.Substring($Friday_Time_Worked+10)

$Total_Friday_Time_Worked = $Total_Friday_Time_Worked -replace '\s',''

$Total_Friday_Time_Worked_Hours = $Total_Friday_Time_Worked.Substring(0,2)

Write-Host "Total Friday hours: $Total_Friday_Time_Worked_Hours"

$Total_Friday_Time_Worked_Hours = [int]$Total_Friday_Time_Worked_Hours

$Total_Friday_Time_Worked_Minutes = $Total_Friday_Time_Worked.Substring(3,3)

$Total_Friday_Time_Worked_Minutes = $Total_Friday_Time_Worked_Minutes.replace(":", "")

$Total_Friday_Time_Worked_Minutes = [int]$Total_Friday_Time_Worked_Minutes

$Total_Hours_Worked = $Total_Monday_Time_Worked_Hours + $Total_Tuesday_Time_Worked_Hours + $Total_Wednesday_Time_Worked_Hours + $Total_Thursday_Time_Worked_Hours + $Total_Friday_Time_Worked_Hours

$Total_Minutes_Worked = $Total_Monday_Time_Worked_Minutes + $Total_Tuesday_Time_Worked_Minutes + $Total_Wednesday_Time_Worked_Minutes + $Total_Thursday_Time_Worked_Minutes + $Total_Friday_Time_Worked_Minutes

$Total_Minutes_Worked = $Total_Minutes_Worked / 60

$Total_Time_Worked = $Total_Hours_Worked + $Total_Minutes_Worked

$Find_Reg_Total = "Reg-Total"

$Replace_Reg_Total = $Total_Time_Worked

$ReplaceAll = 2
$FindContinue = 1
$MatchCase = $False
$MatchWholeWord = $True
$MatchWildcards = $False
$MatchSoundsLike = $False
$MatchAllWordForms = $False
$Forward = $True
$Wrap = $FindContinue
$Format = $False

$Object_Selection.Find.Execute($Find_Reg_Total, $MatchCase,
  $MatchWholeWord,$MatchWildcards,$MatchSoundsLike,
  $MatchAllWordForms,$Forward,$Wrap,$Format,$Replace_Reg_Total,
  $ReplaceAll)

$Find_Total_Total = "Total-Total"

$Replace_Total_Total = $Total_Time_Worked

$ReplaceAll = 2
$FindContinue = 1
$MatchCase = $False
$MatchWholeWord = $True
$MatchWildcards = $False
$MatchSoundsLike = $False
$MatchAllWordForms = $False
$Forward = $True
$Wrap = $FindContinue
$Format = $False

$Object_Selection.Find.Execute($Find_Total_Total, $MatchCase,
  $MatchWholeWord,$MatchWildcards,$MatchSoundsLike,
  $MatchAllWordForms,$Forward,$Wrap,$Format,$Replace_Total_Total,
  $ReplaceAll)

$Find_Total_Hours = "Total-Hours"

$Replace_Total_Hours = $Total_Time_Worked

$ReplaceAll = 2
$FindContinue = 1
$MatchCase = $False
$MatchWholeWord = $True
$MatchWildcards = $False
$MatchSoundsLike = $False
$MatchAllWordForms = $False
$Forward = $True
$Wrap = $FindContinue
$Format = $False

$Object_Selection.Find.Execute($Find_Total_Hours, $MatchCase,
  $MatchWholeWord,$MatchWildcards,$MatchSoundsLike,
  $MatchAllWordForms,$Forward,$Wrap,$Format,$Replace_Total_Hours,
  $ReplaceAll)


$Find_Week_Ending_Hours = "Week-Ending"

$Replace_Week_Ending = $Today_Date

$ReplaceAll = 2
$FindContinue = 1
$MatchCase = $False
$MatchWholeWord = $True
$MatchWildcards = $False
$MatchSoundsLike = $False
$MatchAllWordForms = $False
$Forward = $True
$Wrap = $FindContinue
$Format = $False

$Object_Selection.Find.Execute($Find_Week_Ending_Hours, $MatchCase,
  $MatchWholeWord,$MatchWildcards,$MatchSoundsLike,
  $MatchAllWordForms,$Forward,$Wrap,$Format,$Replace_Week_Ending,
  $ReplaceAll)


$Find_Employee_Date = "Week-Ending"

$Replace_Week_Ending = $Today_Date

$ReplaceAll = 2
$FindContinue = 1
$MatchCase = $False
$MatchWholeWord = $True
$MatchWildcards = $False
$MatchSoundsLike = $False
$MatchAllWordForms = $False
$Forward = $True
$Wrap = $FindContinue
$Format = $False

$Object_Selection.Find.Execute($Find_Week_Ending_Hours, $MatchCase,
  $MatchWholeWord,$MatchWildcards,$MatchSoundsLike,
  $MatchAllWordForms,$Forward,$Wrap,$Format,$Replace_Week_Ending,
  $ReplaceAll)

#Start-Process -FilePath “$Desktop_Path\TimeSheets\$Current_Month\Time-Sheet-Week-Of-Monday-$Monday.doc” -Verb Print

}

Stop-Process -Name "*Microsoft Word*"
