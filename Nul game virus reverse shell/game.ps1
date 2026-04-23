
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "Infinite Parkour"
$form.Width = 800
$form.Height = 400
$form.BackColor = "Black"
$form.StartPosition = "CenterScreen"
$form.KeyPreview = $true

# Sol
$groundY = 310
$isGrounded = $false

# Physique
$velocity = 0
$gravity = 1.3
$jumpForce = -18

# Joueur
$player = New-Object System.Windows.Forms.Panel
$player.Size = New-Object System.Drawing.Size(30,30)
$player.BackColor = "Lime"
$player.Left = 100
$player.Top = $groundY - $player.Height

# Obstacles
$obstacles = New-Object System.Collections.ArrayList

# Score
$score = 0
$label = New-Object System.Windows.Forms.Label
$label.ForeColor = "White"
$label.Top = 10
$label.Left = 10
$label.Text = "Score: 0"

$form.Controls.Add($player)
$form.Controls.Add($label)

# Spawn obstacle
function Spawn-Obstacle {
    $obs = New-Object System.Windows.Forms.Panel
    $obs.Width = 25
    $obs.Height = (Get-Random -Minimum 40 -Maximum 80)
    $obs.BackColor = "Red"
    $obs.Left = 800
    $obs.Top = $groundY - $obs.Height

    $form.Controls.Add($obs)
    [void]$obstacles.Add($obs)
}

# INPUT
$form.Add_KeyDown({
    param($sender, $e)

if ($e.KeyCode -eq [System.Windows.Forms.Keys]::Space -and $player.Top -ge ($groundY - $player.Height - 5)) {
        $script:velocity = $jumpForce
        $script:isGrounded = $false
    }
})

# GAME LOOP
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 20

$timer.Add_Tick({

    # gravité
    $script:velocity += $gravity
    $player.Top += $script:velocity

    # sol
    if ($player.Top -ge ($groundY - $player.Height)) {
        $player.Top = $groundY - $player.Height
        $script:velocity = 0
        $script:isGrounded = $true
    }
    else {
        $script:isGrounded = $false
    }

    # vitesse dynamique
$speed = 6 + [math]::Floor($score / 10)
    # obstacles
    for ($i = $obstacles.Count - 1; $i -ge 0; $i--) {

        $obs = $obstacles[$i]
        $obs.Left -= $speed

        if ($player.Bounds.IntersectsWith($obs.Bounds)) {
            $timer.Stop()
            [System.Windows.Forms.MessageBox]::Show("GAME OVER`nScore: $score")
            $form.Close()
            return
        }

        if ($obs.Left -lt -40) {
            $form.Controls.Remove($obs)
            $obstacles.RemoveAt($i)
            $score++
        }
    }

    # spawn
if ((Get-Random -Maximum 30) -eq 0) {
        Spawn-Obstacle
    }

    $label.Text = "Score: $score"
})

$timer.Start()
$form.ShowDialog()