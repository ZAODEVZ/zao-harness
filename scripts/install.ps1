# Copies the ZAO rules and skills into the current repo. Never overwrites.
$H = Split-Path -Parent $PSScriptRoot
foreach ($f in 'CLAUDE.md', 'AGENTS.md') { if (Test-Path $f) { "kept your $f" } else { Copy-Item "$H\$f" $f } }
New-Item -ItemType Directory -Force .claude\skills | Out-Null
Get-ChildItem "$H\.claude\skills" -Directory | ForEach-Object {
  if (Test-Path ".claude\skills\$($_.Name)") { "kept skill $($_.Name)" } else { Copy-Item $_.FullName ".claude\skills\$($_.Name)" -Recurse }
}
"ZAO harness installed"
