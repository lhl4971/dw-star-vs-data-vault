#!/usr/bin/env bash
set -euo pipefail

# -----------------------------
# Config
# -----------------------------
MYSQL_HOST="127.0.0.1"
MYSQL_PORT="3306"
MYSQL_USER="${MYSQL_USER:-root}"
MYSQL_DB_CREATE=""
LOG_DIR="$(cd "$(dirname "$0")/../log" && pwd)"
SQL_DIR="$(cd "$(dirname "$0")/../sql" && pwd)"

# List scripts to run in order (edit this list as your project grows)
SCRIPTS=(
  "unit_test/dw_lab_1.sql"
  "unit_test/dw_lab_2.sql"
  "unit_test/dw_lab_3.sql"
  "unit_test/dw_lab_4.sql"
  "unit_test/dw_lab_5.sql"

  "unit_test/dw_star_1.sql"
  "unit_test/dw_star_2.sql"
  "unit_test/dw_star_3.sql"
  "unit_test/dw_star_4.sql"
  "unit_test/dw_star_5.sql"

  "unit_test/dw_dv_1.sql"
  "unit_test/dw_dv_2.sql"
  "unit_test/dw_dv_3.sql"
  "unit_test/dw_dv_4.sql"
  "unit_test/dw_dv_5.sql"
)

mkdir -p "$LOG_DIR"

TS="$(date +'%Y%m%d_%H%M%S')"
MASTER_LOG="$LOG_DIR/run_${TS}.log"

echo "=== RUN START: $TS ===" | tee -a "$MASTER_LOG"
echo "Host: $MYSQL_HOST  Port: $MYSQL_PORT  User: $MYSQL_USER" | tee -a "$MASTER_LOG"
echo "SQL_DIR: $SQL_DIR" | tee -a "$MASTER_LOG"
echo "LOG_DIR: $LOG_DIR" | tee -a "$MASTER_LOG"
echo "" | tee -a "$MASTER_LOG"

# Prompt for password once (will be used by mysql client)
echo "MySQL password will be requested once per script execution." | tee -a "$MASTER_LOG"

for f in "${SCRIPTS[@]}"; do
  SQL_PATH="$SQL_DIR/$f"
  if [[ ! -f "$SQL_PATH" ]]; then
    echo "ERROR: SQL file not found: $SQL_PATH" | tee -a "$MASTER_LOG"
    exit 1
  fi

  STEP_LOG="$LOG_DIR/${TS}_${f%.sql}.log"
  mkdir -p "$(dirname "$STEP_LOG")"
  echo "----- RUN: $f -----" | tee -a "$MASTER_LOG"
  echo "Output -> $STEP_LOG" | tee -a "$MASTER_LOG"

  # Capture stdout+stderr and also capture timing (real/user/sys)
  { time mysql -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u "$MYSQL_USER" -p < "$SQL_PATH" ; } \
    >"$STEP_LOG" 2>&1

  echo "DONE: $f" | tee -a "$MASTER_LOG"
  echo "" | tee -a "$MASTER_LOG"
done

echo "=== RUN END: $(date +'%Y%m%d_%H%M%S') ===" | tee -a "$MASTER_LOG"
echo "MASTER LOG: $MASTER_LOG"