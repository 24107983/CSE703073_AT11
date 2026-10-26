<?php
require __DIR__ . '/vendor/autoload.php';
$app = require_once __DIR__ . '/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

$file = '/var/www/html/database/seed_clean.sql';
$sql = file_get_contents($file);
$statements = explode(';', $sql);
$errors = [];
$checked = 0;

foreach ($statements as $statement) {
    if (!preg_match('/INSERT\s+INTO\s+`?([a-zA-Z0-9_]+)`?\s*\((.*?)\)\s*VALUES/is', $statement, $m)) {
        continue;
    }

    $table = $m[1];
    preg_match_all('/`([a-zA-Z0-9_]+)`/', $m[2], $matches);
    $columns = $matches[1];

    if (!$columns) {
        preg_match_all('/(?:^|,)\s*([a-zA-Z0-9_]+)\s*(?=,|$)/', $m[2], $matches);
        $columns = $matches[1];
    }

    $existing = Illuminate\Support\Facades\Schema::getColumnListing($table);
    $missing = array_diff($columns, $existing);
    $checked++;

    if ($missing) {
        $errors[] = "$table: cot khong ton tai: " . implode(', ', $missing);
    }
}

echo "So lenh INSERT da kiem tra: $checked\n";

if ($errors) {
    echo "PHAT HIEN COT KHONG KHOP:\n" . implode("\n", $errors) . "\n";
    exit(1);
}

echo "Khong phat hien cot INSERT khong ton tai.\n";
