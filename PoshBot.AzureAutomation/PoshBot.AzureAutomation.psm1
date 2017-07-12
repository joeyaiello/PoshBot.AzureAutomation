<#
function Set-AzureRmCredential { 
    [PoshBot.BotCommand(
        CommandName = 'set-azurecred'
    )]
    [cmdletbinding()]
    param(
        [parameter(Mandatory)]
        [string]$ServicePrincipal
    )

    $context = $global:PoshBotContext
    $user = $context.From
    $state = Get-PoshBotStatefulData -Name Credential -ValueOnly

    if (-not $state) {
        $state = @{
            $user = $ServicePrincipal
        }
    } else {
        $state.$user = $ServicePrincipal
    }

    $state | Set-PoshBotStatefulData -Name Credential

    New-PoshBotCardResponse -Type Normal -Text 'Credentials saved.'
}
#>

function Get-DscNodeStatus {
    <#
    .SYNOPSIS
        Get the status of a DSC node in Azure Automation
    .EXAMPLE
        !dscstatus -resourcegroup foo -automationaccount bar -name baz
    #>
    [PoshBot.BotCommand(CommandName = 'dscstatus')]
    [cmdletbinding(DefaultParameterSetName = 'Name')]
    param(
        [parameter(Mandatory, Position = 0)]
        [string]$ResourceGroup,

        [parameter(Mandatory, Position = 1, ParameterSetName = 'All')]
        [string]$AutomationAccount,

        [parameter(Position = 2, ParameterSetName = 'Name')]
        #[Alias('Count')]
        [string]$Name
    )

    Import-Module AzureBot
    Invoke-ChatBotLogin
<#
    $context = $global:PoshBotContext
    $state = Get-PoshBotStatefulData -ValueOnly -Name Credential
    $user = $context.From
    $spn = $state.$user

    if (-not $spn) {
        New-PoshBotCardResponse -Type Warning -Text 'Your credentials are not stored. Please DM me with [set-azurecred] to save your credentials.'
    }
    else {
        Login-AzureRmContext -ServicePrincipal $spn
    }
#>

    if ($PSCmdlet.ParameterSetName -eq 'All') {
        $status = Get-AzureRmAutomationDscNode -ResourceGroupName $ResourceGroup -AutomationAccountName $AutomationAccount
        Write-Output $status
    }
    elseif ($PSCmdlet.ParameterSetName -eq 'Name') {
        $status = Get-AzureRmAutomationDscNode -ResourceGroupName $ResourceGroup -AutomationAccountName $AutomationAccount -Name $Name
        Write-Output $status
    }
    else {
        Write-Output 'Something went wrong'
    }
}

Export-ModuleMember -Function Get-DscNodeStatus
