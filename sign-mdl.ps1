param(
  [string]$MdlAddress,
  [string[]]$PrlAddress,
  [string]$OutputFile,
  [string]$InputFile = ".\sign-input.txt",
  [string]$CliDir = ".\cli",
  [string]$ReleaseTag = "pearl-wallet-v2.0.0",
  [switch]$CheckOnly,
  [switch]$NoPause
)

$ErrorActionPreference = "Stop"

function Write-Info {
  param([string]$Message)
  Write-Host "[Pearl] $Message"
}

function Wait-BeforeExit {
  if ($NoPause) {
    return
  }
  Write-Host ""
  Read-Host "Нажмите Enter, чтобы закрыть окно / Press Enter to close this window"
}

trap {
  Write-Host ""
  Write-Host "Ошибка / Error: $($_.Exception.Message)"
  Wait-BeforeExit
  exit 1
}

function Resolve-FullPath {
  param([string]$Path)
  if ([System.IO.Path]::IsPathRooted($Path)) {
    return $Path
  }
  return [System.IO.Path]::GetFullPath((Join-Path (Get-Location) $Path))
}

function Read-SignInput {
  param([string]$Path)

  if (-not (Test-Path -LiteralPath $Path)) {
    return $null
  }

  $lines = Get-Content -LiteralPath $Path
  $mdl = $null
  $outputFile = $null
  $addresses = New-Object System.Collections.Generic.List[string]

  foreach ($line in $lines) {
    $text = $line.Trim()
    if (-not $text -or $text.StartsWith("#")) {
      continue
    }

    if ($text -match "^MDL=(.+)$") {
      $mdl = $Matches[1].Trim()
      continue
    }

    if ($text -match "^PRL=(.+)$") {
      foreach ($part in ($Matches[1] -split "[,;\s]+")) {
        if ($part -and $part.Trim()) {
          $addresses.Add($part.Trim())
        }
      }
      continue
    }

    if ($text -match "^OUTPUT=(.+)$") {
      $outputFile = $Matches[1].Trim()
      continue
    }
  }

  if (-not $mdl -or $addresses.Count -eq 0) {
    return $null
  }
  $mdl = Normalize-MdlAddress -Value $mdl

  return [PSCustomObject]@{
    MdlAddress = $mdl
    PrlAddresses = $addresses.ToArray()
    OutputFile = $outputFile
  }
}

function Read-InteractiveSignRequest {
  param(
    [string]$InitialMdlAddress,
    [string[]]$InitialPrlAddresses,
    [string]$InitialOutputFile
  )

  $mdl = $InitialMdlAddress
  while (-not $mdl -or -not $mdl.Trim()) {
    $mdl = Read-Host "Введите MDL-адрес, который нужно подписать / Enter the MDL address to sign"
  }
  $mdl = Normalize-MdlAddress -Value $mdl

  $addresses = New-Object System.Collections.Generic.List[string]
  if ($InitialPrlAddresses) {
    foreach ($address in $InitialPrlAddresses) {
      foreach ($part in ($address -split "[,;\s]+")) {
        if ($part -and $part.Trim()) {
          $addresses.Add($part.Trim())
        }
      }
    }
  }

  if ($addresses.Count -eq 0) {
    Write-Info "Введите PRL-адреса из Pearl Wallet. Один адрес на строку. Пустая строка завершает ввод. / Enter Pearl Wallet PRL addresses. One address per line. Empty line finishes input."
    while ($true) {
      $address = Read-Host "PRL-адрес / PRL address"
      if (-not $address -or -not $address.Trim()) {
        break
      }
      foreach ($part in ($address -split "[,;\s]+")) {
        if ($part -and $part.Trim()) {
          $addresses.Add($part.Trim())
        }
      }
    }
  }

  if ($addresses.Count -eq 0) {
    throw "Не указан ни один PRL-адрес. / No PRL address was specified."
  }

  $output = $InitialOutputFile
  if (-not $output -or -not $output.Trim()) {
    $output = Get-DefaultOutputFileName -MdlAddress $mdl -PrlAddresses $addresses.ToArray()
  }

  return [PSCustomObject]@{
    MdlAddress = $mdl
    PrlAddresses = $addresses.ToArray()
    OutputFile = $output.Trim()
  }
}

function Get-AddressSuffix {
  param([string]$Value)

  $clean = $Value.Trim()
  if ($clean.Length -le 6) {
    return $clean
  }

  return $clean.Substring($clean.Length - 6)
}

