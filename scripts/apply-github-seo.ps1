# Applies GitHub SEO settings and creates releases.
# Requires: gh auth login

$ErrorActionPreference = "Continue"
$gh = Join-Path $env:TEMP "gh-cli\bin\gh.exe"
if (-not (Test-Path $gh)) {
  $ghCmd = Get-Command gh -ErrorAction SilentlyContinue
  if ($ghCmd) { $gh = $ghCmd.Source } else { throw "gh CLI not found" }
}

$repo = "meysamsahragard/ngx-promise-buttons"
$description = "Add loading spinners to Angular buttons from promises, RxJS subscriptions, or booleans. Standalone directive for Angular 9-22."
$homepage = "https://meysamsahragard.github.io/ngx-promise-buttons/"
$topics = @(
  "angular",
  "ngx",
  "typescript",
  "button",
  "loading",
  "spinner",
  "loading-button",
  "promise",
  "rxjs",
  "directive",
  "standalone-components",
  "async",
  "angular-directive"
)

Write-Host "Updating repo description, homepage, and enabling issues..."
& $gh api -X PATCH "repos/$repo" `
  -f "description=$description" `
  -f "homepage=$homepage" `
  -F "has_issues=true" `
  -F "has_projects=false" | Out-Null

Write-Host "Setting topics..."
$topicsJson = (@{ names = $topics } | ConvertTo-Json -Compress)
$topicsJson | & $gh api -X PUT "repos/$repo/topics" `
  -H "Accept: application/vnd.github.mercy-preview+json" `
  --input - | Out-Null

function Ensure-Release {
  param(
    [string]$Tag,
    [string]$Title,
    [string]$Body,
    [string]$Target
  )
  & $gh release view $Tag -R $repo 1>$null 2>$null
  if ($LASTEXITCODE -eq 0) {
    Write-Host "Release $Tag already exists, skipping."
    return
  }

  & $gh api "repos/$repo/git/ref/tags/$Tag" 1>$null 2>$null
  if ($LASTEXITCODE -ne 0) {
    if (-not $Target) {
      Write-Host "No target SHA for $Tag, skipping."
      return
    }
    Write-Host "Creating tag $Tag at $Target..."
    & $gh api -X POST "repos/$repo/git/refs" -f "ref=refs/tags/$Tag" -f "sha=$Target" 1>$null
  }

  Write-Host "Creating release $Tag..."
  $bodyFile = [System.IO.Path]::GetTempFileName()
  Set-Content -Path $bodyFile -Value $Body -Encoding utf8
  & $gh release create $Tag -R $repo --title $Title --notes-file $bodyFile
  Remove-Item $bodyFile -Force -ErrorAction SilentlyContinue
}

# Resolve SHAs for historical tags if present locally
$sha101 = (git rev-list -n 1 v1.0.1 2>$null)
$sha102 = (git rev-list -n 1 v1.0.2 2>$null)
$sha110 = (git rev-parse HEAD)

Ensure-Release -Tag "v1.0.0" -Title "v1.0.0" -Target $sha101 `
  -Body @"
Initial release of ngx-promise-buttons.

- Standalone PromiseBtnDirective and provideNgxPromiseButtons()
- Promise, RxJS subscription, and boolean support
- Maintained fork of angular2-promise-buttons for modern Angular

npm: https://www.npmjs.com/package/ngx-promise-buttons/v/1.0.0
"@

if ($sha101) {
  Ensure-Release -Tag "v1.0.1" -Title "v1.0.1" -Target $sha101 `
    -Body "Patch release. npm: https://www.npmjs.com/package/ngx-promise-buttons/v/1.0.1"
}

if ($sha102) {
  Ensure-Release -Tag "v1.0.2" -Title "v1.0.2" -Target $sha102 `
    -Body @"
### Fixed
- Added public-api.ts for correct library packaging

npm: https://www.npmjs.com/package/ngx-promise-buttons/v/1.0.2
"@
}

Ensure-Release -Tag "v1.1.0" -Title "v1.1.0" -Target $sha110 `
  -Body @"
### Changed
- Upgraded to Angular 22
- Updated build paths and tooling

npm: https://www.npmjs.com/package/ngx-promise-buttons/v/1.1.0
"@

Ensure-Release -Tag "v1.1.1" -Title "v1.1.1" -Target $sha110 `
  -Body @"
### Improved
- Package metadata and README for npm/GitHub discoverability
- Homepage, keywords, description, and repository links

npm: https://www.npmjs.com/package/ngx-promise-buttons/v/1.1.1
"@

Write-Host "GitHub SEO updates complete."
