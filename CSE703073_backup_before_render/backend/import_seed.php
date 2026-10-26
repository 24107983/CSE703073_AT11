
<?php

require __DIR__ . '/vendor/autoload.php';

$app = require_once __DIR__ . '/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use Illuminate\Support\Facades\DB;

/**
 * NHAP DU LIEU SEED AN TOAN
 * - Chi cho phep INSERT.
 * - Yeu cau dung 21 lenh INSERT.
 * - Kiem tra database va bang dich dang rong.
 * - Loai bo dong trung khoa ket hop o cac bang lien ket da xac dinh.
 * - Su dung transaction va rollback neu gap loi.
 */

$file = dirname(__DIR__) . '/database/seed_clean.sql';

if (!is_file($file)) {
    exit("LOI: Khong tim thay database/seed_clean.sql\n");
}

$sql = file_get_contents($file);

if ($sql === false || trim($sql) === '') {
    exit("LOI: File SQL rong hoac khong doc duoc.\n");
}

// Bo BOM UTF-8 neu co.
$sql = preg_replace('/^\xEF\xBB\xBF/', '', $sql);

/**
 * Tach cac lenh SQL theo dau cham phay,
 * khong tach dau cham phay nam trong chuoi.
 */
$statements = [];
$buffer = '';
$quote = null;
$escaped = false;
$length = strlen($sql);

for ($i = 0; $i < $length; $i++) {
    $ch = $sql[$i];

    if ($quote !== null) {
        $buffer .= $ch;

        if ($escaped) {
            $escaped = false;
            continue;
        }

        if ($ch === '\\') {
            $escaped = true;
            continue;
        }

        if ($ch === $quote) {
            // Xu ly nhay kep trong chuoi SQL, vi du: 'don'' vi'
            if ($i + 1 < $length && $sql[$i + 1] === $quote) {
                $buffer .= $sql[++$i];
                continue;
            }

            $quote = null;
        }

        continue;
    }

    if ($ch === "'" || $ch === '"' || $ch === '`') {
        $quote = $ch;
        $buffer .= $ch;
        continue;
    }

    if ($ch === ';') {
        if (trim($buffer) !== '') {
            $statements[] = trim($buffer);
        }

        $buffer = '';
        continue;
    }

    $buffer .= $ch;
}

if (trim($buffer) !== '') {
    $statements[] = trim($buffer);
}

/**
 * Xoa cac comment nam o dau lenh SQL.
 */
function removeLeadingSqlComments(string $statement): string
{
    $statement = ltrim($statement);

    while ($statement !== '') {
        if (preg_match('/\A--[^\r\n]*(?:\r?\n|\z)/', $statement, $m)) {
            $statement = ltrim(substr($statement, strlen($m[0])));
            continue;
        }

        if (preg_match('/\A\#[^\r\n]*(?:\r?\n|\z)/', $statement, $m)) {
            $statement = ltrim(substr($statement, strlen($m[0])));
            continue;
        }

        if (preg_match('/\A\/\*.*?\*\//s', $statement, $m)) {
            $statement = ltrim(substr($statement, strlen($m[0])));
            continue;
        }

        break;
    }

    return trim($statement);
}

/**
 * Tach cac bo VALUES dang:
 * (1, 2, 'noi dung'),
 * (3, 4, 'noi dung')
 *
 * Co xu ly dau phay va dau ngoac nam trong chuoi.
 */
function extractSqlTuples(string $values): array
{
    $tuples = [];
    $start = null;
    $depth = 0;
    $quote = null;
    $escaped = false;
    $length = strlen($values);

    for ($i = 0; $i < $length; $i++) {
        $ch = $values[$i];

        if ($start === null) {
            if ($ch === '(') {
                $start = $i;
                $depth = 1;
                $quote = null;
                $escaped = false;
            }

            continue;
        }

        if ($quote !== null) {
            if ($escaped) {
                $escaped = false;
                continue;
            }

            if ($ch === '\\') {
                $escaped = true;
                continue;
            }

            if ($ch === $quote) {
                if ($i + 1 < $length && $values[$i + 1] === $quote) {
                    $i++;
                    continue;
                }

                $quote = null;
            }

            continue;
        }

        if ($ch === "'" || $ch === '"' || $ch === '`') {
            $quote = $ch;
            continue;
        }

        if ($ch === '(') {
            $depth++;
            continue;
        }

        if ($ch === ')') {
            $depth--;

            if ($depth === 0) {
                $tuples[] = substr($values, $start, $i - $start + 1);
                $start = null;
            }
        }
    }

    return $tuples;
}

/**
 * Loai bo cac dong trung khoa chinh ket hop.
 * Chi ap dung cho cac bang da xac dinh co khoa chinh gom hai ID.
 */
