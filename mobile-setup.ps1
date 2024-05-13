function ADBdevice {
    adb.exe devices
}

# function ADBconnect {
#     adb.exe connect 127.0.0.1:5037
# }

function RooToCert {
    adb.exe shell "su -c '/data/local/tmp/cert-it.sh'"
}

function SpawnFrida {
    adb.exe shell "su -c '/data/local/tmp/frida-server.1-android-x86_64'"
}

$app = $args[0]
function RootBypass {
    param(
        [string]$app
    )
    $app_identifier=(frida-ps -Uai | awk '{print $NF}' | Select-String $app)
    #Write-Output $app_identifier
    frida -U -f $app_identifier -l C:\Users\geraldo.filho\Documents\Mobile-Stuff\fridantiroot.js
}

function SSLpinning {
    frida -U -F -l C:\Users\geraldo.filho\Documents\Mobile-Stuff\frida-multiple-unpinning.js  
}



Write-Output "Checking adb connectivity"
Start-Job -ScriptBlock ${function:ADBdevice} | Out-Null

# Start-Sleep -Seconds 5
# Write-Output "Connecting to device"
# Start-Job -ScriptBlock ${function:ADBconnect} | Out-Null

Start-Sleep -Seconds 5
Write-Output "Adding cert to system in 5s"
Start-Job -ScriptBlock ${function:RooToCert} | Out-Null

Write-Output "Initializing frida server in 5s"
Start-Sleep -Seconds 5
Start-Job -ScriptBlock ${function:SpawnFrida} | Out-Null

Write-Output "Bypassing root detection in 5s"
Start-Sleep -Seconds 5
Start-Job -ScriptBlock ${function:RootBypass} -ArgumentList $app

Write-Output "Bypassing SSL-pinning in 5s"
Start-Sleep -Seconds 5
Start-Job -ScriptBlock ${function:SSLpinning} | Out-Null

#$app_identifier=(frida-ps -Uai | Select-String "Aya" | awk '{print $4}')

#Bash part to add inside the android
# su -c 'mkdir -m 700 /data/holdit'
# su -c 'cp /system/etc/security/cacerts/* /data/holdit'
# su -c 'mount -t tmpfs tmpfs /system/etc/security/cacerts'
# su -c 'mv /data/holdit/* /system/etc/security/cacerts/'
# su -c 'cp /sdcard/9a5ba575.0 /system/etc/security/cacerts/'
# su -c 'chown root:root /system/etc/security/cacerts/*'
# su -c 'chmod 644 /system/etc/security/cacerts/*'
# su -c 'chcon u:object_r:system_file:s0 /system/etc/security/cacerts/*'

