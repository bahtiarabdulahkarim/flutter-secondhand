# ============================================================
# SecondHand Backend - Test Script Tahap 1
# Jalankan: .\test-tahap1.ps1
# Pastikan backend sudah berjalan: npm run dev
# ============================================================

$BASE_URL = "http://localhost:3000/api/v1"
$headers  = @{"Content-Type" = "application/json"}

# ==== MASUKKAN TOKEN FIREBASE ANDA DI SINI ====
# Cara dapat token: Di Flutter, panggil FirebaseAuth.instance.currentUser?.getIdToken()
# Atau gunakan Firebase Auth REST API untuk testing
$FIREBASE_TOKEN = "PASTE_FIREBASE_ID_TOKEN_DISINI"

$authHeaders = @{
  "Content-Type"  = "application/json"
  "Authorization" = "Bearer $FIREBASE_TOKEN"
}

function Test-EP {
  param($label, $method, $url, $body=$null, $useAuth=$false)

  $h = if ($useAuth) { $authHeaders } else { $headers }

  try {
    $params = @{
      Uri         = $url
      Method      = $method
      Headers     = $h
      ErrorAction = "Stop"
    }

    if ($body) {
      $params["Body"] = ($body | ConvertTo-Json -Compress)
    }

    $r = Invoke-RestMethod @params
    $data = if ($r.data) {
      if ($r.data -is [array]) { "[$($r.data.Count) item(s)]" }
      else { "[object]" }
    } else { "" }

    Write-Host "  [PASS] $label => $($r.message) $data" -ForegroundColor Green
  }
  catch {
    $code = $_.Exception.Response.StatusCode.value__
    $raw  = $_.ErrorDetails.Message
    $msg  = ""
    try { $msg = ($raw | ConvertFrom-Json).message } catch {}
    Write-Host "  [HTTP $code] $label => $msg" -ForegroundColor $(if ($code -in 400,401,403,404,409) { "Yellow" } else { "Red" })
  }
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host " SecondHand Backend - Tes Tahap 1" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# --- HEALTH ---
Write-Host "[A] Health Check" -ForegroundColor White
Test-EP "GET /health" "GET" "$BASE_URL/health"
Test-EP "GET /db-health" "GET" "$BASE_URL/db-health"

Write-Host ""

# --- KEAMANAN: Tanpa Token (expect 401) ---
Write-Host "[B] Keamanan — Semua endpoint berikut HARUS mengembalikan 401 tanpa token" -ForegroundColor White
Test-EP "GET /me (no token)" "GET" "$BASE_URL/me"
Test-EP "PATCH /me (no token)" "PATCH" "$BASE_URL/me" @{full_name="Test"}
Test-EP "POST /auth/sync (no token)" "POST" "$BASE_URL/auth/sync"
Test-EP "POST /test-drives (no token)" "POST" "$BASE_URL/test-drives" @{vehicle_id=1}
Test-EP "PATCH /test-drives/1/status (no token)" "PATCH" "$BASE_URL/test-drives/1/status" @{status="approved"}
Test-EP "PATCH /test-drives/1/assign (no token)" "PATCH" "$BASE_URL/test-drives/1/assign" @{assigned_admin_id=1}

Write-Host ""

# --- PUBLIC ENDPOINT ---
Write-Host "[C] Endpoint Public (tanpa token)" -ForegroundColor White
Test-EP "GET /vehicles" "GET" "$BASE_URL/vehicles"
Test-EP "GET /vehicles?category=motor" "GET" "$BASE_URL/vehicles?category=motor"
Test-EP "GET /brands" "GET" "$BASE_URL/brands"
Test-EP "GET /categories" "GET" "$BASE_URL/categories"
Test-EP "GET /models" "GET" "$BASE_URL/models"

Write-Host ""

# --- AUTH DENGAN TOKEN (hanya jika token diisi) ---
if ($FIREBASE_TOKEN -ne "PASTE_FIREBASE_ID_TOKEN_DISINI") {
  Write-Host "[D] Endpoint Dengan Token Firebase" -ForegroundColor White
  Test-EP "POST /auth/sync" "POST" "$BASE_URL/auth/sync" $null $true
  Test-EP "GET /me" "GET" "$BASE_URL/me" $null $true
  Test-EP "PATCH /me (update nama)" "PATCH" "$BASE_URL/me" @{full_name="Test User Baru"} $true
  Test-EP "GET /test-drives (user own)" "GET" "$BASE_URL/test-drives" $null $true

  Write-Host ""
  Write-Host "[E] Test Drive — Validasi Input (dengan token)" -ForegroundColor White
  # Expect 400: tanggal masa lalu
  Test-EP "POST /test-drives (tanggal lalu, expect 400)" "POST" "$BASE_URL/test-drives" @{
    vehicle_id    = 1
    scheduled_date = "2020-01-01"
    start_time    = "09:00"
    end_time      = "10:00"
  } $true
  # Expect 400: jam mulai >= jam selesai
  $today = (Get-Date).AddDays(1).ToString("yyyy-MM-dd")
  Test-EP "POST /test-drives (jam invalid, expect 400)" "POST" "$BASE_URL/test-drives" @{
    vehicle_id    = 1
    scheduled_date = $today
    start_time    = "10:00"
    end_time      = "09:00"
  } $true
}
else {
  Write-Host "[D] Lewati tes dengan token (isi variabel FIREBASE_TOKEN di atas)" -ForegroundColor DarkGray
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host " Tes selesai!" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
