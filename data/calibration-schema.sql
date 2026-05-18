-- Calibration data schema (SQLite). Replaces the Postgres team_knowledge schema
-- used by bet-resolution + score-calibration + refresh-leaderboard.
--
-- Bootstrap: sqlite3 data/calibration.sqlite < data/calibration-schema.sql
-- Or run: bin/init-calibration-db

CREATE TABLE IF NOT EXISTS gate_events (
  event_id TEXT PRIMARY KEY,
  bet_id TEXT NOT NULL,
  asset_type TEXT,                  -- e.g. landing-page, ad, email, content
  asset_id TEXT,
  taste_owner TEXT,                 -- the operator whose prediction this is
  predicted_p_threshold_met REAL,   -- the operator's predicted probability (0-1)
  actual_outcome INTEGER,           -- 0 or 1 once resolved (NULL if open)
  brier_score REAL,                 -- (predicted - actual)^2, computed at resolution
  log_score REAL,                   -- log loss
  peer_score REAL,                  -- predicted - baseline (per asset_type)
  resolved_at TEXT,                 -- ISO timestamp
  notes TEXT,
  created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))
);

CREATE INDEX IF NOT EXISTS idx_gate_events_taste_owner ON gate_events(taste_owner);
CREATE INDEX IF NOT EXISTS idx_gate_events_asset_type ON gate_events(asset_type);
CREATE INDEX IF NOT EXISTS idx_gate_events_resolved ON gate_events(resolved_at) WHERE resolved_at IS NOT NULL;

-- Per-(taste_owner, asset_type) leaderboard. SQLite has no MATERIALIZED VIEW; a
-- regular VIEW computes on read. For low-volume calibration data (hundreds of
-- rows over a year) this is fast enough.
CREATE VIEW IF NOT EXISTS taste_leaderboard AS
SELECT
  taste_owner,
  asset_type,
  COUNT(*)             AS n_resolved_bets,
  AVG(brier_score)     AS mean_brier,
  AVG(log_score)       AS mean_log_score,
  AVG(peer_score)      AS mean_peer_score,
  -- 95% CI half-width via t-approximation (1.96 × stddev / sqrt(n)). SQLite has
  -- no STDDEV; we approximate via SQRT(AVG(x^2) - AVG(x)^2).
  CASE WHEN COUNT(*) > 1
    THEN 1.96 * SQRT(MAX(AVG(brier_score * brier_score) - AVG(brier_score) * AVG(brier_score), 0)) / SQRT(COUNT(*))
    ELSE NULL
  END                  AS brier_ci_half_width,
  MIN(resolved_at)     AS first_resolved_at,
  MAX(resolved_at)     AS last_resolved_at
FROM gate_events
WHERE resolved_at IS NOT NULL AND brier_score IS NOT NULL
GROUP BY taste_owner, asset_type
HAVING COUNT(*) >= 10;  -- N≥10 floor per Beta-Binomial gate

-- Summary view for the dashboard hero stat.
CREATE VIEW IF NOT EXISTS calibration_summary AS
SELECT
  COUNT(*)             AS n_resolved,
  AVG(brier_score)     AS mean_brier,
  MIN(resolved_at)     AS first_resolved_at,
  MAX(resolved_at)     AS last_resolved_at
FROM gate_events
WHERE resolved_at IS NOT NULL AND brier_score IS NOT NULL;
