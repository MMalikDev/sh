# Powershell
function k { 
    cd $HOME\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine
    copy ConsoleHost_history.bk ConsoleHost_history.txt 
    cd $HOME
    exit 0
}

function dns { ipconfig /flushdns ; ipconfig /displaydns }
function ls_path { $Env:PATH -split (';') | sort }
function ag { cat $PROFILE | findstr func | sort }
function wifi { netsh wlan show profile }
function cuda { nvidia-smi }

# WSL
function kwsl { 
    wsl --shutdown
    wsl  -l -v
}
function debian_reset { 
    wsl --unregister Debian
    wsl --install Debian
    wsl -s Debian
}
function setup_bash { 
    cd $HOME
    wsl -e bash sh/setup/bash/wsl/sync.sh
}

# Code
function code { code.cmd --profile VSCode }
function data_code { start "$Env:USERPROFILE\AppData\Roaming\Code\User" }

# Codium
function codium { codium.cmd --profile VSCodium }
function data_codium { start "$Env:USERPROFILE\AppData\Roaming\VSCodium\User" }

# Admin
function health {
    DISM /Online /Cleanup-Image /RestoreHealth
    DISM /Online /Cleanup-Image /CheckHealth
    DISM /Online /Cleanup-Image /ScanHealth
    sfc /scannow
}