function Get-DefaultOutputFileName {
  param(
    [string]$MdlAddress,
    [string[]]$PrlAddresses
  )

  $mdlSuffix = Get-AddressSuffix -Value $MdlAddress
  if ($PrlAddresses.Count -eq 1) {
    $prlSuffix = Get-AddressSuffix -Value $PrlAddresses[0]
    return "prl_$prlSuffix+mdl_$mdlSuffix.txt"
  }

  return "prl_multi_$($PrlAddresses.Count)+mdl_$mdlSuffix.txt"
}

function Normalize-MdlAddress {
  param([string]$Value)

  $clean = $Value.Trim().Trim('"')
  if ($clean -match "^\s*I\s+set\s+(.+)$") {
    return $Matches[1].Trim().Trim('"')
  }

  return $clean
}

function Get-MdlSignMessage {
  param([string]$MdlAddress)

  return "I set $(Normalize-MdlAddress -Value $MdlAddress)"
}

function Install-PearlCli {
  param(
    [string]$Destination,
    [string]$Tag
  )

  $destinationFull = Resolve-FullPath $Destination
  $prlctl = Get-ChildItem -LiteralPath $destinationFull -Recurse -Filter "prlctl.exe" -ErrorAction SilentlyContinue |
    Select-Object -First 1 -ExpandProperty FullName

  if ($prlctl -and (Test-Path -LiteralPath $prlctl)) {
    Write-Info "CLI уже установлен / CLI is already installed: $prlctl"
    return $prlctl
  }

  Write-Info "Скачиваю Pearl CLI из релиза $Tag... / Downloading Pearl CLI from release $Tag..."
  New-Item -ItemType Directory -Force -Path $destinationFull | Out-Null

  $releaseUrl = "https://api.github.com/repos/pearl-research-labs/pearl/releases/tags/$Tag"
  $release = Invoke-RestMethod -Uri $releaseUrl -Headers @{ "User-Agent" = "PearlMdlSigner" }
  $zipAsset = $release.assets | Where-Object { $_.name -eq "go-binaries-windows-amd64-2.0.0.zip" } | Select-Object -First 1
  $sumAsset = $release.assets | Where-Object { $_.name -eq "checksums.txt" } | Select-Object -First 1

  if (-not $zipAsset -or -not $sumAsset) {
    throw "В релизе $Tag не найдены нужные ассеты CLI. / Required CLI assets were not found in release $Tag."
  }

  $zipPath = Join-Path $destinationFull $zipAsset.name
  $sumPath = Join-Path $destinationFull $sumAsset.name

  Invoke-WebRequest -Uri $zipAsset.browser_download_url -OutFile $zipPath -Headers @{ "User-Agent" = "PearlMdlSigner" }
  Invoke-WebRequest -Uri $sumAsset.browser_download_url -OutFile $sumPath -Headers @{ "User-Agent" = "PearlMdlSigner" }

  $expectedLine = Get-Content -LiteralPath $sumPath | Where-Object { $_ -match [regex]::Escape($zipAsset.name) } | Select-Object -First 1
  if (-not $expectedLine) {
    throw "В checksums.txt не найден хеш для $($zipAsset.name). / Hash for $($zipAsset.name) was not found in checksums.txt."
  }

  $expected = ($expectedLine -split "\s+")[0].ToUpperInvariant()
  $actual = (Get-FileHash -Algorithm SHA256 -LiteralPath $zipPath).Hash.ToUpperInvariant()
  if ($expected -ne $actual) {
    throw "SHA256 архива CLI не совпал. Ожидалось $expected, получено $actual. / CLI archive SHA256 mismatch. Expected $expected, got $actual."
  }

  $extractDir = Join-Path $destinationFull "go-binaries-windows-amd64-2.0.0"
  New-Item -ItemType Directory -Force -Path $extractDir | Out-Null
  Expand-Archive -LiteralPath $zipPath -DestinationPath $extractDir -Force

  $prlctl = Join-Path $extractDir "prlctl.exe"
  if (-not (Test-Path -LiteralPath $prlctl)) {
    throw "После распаковки не найден prlctl.exe. / prlctl.exe was not found after extraction."
  }

  Write-Info "CLI установлен / CLI installed: $prlctl"
  return $prlctl
}

