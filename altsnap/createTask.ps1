$trigger = New-ScheduledTaskTrigger -AtLogOn -RandomDelay "00:00:10"
$principal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Users" -RunLevel Highest
$action = New-ScheduledTaskAction -Execute "$HOME\AppData\Roaming\AltSnap\AltSnap.exe"
$settings = New-ScheduledTaskSettingsSet -MultipleInstances IgnoreNew -ExecutionTimeLimit 0
Register-ScheduledTask -TaskName "AltSnap" -Trigger $trigger -Principal $principal -Action $action -Description "Start AltSnap on logon" -Force -Settings $settings
