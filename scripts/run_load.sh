#!/usr/bin/env bash
set -euo pipefail

# -----------------------------
# Config
# -----------------------------
MYSQL_HOST="127.0.0.1"
MYSQL_PORT="3306"
MYSQL_USER="${MYSQL_USER:-root}"
MYSQL_DB_CREATE=""                   # create scripts should include CREATE DATABASE / USE
LOG_DIR="$(cd "$(dirname "$0")/../log" && pwd)"
SQL_DIR="$(cd "$(dirname "$0")/../sql" && pwd)"

# List scripts to run in order (edit this list as your project grows)
SCRIPTS=(
  "staging/create_dw_lab.sql"
  "staging/load_staging.sql"
  "star_schema/create_star_schema.sql"
  "star_schema/load_star_schema.sql"
  "data_vault/create_data_vault.sql"
  "data_vault/load_data_vault.sql"
  "data_vault/create_dv_view.sql"
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