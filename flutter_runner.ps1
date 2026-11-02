param(
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]]$FlutterArgs
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$env:FLUTTER_ALREADY_LOCKED = "true"
$env:LOCALAPPDATA = "$scriptDir\.localappdata"
$env:APPDATA = "$scriptDir\.appdata"
$env:PUB_CACHE = "$scriptDir\.pub_cache"
$env:FLUTTER_ROOT = "C:\flutter"

& "C:\flutter\bin\cache\dart-sdk\bin\dart.exe" `
  --disable-dart-dev `
  --packages="C:\flutter\packages\flutter_tools\.dart_tool\package_config.json" `
  "C:\flutter\bin\cache\flutter_tools.snapshot" `
  --suppress-analytics `
  --no-version-check `
  @FlutterArgs