function Add-ProcessCommandLineReader {
  $typeName = "PearlProcessCommandLineReader"
  $existingType = ([System.Management.Automation.PSTypeName]$typeName).Type
  if ($existingType) {
    return
  }

  $code = @"
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;

public static class PearlProcessCommandLineReader {
  [DllImport("ntdll.dll")]
  static extern int NtQueryInformationProcess(IntPtr ProcessHandle, int ProcessInformationClass, ref PROCESS_BASIC_INFORMATION ProcessInformation, int ProcessInformationLength, out int ReturnLength);

  [DllImport("kernel32.dll", SetLastError=true)]
  static extern bool ReadProcessMemory(IntPtr hProcess, IntPtr lpBaseAddress, byte[] lpBuffer, int dwSize, out IntPtr lpNumberOfBytesRead);

  [StructLayout(LayoutKind.Sequential)]
  struct PROCESS_BASIC_INFORMATION {
    public IntPtr Reserved1;
    public IntPtr PebBaseAddress;
    public IntPtr Reserved2_0;
    public IntPtr Reserved2_1;
    public IntPtr UniqueProcessId;
    public IntPtr Reserved3;
  }

  static IntPtr ReadIntPtr(IntPtr h, IntPtr addr) {
    byte[] b = new byte[IntPtr.Size];
    IntPtr read;
    if (!ReadProcessMemory(h, addr, b, b.Length, out read)) {
      throw new System.ComponentModel.Win32Exception(Marshal.GetLastWin32Error());
    }
    return IntPtr.Size == 8 ? (IntPtr)BitConverter.ToInt64(b, 0) : (IntPtr)BitConverter.ToInt32(b, 0);
  }

  static ushort ReadUInt16(IntPtr h, IntPtr addr) {
    byte[] b = new byte[2];
    IntPtr read;
    if (!ReadProcessMemory(h, addr, b, b.Length, out read)) {
      throw new System.ComponentModel.Win32Exception(Marshal.GetLastWin32Error());
    }
    return BitConverter.ToUInt16(b, 0);
  }

  public static string Get(int pid) {
    var p = Process.GetProcessById(pid);
    var h = p.Handle;
    var pbi = new PROCESS_BASIC_INFORMATION();
    int retLen;
    int status = NtQueryInformationProcess(h, 0, ref pbi, Marshal.SizeOf(typeof(PROCESS_BASIC_INFORMATION)), out retLen);
    if (status != 0) {
      throw new Exception("NtQueryInformationProcess status " + status);
    }

    int ppOffset = IntPtr.Size == 8 ? 0x20 : 0x10;
    IntPtr procParams = ReadIntPtr(h, pbi.PebBaseAddress + ppOffset);
    int cmdOffset = IntPtr.Size == 8 ? 0x70 : 0x40;
    ushort len = ReadUInt16(h, procParams + cmdOffset);
    IntPtr buf = ReadIntPtr(h, procParams + cmdOffset + (IntPtr.Size == 8 ? 0x08 : 0x04));

    byte[] bytes = new byte[len];
    IntPtr read;
    if (!ReadProcessMemory(h, buf, bytes, bytes.Length, out read)) {
      throw new System.ComponentModel.Win32Exception(Marshal.GetLastWin32Error());
    }
    return System.Text.Encoding.Unicode.GetString(bytes);
  }
}
"@

  Add-Type -TypeDefinition $code
}

function Get-OysterRpcCredentials {
  Add-ProcessCommandLineReader

  $process = Get-Process | Where-Object { $_.ProcessName -eq "oyster-windows-x64" -or $_.ProcessName -eq "oyster" } |
    Select-Object -First 1

  if (-not $process) {
    throw "Не найден запущенный процесс oyster. Откройте Pearl Wallet и нужный кошелек. / Running oyster process was not found. Open Pearl Wallet and select the required wallet."
  }

  try {
    $cmd = [PearlProcessCommandLineReader]::Get($process.Id)
  }
  catch {
    throw "Не удалось прочитать параметры процесса Pearl Wallet. Ответ Windows: $($_.Exception.Message). Если Pearl Wallet запущен от администратора, запустите start_MDL_sign.cmd тоже от администратора. Лучше запустить Pearl Wallet и скрипт с одинаковыми правами. / Failed to read Pearl Wallet process parameters. Windows response: $($_.Exception.Message). If Pearl Wallet is running as administrator, run start_MDL_sign.cmd as administrator too. It is best to run Pearl Wallet and the script with the same permissions."
  }
  $user = [regex]::Match($cmd, "--username=([^\s]+)").Groups[1].Value
  $pass = [regex]::Match($cmd, "--password=([^\s]+)").Groups[1].Value
  $listen = [regex]::Match($cmd, "--rpclisten=([^\s]+)").Groups[1].Value

  if (-not $user -or -not $pass) {
    throw "Не удалось получить временные RPC-учетные данные из процесса Pearl Wallet. / Failed to get temporary RPC credentials from the Pearl Wallet process."
  }

  if (-not $listen) {
    $listen = "127.0.0.1:8335"
  }

  return [PSCustomObject]@{
    User = $user
    Password = $pass
    Server = $listen
    ProcessId = $process.Id
  }
}

