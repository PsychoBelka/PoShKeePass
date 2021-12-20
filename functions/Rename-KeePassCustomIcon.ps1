function Rename-KeePassCustomIcon
{
    <#
        .SYNOPSIS
            Function to change name of KeePass Custom Icon.
        .DESCRIPTION
            This function changes name of KeePass Custom Icon to a name specified in NewName parameter.
            Note:
                *Changing the name does not change index of Custom Icon in KeePass Database, but KeePass UI will display Custom Icons with sorted A-Z.
        
        .PARAMETER KeePassCustomIcon
            Specify the Custom Icon Object you want to rename
            Note:
                *You can get Custom Icon Object by running Get-KeePassCustomIcon command
        .PARAMETER Index
            Specify the Index of the Custom Icon in KeePass Database you want to rename
        .PARAMETER Uuid
            Specify the Uuid ([KeePassLib.PwUuid]) of the Custom Icon in KeePass Database you want to rename
        .PARAMETER Name
            Specify the Name of the Custom Icon in KeePass Database you want to rename
        .PARAMETER NewName
            Specify the new Name for Custom Icon
        .PARAMETER DatabaseProfileName
            *This Parameter is required in order to access your KeePass database.
        .PARAMETER MasterKey
            Specify a SecureString MasterKey if necessary to authenticat a keepass databse.
            If not provided and the database requires one you will be prompted for it.
            This parameter was created with scripting in mind.
        .EXAMPLE
            Rename-KeePassCustomIcon -Index 0 -NewName 'Cool Icon'
            
            This example changes name of a Custom Icon located at index 0 in KeePass Database to 'Cool Icon'
        .EXAMPLE
            Rename-KeePassCustomIcon -Name 'Old Icon' -NewName 'Brand New Icon'
            
            This example changes name of a Custom Icon with name 'Old Icon' to 'Brand New Icon'
        .INPUTS
            String
        .OUTPUTS
            $null
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ParameterSetName = 'KeePassCustomIcon')]
        [ValidateNotNullOrEmpty()]
        [PSObject]$KeePassCustomIcon,

        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ParameterSetName = 'Index')]
        [ValidateNotNullOrEmpty()]
        [Nullable[Int]]$Index,

        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ParameterSetName = 'Uuid')]
        [ValidateNotNullOrEmpty()]
        [KeePassLib.PwUuid]$Uuid,

        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ParameterSetName = 'Name')]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$NewName,

        [Parameter(Position = 2, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$DatabaseProfileName,

        [Parameter(Position = 3)]
        [ValidateNotNullOrEmpty()]
        [PSobject]$MasterKey,

        [Parameter(Position = 4)]
        [Switch]$PassThru
    )
    process
    {
        $KeePassConnectionObject = New-KPConnection -DatabaseProfileName $DatabaseProfileName -MasterKey $MasterKey
        Remove-Variable -Name MasterKey -ea 0

        switch($PSCmdlet.ParameterSetName){
            'KeePassCustomIcon' {$KPCustomIcon = Get-KPCustomIcon -Uuid $KeePassCustomIcon.Uuid -KeePassConnection $KeePassConnectionObject}
            'Index' {$KPCustomIcon = Get-KPCustomIcon -Index $Index -KeePassConnection $KeePassConnectionObject}
            'Uuid' {$KPCustomIcon = Get-KPCustomIcon -Uuid $Uuid -KeePassConnection $KeePassConnectionObject}
            'Name' {$KPCustomIcon = Get-KPCustomIcon -Name $Name -KeePassConnection $KeePassConnectionObject}
        }

        if(Test-KPConnection $KeePassConnectionObject){
            $KPCustomIcon.Name = $NewName
            $KPCustomIcon.LastModificationTime = [DateTime]::UtcNow
            $KeePassConnectionObject.Save($null)
        }

        if($PassThru){
            $KPCustomIcon
        }
    }
    end
    {
        Remove-KPConnection -KeePassConnection $KeePassConnectionObject
    }
}
