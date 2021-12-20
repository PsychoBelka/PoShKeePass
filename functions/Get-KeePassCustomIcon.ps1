function Get-KeePassCustomIcon{
    <#
        .SYNOPSIS
            Function to get custom icons stored in KeePass database.
        .DESCRIPTION
            This Function gets all custom icons stored in KeePass database
        .PARAMETER Index
            Specify this parameter if you wish to only return custom icon with specific index
            Note:
                *Index is shown as name in KeePass UI by default
        .PARAMETER Uuid
            Specify this parameter if you wish to only return custom icon with specific uuid ([KeePassLib.PwUuid])
        .PARAMETER Name
            Specify this parameter if you wish to only return custom icon with specific name
            Note: 
                *By default custom icons have no name assigned to them
        .PARAMETER DatabaseProfileName
            *This Parameter is required in order to access your KeePass database.
        .PARAMETER MasterKey
            Specify a SecureString MasterKey if necessary to authenticate a keepass database.
            If not provided and the database requires one you will be prompted for it.
            This parameter was created with scripting in mind.
        .EXAMPLE

        .INPUTS
            Int
            KeepassLib.PwUuid
            String
        .OUTPUTS
            PSObject
    #>
    [CmdletBinding(DefaultParameterSetName = '__None')]
    param
    (
        [Parameter(Position = 0, ValueFromPipelineByPropertyName, ParameterSetName = 'Index')]
        [ValidateNotNullOrEmpty()]
        [Nullable[Int]]$Index,

        [Parameter(Position = 0, ValueFromPipelineByPropertyName, ParameterSetName = 'Uuid')]
        [ValidateNotNullOrEmpty()]
        [KeePassLib.PwUuid]$Uuid,

        [Parameter(Position = 0, ValueFromPipelineByPropertyName, ParameterSetName = 'Name')]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [Parameter(Position = 1, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$DatabaseProfileName,

        [Parameter(Position = 2)]
        [ValidateNotNullOrEmpty()]
        [PSobject]$MasterKey
    )
    process{
        $KeePassConnectionObject = New-KPConnection -DatabaseProfileName $DatabaseProfileName -MasterKey $MasterKey
        Remove-Variable -Name MasterKey -ea 0

        [hashtable] $getKpCustomIconSplat = @{
            'KeePassConnection' = $KeePassConnectionObject;
        }
        Switch($PSCmdlet.ParameterSetName){
            'Index' {$getKpCustomIconSplat.Index = $Index}
            'Uuid' {$getKpCustomIconSplat.Uuid = $Uuid}
            'Name' {$getKpCustomIconSplat.Name = $Name}
        }

        Get-KPCustomIcon @getKpCustomIconSplat | ConvertTo-KPPSObject -DatabaseProfileName $DatabaseProfileName
    }
    end
    {
        Remove-KPConnection -KeePassConnection $KeePassConnectionObject
    }
}