function Convert-SecureStringToPlainText {
  param([securestring]$Secure)
  $ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($Secure)
  try {
    return [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)
  }
  finally {
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr)
  }
}

function ConvertTo-ProcessArgument {
  param([string]$Value)

  if ($null -eq $Value) {
    return '""'
  }

  if ($Value -notmatch '[\s"]') {
    return $Value
  }

  return '"' + ($Value -replace '\\', '\\' -replace '"', '\"') + '"'
}

function Invoke-Prlctl {
  param(
    [string]$PrlctlPath,
    [object]$Rpc,
    [string[]]$CommandArgs,
    [string]$StdInText = $null
  )

  $baseArgs = @(
    "--wallet",
    "--rpcserver=$($Rpc.Server)",
    "--notls",
    "--rpcuser=$($Rpc.User)",
    "--rpcpass=$($Rpc.Password)"
  )

  $allArgs = @($baseArgs + $CommandArgs)
  $psi = New-Object System.Diagnostics.ProcessStartInfo
  $psi.FileName = $PrlctlPath
  $psi.UseShellExecute = $false
  $psi.RedirectStandardOutput = $true
  $psi.RedirectStandardError = $true
  $psi.RedirectStandardInput = ($null -ne $StdInText)
  $psi.CreateNoWindow = $true
  $psi.Arguments = (($allArgs | ForEach-Object { ConvertTo-ProcessArgument $_ }) -join " ")

  $process = New-Object System.Diagnostics.Process
  $process.StartInfo = $psi
  [void]$process.Start()

  if ($null -ne $StdInText) {
    $process.StandardInput.WriteLine($StdInText)
    $process.StandardInput.Close()
  }

  $stdout = $process.StandardOutput.ReadToEnd()
  $stderr = $process.StandardError.ReadToEnd()
  $process.WaitForExit()

  $outputLines = @()
  if ($stdout) {
    $outputLines += ($stdout -split "`r?`n")
  }
  if ($stderr) {
    $outputLines += ($stderr -split "`r?`n")
  }

  $filtered = @(
    $outputLines |
      Where-Object { $_ -and $_.Trim() } |
      Where-Object { $_ -notmatch "Error creating a default config file" }
  )

  return [PSCustomObject]@{
    ExitCode = $process.ExitCode
    Output = $filtered
  }
}

function Sign-MdlAddresses {
  param(
    [string]$PrlctlPath,
    [object]$Rpc,
    [string]$WalletPassword,
    [string]$MdlAddress,
    [string[]]$PrlAddresses
  )

  Write-Info "Разблокирую кошелек на 60 секунд... / Unlocking wallet for 60 seconds..."
  $unlock = Invoke-Prlctl -PrlctlPath $PrlctlPath -Rpc $Rpc -CommandArgs @("walletpassphrase", "-", "60") -StdInText $WalletPassword
  if ($unlock.ExitCode -ne 0) {
    throw "Не удалось разблокировать кошелек. Ответ: $($unlock.Output -join ' ') / Failed to unlock wallet. Response: $($unlock.Output -join ' ')"
  }

  $results = New-Object System.Collections.Generic.List[object]
  $message = Get-MdlSignMessage -MdlAddress $MdlAddress
  Write-Info "Будет подписано сообщение / Message that will be signed: $message"

  foreach ($address in $PrlAddresses) {
    Write-Info "Подписываю PRL-адрес / Signing PRL address: $address"
    $signed = Invoke-Prlctl -PrlctlPath $PrlctlPath -Rpc $Rpc -CommandArgs @("signmessage", $address, $message)

    if ($signed.ExitCode -eq 0) {
      $signature = ($signed.Output | Where-Object { $_.ToString().Trim() } | Select-Object -First 1).ToString().Trim()
      $results.Add([PSCustomObject]@{
        Address = $address
        Message = $message
        Signature = $signature
        Error = $null
      })
    }
    else {
      $results.Add([PSCustomObject]@{
        Address = $address
        Message = $message
        Signature = $null
        Error = ($signed.Output -join " ")
      })
    }
  }

  return $results.ToArray()
}

