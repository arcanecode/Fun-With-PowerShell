

Enum DaysOfWeek
{
  Sunday = 0
  Monday = 1
  Tuesday = 2
  Wednesday = 3
  Thursday = 4
  Friday = 5
  Saturday = 6
}

function IsItHamClubNight($Day)
{
  if ($Day -eq 4)
  { Write-Host "Yay! It's ham club night" }
  else 
  { Write-Host "Sorry, just a boring night" }
}

$day = 4
IsItHamClubNight $day

$day = [DaysOfWeek]::Thursday
IsItHamClubNight $day

IsItHamClubNight ([DayOfWeek]::Thursday)

[DaysOfWeek].GetEnumNames()

foreach( $enumValue in [DaysOfWeek].GetEnumNames())
{
  Write-Host "Enum Value is $enumValue"
}

[DaysOfWeek].GetEnumName(4)

[DaysOfWeek].GetEnumNames() |
  ForEach-Object { "{0} {1}" -f $_, [int]([DaysOfWeek]::$_) }


foreach( $enumValue in ([DaysOfWeek].GetEnumNames()) )
{
  $enumNumber = [int]$_
  Write-Host "Enum Value is $enumValue $enumNumber"
}


# You can assign the same value to several enums if you need to
Enum ClubPositions
{
  President = 1
  VicePresident = 1
  Secretary = 2
  Treasurer = 2
  Webmaster = 3
  Greeter = 3
  SnackBringer = 3
}


# All True
[ClubPositions]::President -eq 1
[ClubPositions]::VicePresident -eq 1
[ClubPositions]::President -eq [ClubPositions]::VicePresident

[ClubPositions].GetEnumNames()

[DaysOfWeek].GetEnumValues()

[ClubPositions].GetEnumValues()

# Flags
[Flags()] enum MemberStatus
{
  Paid = 1
  President = 2
  VicePresident = 4
  Secretary = 8
  Treasurer = 16
  Webmaster = 32
}

$memStatus = [MemberStatus]::Paid + [MemberStatus]::VicePresident
$memStatus

$memStatus = [MemberStatus] 5
$memStatus

[int]$memStatus

$memStatus = [MemberStatus] 41
$memStatus

# HasFlag

$memStatus = [MemberStatus]::Webmaster + [MemberStatus]::Secretary + [MemberStatus]::Paid
$memStatus

$memStatus.HasFlag([MemberStatus]::Paid)

# GetHashCode

[int]$memStatus

$memStatus.GetHashCode()