function removeDuplicateCompositeKeys(
    string $statement,
    string $table
): string {
    $tablesToFix = [
        'bo_suu_tap_mon_an',
        'mon_an_di_ung',
        'mon_an_mua_vu',
	'mon_an_dip_le',
 	'hanh_trinh_mon_an',
    ];

    if (!in_array($table, $tablesToFix, true)) {
        return $statement;
    }

    $parts = preg_split('/\bVALUES\b/i', $statement, 2);

    if (count($parts) !== 2) {
        throw new RuntimeException(
            "Khong doc duoc phan VALUES cua bang {$table}."
        );
    }

    $tuples = extractSqlTuples($parts[1]);

    if (count($tuples) === 0) {
        throw new RuntimeException(
            "Khong tach duoc cac dong VALUES cua bang {$table}."
        );
    }

    $uniqueRows = [];
    $seenKeys = [];

    foreach ($tuples as $tuple) {
        if (!preg_match(
            '/\A\(\s*(\d+)\s*,\s*(\d+)/',
            $tuple,
            $ids
        )) {
            throw new RuntimeException(
                "Khong doc duoc khoa ID trong bang {$table}: {$tuple}"
            );
        }

        $key = $ids[1] . '-' . $ids[2];

        if (isset($seenKeys[$key])) {
            continue;
        }

        $seenKeys[$key] = true;
        $uniqueRows[] = $tuple;
    }

    $removed = count($tuples) - count($uniqueRows);

    if ($removed > 0) {
        echo "Da loai bo {$removed} dong trung khoa chinh trong bang {$table}.\n";
    }

    return $parts[0] . 'VALUES ' . implode(",\n", $uniqueRows);
}

/**
 * Doc va kiem tra cac lenh INSERT.
 */
$inserts = [];
$tables = [];

foreach ($statements as $statement) {
    $statement = removeLeadingSqlComments($statement);

    if ($statement === '') {
        continue;
    }

    // Bo qua cac lenh USE va SET trong file seed.
    if (preg_match('/^USE\s+/i', $statement)) {
        continue;
    }

    if (preg_match('/^SET\s+/i', $statement)) {
        continue;
    }

    // Chi chap nhan INSERT INTO ten_bang (...)
    if (!preg_match(
        '/^INSERT\s+INTO\s+`?([a-zA-Z0-9_]+)`?\s*\(/i',
        $statement,
        $match
    )) {
        exit(
            "LOI: Phat hien lenh SQL chua duoc phe duyet:\n"
            . substr($statement, 0, 180)
            . "\n"
        );
    }

    $table = $match[1];

    try {
        $statement = removeDuplicateCompositeKeys($statement, $table);
    } catch (Throwable $e) {
        exit("LOI xu ly bang {$table}: " . $e->getMessage() . "\n");
    }

    $inserts[] = $statement;
    $tables[$table] = true;
}

if (count($inserts) !== 21) {
    exit(
        "DUNG LAI: Tim thay " . count($inserts)
        . " lenh INSERT, khong phai 21. Chua nhap du lieu.\n"
    );
}

/**
 * Kiem tra database va cac bang dich.
 */
$connection = DB::connection();
$database = $connection->getDatabaseName();

if ($database !== 'dulichso') {
    exit(
        "DUNG LAI: Database hien tai la {$database}, "
        . "khong phai dulichso. Chua nhap du lieu.\n"
    );
}

foreach (array_keys($tables) as $table) {
    $exists = DB::select(
        'SELECT COUNT(*) AS total
         FROM information_schema.tables
         WHERE table_schema = DATABASE()
         AND table_name = ?',
        [$table]
    );

    if ((int) $exists[0]->total !== 1) {
        exit(
            "DUNG LAI: Bang {$table} khong ton tai "
            . "trong database hien tai.\n"
        );
    }

    $count = DB::table($table)->count();

    if ($count > 0) {
        exit(
            "DUNG LAI: Bang {$table} da co {$count} ban ghi. "
            . "Khong nhap de tranh trung lap.\n"
        );
    }
}

echo "Database hien tai: {$database}\n";
echo "So lenh INSERT: " . count($inserts) . "\n";
echo "So bang dich: " . count($tables) . "\n";
echo "Cac bang dich dang rong. Bat dau nhap...\n";

$transactionStarted = false;

try {
    DB::statement('SET NAMES utf8mb4');
    DB::statement('SET FOREIGN_KEY_CHECKS = 0');

    DB::beginTransaction();
    $transactionStarted = true;

    foreach ($inserts as $index => $statement) {
        DB::unprepared($statement);

        echo "Da thuc thi INSERT "
            . ($index + 1)
            . "/"
            . count($inserts)
            . "\n";
    }

    DB::commit();
    $transactionStarted = false;

    DB::statement('SET FOREIGN_KEY_CHECKS = 1');

    echo "\nNHAP DU LIEU THANH CONG.\n";
    echo "Thong ke so ban ghi:\n";

    foreach (array_keys($tables) as $table) {
        echo $table . ': ' . DB::table($table)->count()
            . " ban ghi\n";
    }
} catch (Throwable $e) {
    if ($transactionStarted && DB::transactionLevel() > 0) {
        DB::rollBack();
    }

    try {
        DB::statement('SET FOREIGN_KEY_CHECKS = 1');
    } catch (Throwable $ignored) {
        // Giu lai loi goc de kiem tra.
    }

    echo "\nNHAP THAT BAI. Loi: "
        . $e->getMessage()
        . "\n";

    echo "Giao dich da duoc rollback neu database ho tro transaction.\n";
    echo "Hay gui lai loi nay de kiem tra truoc khi thu lai.\n";

    exit(1);
}