function Write-ResultFile {
  param(
    [string]$Path,
    [string]$MdlAddress,
    [object[]]$Results
  )

  $content = New-Object System.Collections.Generic.List[string]
  $content.Add("MDL-адрес / MDL address:")
  $content.Add($MdlAddress)
  $content.Add("")
  $content.Add("Сообщение для подписи / Message to sign:")
  $content.Add((Get-MdlSignMessage -MdlAddress $MdlAddress))
  $content.Add("")

  $index = 1
  foreach ($result in $Results) {
    $content.Add("$index. PRL-адрес / PRL address:")
    $content.Add($result.Address)
    $content.Add("")

    if ($result.Signature) {
      $content.Add("Подпись / Signature:")
      $content.Add($result.Signature)
    }
    else {
      $content.Add("Ошибка подписи / Signing error:")
      $content.Add($result.Error)
    }

    $content.Add("")
    $index++
  }

  Set-Content -LiteralPath $Path -Value $content -Encoding UTF8
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$inputPath = $InputFile
if (-not [System.IO.Path]::IsPathRooted($inputPath)) {
  $inputPath = Join-Path $scriptDir $inputPath
}

$input = $null
if (-not $MdlAddress -and -not $PrlAddress -and -not $OutputFile) {
  $input = Read-SignInput -Path $inputPath
  if ($input) {
    Write-Info "Адреса прочитаны из файла / Addresses loaded from file: $inputPath"
  }
}

if (-not $input) {
  $input = Read-InteractiveSignRequest -InitialMdlAddress $MdlAddress -InitialPrlAddresses $PrlAddress -InitialOutputFile $OutputFile
}

if (-not $input.OutputFile -or -not $input.OutputFile.Trim()) {
  $input.OutputFile = Get-DefaultOutputFileName -MdlAddress $input.MdlAddress -PrlAddresses $input.PrlAddresses
}

if ($CheckOnly) {
  Write-Info "MDL-адрес / MDL address: $($input.MdlAddress)"
  Write-Info "Сообщение для подписи / Message to sign: $(Get-MdlSignMessage -MdlAddress $input.MdlAddress)"
  Write-Info "PRL-адресов введено / PRL addresses entered: $($input.PrlAddresses.Count)"
  Write-Info "Итоговый файл будет создан / Output file will be created: $(Join-Path $scriptDir ([System.IO.Path]::GetFileName($input.OutputFile)))"
  Write-Info "Режим проверки завершен без подключения к Pearl Wallet. / Check mode finished without connecting to Pearl Wallet."
  Wait-BeforeExit
  return
}

$cliPath = Install-PearlCli -Destination (Join-Path $scriptDir $CliDir) -Tag $ReleaseTag
$rpc = Get-OysterRpcCredentials

Write-Info "Подключение к открытому Pearl Wallet / Connected to open Pearl Wallet: $($rpc.Server), процесс / process $($rpc.ProcessId)"

$securePassword = Read-Host "Введите пароль кошелька Pearl Wallet / Enter Pearl Wallet password" -AsSecureString
$plainPassword = Convert-SecureStringToPlainText -Secure $securePassword

try {
  $results = Sign-MdlAddresses -PrlctlPath $cliPath -Rpc $rpc -WalletPassword $plainPassword -MdlAddress $input.MdlAddress -PrlAddresses $input.PrlAddresses
}
finally {
  $plainPassword = $null
}

$outputName = [System.IO.Path]::GetFileName($input.OutputFile)
$outputPath = Join-Path $scriptDir $outputName

Write-ResultFile -Path $outputPath -MdlAddress $input.MdlAddress -Results $results
Write-Info "Готово. Итоговый файл / Done. Output file: $outputPath"

Write-Host ""
Write-Host "Содержимое файла / File contents:"
Write-Host "----------------"
Get-Content -LiteralPath $outputPath
Write-Host "----------------"

Wait-BeforeExit












