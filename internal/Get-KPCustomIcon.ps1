function Get-KPCustomIcon
{
    <#
        .SYNOPSIS
            This function will lookup and Return KeePass one or more KeePass Custom Icons.
        .DESCRIPTION
            This function will lookup Return KeePass Entry(ies). It supports basic lookup filtering.
        .EXAMPLE

        .PARAMETER KeePassConnection
            This is the Open KeePass Database Connection
        .PARAMETER Index
            This is a Index of one or more KeePass CustomIcons.
        .PARAMETER Uuid
            This is a Uuid of one or more KeePass Entries.
        .PARAMETER Name
            This is the Name of one or more KeePass Entries.
    #>
    [CmdletBinding(DefaultParameterSetName = 'None')]
    [OutputType('KeePassLib.PwCustomIcon')]
    param
    (
        [Parameter(Position = 0, Mandatory, ParameterSetName = 'None')]
        [Parameter(Position = 0, Mandatory, ParameterSetName = 'Index')]
        [Parameter(Position = 0, Mandatory, ParameterSetName = 'Uuid')]
        [Parameter(Position = 0, Mandatory, ParameterSetName = 'Name')]
        [ValidateNotNullOrEmpty()]
        [KeePassLib.PwDatabase]$KeePassConnection,

        [Parameter(Position = 1, Mandatory, ParameterSetName = 'Index')]
        [ValidateNotNullOrEmpty()]
        [Nullable[Int]]$Index,

        [Parameter(Position = 1, Mandatory, ParameterSetName = 'Uuid', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [KeePassLib.PwUuid]$KeePassUuid,

        [Parameter(Position = 1, Mandatory, ParameterSetName = 'Name')]
        [ValidateNotNullOrEmpty()]
        [String]$Name
    )
    process
    {
        if(Test-KPConnection $KeePassConnection){
            $KeePassItems = $KeePassConnection.CustomIcons

            Switch($PSCmdlet.ParameterSetName){
                #Returns all icons
                'None' {Return $KeePassItems}
                #Returns icon by Index
                'Index' {
                    Return $KeePassItems = foreach($_keepassItem in $KeePassItems){
                        if($KeePassItems.IndexOf($_keepassItem) -eq $Index){
                            $_keepassItem
                        }
                    }
                }
                #Returns icon by Uuid
                'Uuid' {Return $KeePassItems | Where-Object { $KeePassUuid.CompareTo($_.Uuid) -eq 0 }}
                #Returns icon by Name
                'Name' {
                    Return $KeePassItems = foreach($_keepassItem in $KeePassItems){
                        if($_keepassItem.Name.ToLower().Equals($Name.ToLower())){
                            $_keepassItem
                        }
                    }
                }
            }
        }
    }
}