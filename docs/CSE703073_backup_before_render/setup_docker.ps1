# setup_docker.ps1 - Tu dong tao .env va docker-compose.yml, sau do khoi chay Docker Compose
$ErrorActionPreference = "Stop"

Write-Host "== [1/3] Dang tao tep .env chuẩn UTF-8 ==" -ForegroundColor Cyan
$envContent = @"
APP_NAME="DT-11 - Ban do so du lich am thuc"
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost:8080

DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=dulichso
DB_USERNAME=dulichso_app
DB_PASSWORD=MatKhauManhApp123!

BROADCAST_DRIVER=log
CACHE_DRIVER=file
FILESYSTEM_DISK=local
QUEUE_CONNECTION=sync
SESSION_DRIVER=database
SESSION_LIFETIME=120
SESSION_SECURE_COOKIE=false

PY_SERVICE_URL=http://python:8001
"@
[System.IO.File]::WriteAllText("$PWD\.env", $envContent, [System.Text.Encoding]::UTF8)
Write-Host " -> Da tao .env thanh cong." -ForegroundColor Green

Write-Host "== [2/3] Dang tao tep docker-compose.yml ==" -ForegroundColor Cyan
$composeContent = @"
version: '3.9'

services:
  app:
    image: php:8.3-fpm-alpine
    container_name: dulichso_app
    restart: unless-stopped
    working_dir: /var/www/html
    volumes:
      - .:/var/www/html
    env_file: .env
    depends_on:
      db:
        condition: service_healthy

  web:
    image: nginx:1.27-alpine
    container_name: dulichso_web
    ports:
      - "8080:80"
    volumes:
      - .:/var/www/html:ro
    depends_on:
      - app
    restart: unless-stopped

  db:
    image: mysql:8.0
    container_name: dulichso_db
    restart: unless-stopped
    environment:
      MYSQL_DATABASE: dulichso
      MYSQL_USER: dulichso_app
      MYSQL_PASSWORD: MatKhauManhApp123!
      MYSQL_ROOT_PASSWORD: RootPassword123!
    ports:
      - "3306:3306"
    volumes:
      - db_data:/var/lib/mysql
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 10s
      timeout: 5s
      retries: 10

  python:
    image: python:3.12-slim
    container_name: dulichso_python
    restart: unless-stopped
    working_dir: /app
    volumes:
      - ./python-service:/app
    ports:
      - "8001:8001"
    command: sh -c "pip install -r requirements.txt && uvicorn app.main:app --host 0.0.0.0 --port 8001"

volumes:
  db_data:
"@
[System.IO.File]::WriteAllText("$PWD\docker-compose.yml", $composeContent, [System.Text.Encoding]::UTF8)
Write-Host " -> Da tao docker-compose.yml thanh cong." -ForegroundColor Green

Write-Host "== [3/3] Khoi chay Docker Compose ==" -ForegroundColor Cyan
docker compose up -d --build

Write-Host "== SAN SANG! Dang sinh khoa va di tru CSDL ==" -ForegroundColor Green
docker compose exec app php artisan key:generate
docker compose exec app php artisan migrate --seed --force

Write-Host "== HOAN THANH! Kiem tra tai http://localhost:8080 ==" -ForegroundColor Green
