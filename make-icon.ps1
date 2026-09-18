Add-Type -AssemblyName System.Drawing

$size = 512
$bmp = New-Object System.Drawing.Bitmap($size, $size)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

# Background - deep navy
$bg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 7, 26, 38))
$g.FillRectangle($bg, 0, 0, $size, $size)

# Colours
$sand   = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 217, 178, 106))
$cream  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 242, 234, 217))
$dune   = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 122, 155, 94))

# --- Rolling dune silhouette across the bottom ---
$dunePts = [System.Drawing.PointF[]]@(
    [System.Drawing.PointF]::new(0, 512),
    [System.Drawing.PointF]::new(0, 380),
    [System.Drawing.PointF]::new(90, 340),
    [System.Drawing.PointF]::new(180, 375),
    [System.Drawing.PointF]::new(270, 320),
    [System.Drawing.PointF]::new(360, 365),
    [System.Drawing.PointF]::new(440, 330),
    [System.Drawing.PointF]::new(512, 360),
    [System.Drawing.PointF]::new(512, 512)
)
$dunePath = New-Object System.Drawing.Drawing2D.GraphicsPath
$dunePath.AddPolygon($dunePts)
$g.FillPath($dune, $dunePath)

# --- Flagpole ---
$polePen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 242, 234, 217), 12)
$g.DrawLine($polePen, 270, 375, 270, 110)

# --- Flag (triangle) ---
$flagPts = [System.Drawing.PointF[]]@(
    [System.Drawing.PointF]::new(276, 118),
    [System.Drawing.PointF]::new(400, 155),
    [System.Drawing.PointF]::new(276, 192)
)
$flagPath = New-Object System.Drawing.Drawing2D.GraphicsPath
$flagPath.AddPolygon($flagPts)
$g.FillPath($sand, $flagPath)

# --- Golf ball ---
$g.FillEllipse($cream, 190, 400, 46, 46)

$g.Dispose()

$outDir = "C:\Users\Mick\Documents\Claude\Projects\Barnbougle 2026"

$bmp.Save("$outDir\apple-touch-icon.png", [System.Drawing.Imaging.ImageFormat]::Png)

$a192 = New-Object System.Drawing.Bitmap($bmp, [System.Drawing.Size]::new(192, 192))
$a192.Save("$outDir\icon-192.png", [System.Drawing.Imaging.ImageFormat]::Png)
$a192.Dispose()

$fav = New-Object System.Drawing.Bitmap($bmp, [System.Drawing.Size]::new(32, 32))
$fav.Save("$outDir\favicon.png", [System.Drawing.Imaging.ImageFormat]::Png)
$fav.Dispose()

$bmp.Dispose()
Write-Host "Icons generated."
