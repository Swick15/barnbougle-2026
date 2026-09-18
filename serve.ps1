$root = $PSScriptRoot
$port = if ($env:PORT) { $env:PORT } else { '8091' }
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()
Write-Host "Serving Barnbougle 2026 site at http://localhost:$port"

$mimeTypes = @{
  '.html' = 'text/html; charset=utf-8'
  '.css'  = 'text/css'
  '.js'   = 'application/javascript'
  '.jpg'  = 'image/jpeg'
  '.jpeg' = 'image/jpeg'
  '.png'  = 'image/png'
  '.gif'  = 'image/gif'
  '.mp3'  = 'audio/mpeg'
  '.m4a'  = 'audio/mp4'
  '.json' = 'application/json'
}

while ($listener.IsListening) {
  $ctx  = $listener.GetContext()
  $req  = $ctx.Request
  $res  = $ctx.Response
  $local = [System.Uri]::UnescapeDataString($req.Url.LocalPath).TrimStart('/').Replace('/', '\')
  $path = Join-Path $root $local
  if ($local -eq '' -or $local -eq '\') { $path = Join-Path $root 'index.html' }

  if (Test-Path $path -PathType Leaf) {
    $bytes = [IO.File]::ReadAllBytes($path)
    $ext   = [IO.Path]::GetExtension($path).ToLower()
    $res.ContentType     = if ($mimeTypes[$ext]) { $mimeTypes[$ext] } else { 'application/octet-stream' }
    $res.ContentLength64 = $bytes.Length
    $res.OutputStream.Write($bytes, 0, $bytes.Length)
  } else {
    $res.StatusCode = 404
  }
  $res.OutputStream.Close()
}
