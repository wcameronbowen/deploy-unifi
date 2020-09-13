# download ubuntu iso

# Define user set variables
$siteID = Read-Host "site mneumonic: "
$vlan = Read-Host "vlan: "

# Define static variables
$sHostname = $env:computername;
$localvmdir = "d:\vm"
$remotevmdirstring = "d$\vm"
$ubuntuisosource = "http://cdimage.ubuntu.com/releases/18.04.4/release/ubuntu-18.04.4-server-amd64.iso"
$ubuntuisodest = "C:\iso\ubuntu-18.04.4-server-amd64.iso"

 if (-not (Test-Path -Path $ubuntuisodest -PathType Leaf)) {
    wget $ubuntuisosource -OutFile $ubuntuisodest
}

# Define the VMs
$systems = @(

    @{name = ("zcubnt-"+$siteID);
        hypervisor = $sHostname;
        replica = " ";
        localVMDir = $localvmdir;
        remoteVMDirString = $remotevmdirstring;
        procCount = "2";
        memory = 2GB;
        isoPath = $ubuntuisodest;
        vmSwitch = "Default";
        drive = @{
            0 = 30GB;
        }
    }
) 
# end vm definitions

# Build Env
foreach ($system in $systems) {

    # build vmdir strings
    $remoteVMDir = "\\" + $system.hypervisor + "\" + $system.remoteVMDirString + "\" + $system.name;
    $localVMDir = $system.localVMDir + "\" + $system.name;

    # reserve serveral items for later
    $vmName = $system.name;
    $hypervisorName = $system.hypervisor

    # build vhd string
    $vhd0 = $localVMDir + "\" + $system.name + ".0.vhdx"

    # Create the vm dir on the hypervisor
    New-Item -path $remoteVMDir -ItemType directory;

    # Create the vm
    New-VM -computer $system.hypervisor -Name $system.name -Generation 2 -MemoryStartupBytes $system.memory -NewVHDPath $vhd0 -NewVHDsizeBytes $system.drive.0 -Switchname $system.vmSwitch;

    # Add DVD drive w/ iso
    Add-VMDvdDrive -computer $system.hypervisor -VMName $system.name -Path $system.isoPath;

    # Set the number of processor cores
    SET-VMProcessor -computer $system.hypervisor -VMname $system.name -count $system.procCount;

    # Set the boot order
    $cdDrive = Get-VMDvdDrive -computer $system.hypervisor -vmname $system.name;
    $vhdDrive = Get-VMHardDiskDrive -computer $system.hypervisor -vmname $system.name;
    Set-VMFirmware -computer $system.hypervisor -VMName $system.name -BootOrder $cdDrive, $vhdDrive;
	
	# Disable secure boot
	Set-VMFirmware -VMName $system.name -EnableSecureBoot Off 
	
	# Set vlan
	Set-VMNetworkAdapterVlan -VMName $system.name -Access -VlanId $vlan
	
	# Start VM
	Start-VM -Name $system.name

} 
