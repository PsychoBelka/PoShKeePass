function New-KeePassGroup
{
    <#
        .SYNOPSIS
            Function to create a new KeePass Database Entry.
        .DESCRIPTION
            This function allows for the creation of KeePass Database Entries with basic properites available for specification.
        .PARAMETER KeePassParentGroupPath
            Specify this parameter if you wish to only return entries form a specific folder path.
            Notes:
                * Path Separator is the foward slash character '/'
        .PARAMETER DatabaseProfileName
            *This Parameter is required in order to access your KeePass database.
        .PARAMETER KeePassGroupName
            Specify the Name of the new KeePass Group.
        .PARAMETER PassThru
            Specify to return the new group object.
        .PARAMETER MasterKey
            Specify a SecureString MasterKey if necessary to authenticat a keepass databse.
            If not provided and the database requires one you will be prompted for it.
            This parameter was created with scripting in mind.
        .PARAMETER IconName
            Specify the Name of the Icon for the Group to display in the KeePass UI.
        .PARAMETER CustomIconUuid
            Specify the Uuid ([KeePassLib.PwUuid]) of the Custom Icon stored in database for the Group to display in the KeePass UI.
            Custom icon have priority when choosing what icon to display, meaning if CustomIconUuid is set, it will be displayed in KeePass UI regardless of IconName value
        .PARAMETER Notes
            Specify group notes
        .PARAMETER Expires
            Specify if you want the KeePass Object to Expire, default is to not expire.
        .PARAMETER ExpiryTime
            Datetime expiration Time value.
        .EXAMPLE
            PS> New-KeePassGroup -DatabaseProfileName TEST -KeePassParentGroupPath 'General/TestAccounts' -KeePassGroupName 'TestGroup'

            This Example Creates a Group Called 'TestGroup' in the Group Path 'General/TestAccounts'
        .INPUTS
            Strings
        .OUTPUTS
            $null
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Position = 0, Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('FullPath')]
        [String] $KeePassGroupParentPath,

        [Parameter(Position = 1, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String] $KeePassGroupName,

        [Parameter(Position = 2)]
        [ValidateNotNullOrEmpty()]
        [string] $IconName = 'Folder',

        [Parameter(Position = 3)]
        [ValidateNotNullOrEmpty()]
        [KeePassLib.PwUuid] $CustomIconUuid = [KeePassLib.PwUuid]::Zero,

        [Parameter(Position = 4)]
        [ValidateNotNullOrEmpty()]
        [String] $Notes,

        [Parameter(Position = 5)]
        [switch] $Expires,

        [Parameter(Position = 6)]
        [DateTime] $ExpiryTime,

        [Parameter(Position = 7, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string] $DatabaseProfileName,

        [Parameter(Position = 8)]
        [ValidateNotNullOrEmpty()]
        [PSobject] $MasterKey,

        [Parameter(Position = 9)]
        [Switch] $PassThru
    )
    begin
    {
    }
    process
    {
        $KeePassConnectionObject = New-KPConnection -DatabaseProfileName $DatabaseProfileName -MasterKey $MasterKey
        Remove-Variable -Name MasterKey -ea 0

        $KeePassParentGroup = Get-KpGroup -KeePassConnection $KeePassConnectionObject -FullPath $KeePassGroupParentPath -Stop

        $addKPGroupSplat = @{
            KeePassConnection  = $KeePassConnectionObject
            GroupName          = $KeePassGroupName
            IconName           = $IconName
            CustomIconUuid     = $CustomIconUuid
            PassThru           = $PassThru
            KeePassParentGroup = $KeePassParentGroup
            Notes              = $Notes
        }

        # if($Notes){ $addKPGroupSplat.Notes = $Notes }
        if(Test-Bound -ParameterName 'Expires'){ $addKPGroupSplat.Expires = $Expires }
        if($ExpiryTime){ $addKPGroupSplat.ExpiryTime = $ExpiryTime }

        Add-KPGroup @addKPGroupSplat | ConvertTo-KpPsObject -DatabaseProfileName $DatabaseProfileName
    }
    end
    {
        Remove-KPConnection -KeePassConnection $KeePassConnectionObject
    }
}
