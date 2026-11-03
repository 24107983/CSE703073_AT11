# tools/doctor.ps1 — kiểm chứng môi trường trên Windows

$checks = @(
    @{ n = "git";      c = "git --version";      r = "Git >= 2.40" },
    @{ n = "php";      c = "php -v";            r = "PHP >= 8.2" },
    @{ n = "composer"; c = "composer --version"; r = "Composer >= 2.7" },
    @{ n = "mysql";    c = "mysql --version";    r = "MySQL >= 8.0" },
    @{ n = "node";     c = "node -v";            r = "Node >= 20" },
    @{ n = "python";   c = "python --version";   r = "Python >= 3.11" },
    @{ n = "docker";   c = "docker --version";   r = "Docker >= 24" }
)

Write-Host "== Kiểm chứng môi trường CSE703073 =="

foreach ($k in $checks) {
    $exe = $k.c.Split(" ")[0]

    if (Get-Command $exe -ErrorAction SilentlyContinue) {
        $v = (Invoke-Expression $k.c 2>&1 | Select-Object -First 1)
        Write-Host (" [OK] {0,-10} {1}" -f $k.n, $v)
    }
    else {
        Write-Host (" [THIẾU] {0,-10} cần: {1}" -f $k.n, $k.r) -ForegroundColor Yellow
    }
}

"pdo_mysql","mbstring","openssl","fileinfo","curl","zip","intl","gd" | ForEach-Object {
    if ((php -m) -contains $_) {
        Write-Host " [OK] $_"
    }
    else {
        Write-Host " [THIẾU] $_ — bật trong php.ini" -ForegroundColor Yellow
    }
}

Write-Host (" user.email: {0}" -f (git config user.email))
