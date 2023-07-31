$videoId = 'WUQoh_1pFzE'

$channelId = 'UCWNxa-_nWe_w9SFfgFF1LoQ'

$GoogleApiKey = '' # Place GoogleApiKey here

$video_analytics = 'C:\Users\ryans\Desktop\Daily-Knight-Analytics\Announcements.csv' #Edit with updated PATH for whatever computer is housing this script

$Date = Date

if (Test-Path $video_analytics) {
    Write-Host "Analytics CSV file already exists titled 'Announcements.csv'"
}
else {
    Add-Content -Path C:\Users\ryans\Desktop\Daily-Knight-Analytics\Announcements.csv -Value '"Date","Views","Likes","Comments"'

    Write-Host "Analytics CSV file created titled 'Announcements.csv'"

}

function start_and_stop_announcements{
Stop-Process -Name msedge
Start-Process msedge https://www.youtube.com/embed/WUQoh_1pFzE?autoplay=1 #Replace with LiveStream link https://www.youtube.com/
Sleep 5
Stop-Process -Name msedge
Start-Process -FilePath  msedge -ArgumentList '--start-fullscreen https://docs.google.com/presentation/d/e/2PACX-1vSmux0MzvHL6vpWuTzi_mvJ4AHdjP7TkKLAiA-nYTt82Wh2VNvECzNq2jCGPRUUoOo2XWFrb2dYypJp/pub?start=true"&"loop=true"&"delayms=10000"&"slide=id.p'
}

start_and_stop_announcements

function get_video_date{
try {
   
   $Views = (Invoke-RestMethod -uri "https://www.googleapis.com/youtube/v3/videos?id=$videoId&key=$GoogleApiKey&part=snippet,contentDetails,statistics,status").items.statistics.viewCount
   $Likes = (Invoke-RestMethod -uri "https://www.googleapis.com/youtube/v3/videos?id=$videoId&key=$GoogleApiKey&part=snippet,contentDetails,statistics,status").items.statistics.likeCount
   $Comments = (Invoke-RestMethod -uri "https://www.googleapis.com/youtube/v3/videos?id=$videoId&key=$GoogleApiKey&part=snippet,contentDetails,statistics,status").items.statistics.commentCount

   $NewRow = "$Date,$Views,$Likes,$Comments"

   $NewRow | Add-Content -Path $video_analytics 

   $newRow = New-Object PsObject -Property @{Date = $Date ; Views = "$Views" ; Likes = $Likes ; Comments = $Comments }
   $fileContent += $newRow

   $filecontent | Export-csv -append $video_analytics

}

catch {
    Write-Host "The video and its information could not be loaded."
}

Finally
 {
  Write-Host “Script ended on $Date"
 }

}

get_video_date
