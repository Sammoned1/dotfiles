clear

Invoke-Expression (&starship init powershell)

Set-PSReadlineOption -Color @{
    "Command" = [ConsoleColor]::Green
    "Parameter" = [ConsoleColor]::Gray
    "Operator" = [ConsoleColor]::Magenta
    "Variable" = [ConsoleColor]::White
    "String" = [ConsoleColor]::Yellow
    "Number" = [ConsoleColor]::Blue
    "Type" = [ConsoleColor]::Cyan
    "Comment" = [ConsoleColor]::DarkCyan
}
# # Dracula Prompt Configuration
# Import-Module posh-git
# $GitPromptSettings.DefaultPromptPrefix.Text = "$([char]0x2192) " # arrow unicode symbol
# $GitPromptSettings.DefaultPromptPrefix.ForegroundColor = [ConsoleColor]::Green
# $GitPromptSettings.DefaultPromptPath.ForegroundColor =[ConsoleColor]::Cyan
# $GitPromptSettings.DefaultPromptSuffix.Text = "$([char]0x203A) " # chevron unicode symbol
# $GitPromptSettings.DefaultPromptSuffix.ForegroundColor = [ConsoleColor]::Magenta
# # Dracula Git Status Configuration
# $GitPromptSettings.BeforeStatus.ForegroundColor = [ConsoleColor]::Blue
# $GitPromptSettings.BranchColor.ForegroundColor = [ConsoleColor]::Blue
# $GitPromptSettings.AfterStatus.ForegroundColor = [ConsoleColor]::Blue

function ndev {
    $path = $env:Path
    $path = $path.Replace("C:\Program Files\nodejs","C:\Users\mrtem\Desktop\system\nodejs")
    $env:Path = $path
    nvim
}

function svkr {
    $serverPaneId = wezterm cli split-pane powershell.exe cross-env NODE_ENV=development nodemon app.js
    $clientPaneId = wezterm cli split-pane --pane-id $serverPaneId --right powershell.exe 
    wezterm cli send-text --pane-id $clientPaneId 'z client ; npm run clean ; node scripts/start.js'

}

function work {
    $Dir = fd . "$( $HOME )\Desktop\work" --type d --exclude .git -d 2 | fzf --cycle --preview "exa --tree --git-ignore --ignore-glob node_modules -D --color=always {}"
    if (![string]::IsNullOrEmpty($Dir)) {
        z $Dir
    }
}

$prompt = ""
function Invoke-Starship-PreCommand {
    $current_location = $executionContext.SessionState.Path.CurrentLocation
    if ($current_location.Provider.Name -eq "FileSystem") {
        $ansi_escape = [char]27
        $provider_path = $current_location.ProviderPath -replace "\\", "/"
        $prompt = "$ansi_escape]7;file://${env:COMPUTERNAME}/${provider_path}$ansi_escape\"
    }
    $host.ui.Write($prompt)
}

Invoke-Expression (& { (zoxide init powershell | Out-String) })
