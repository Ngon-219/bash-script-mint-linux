#!/usr/bin/env bash
set -euo pipefail

# === CONFIG (edit nếu muốn) ===
RPC_URL="${RPC_URL:-https://api.infra.mainnet.somnia.network/}"
POOL_ADDRESS="${POOL_ADDRESS:-0xB1aca87aab13a873A2e309023da9326d362faDD1}"
FROM_BLOCK="${FROM_BLOCK:-0}"      
TO_BLOCK="${TO_BLOCK:-latest}"     
CHUNK_BLOCK_COUNT="${CHUNK_BLOCK_COUNT:-2000}"  
OUT_DIR="${OUT_DIR:-./swaps_output}"
# Topic0 cho event Swap (UniswapV2-style)
SWAP_TOPIC="0xd78ad95fa46c994b6551d0da85fc275fe613ce37657fb8d5e3d130840159d822"

mkdir -p "$OUT_DIR"

# --- helper ---
dec_to_hex() { printf "0x%x" "$1"; }

hex_to_dec() {
  # expects 0x... hex
  printf "%d" "$1"
}

get_latest_block() {
  local res
  res=$(curl -sS -X POST -H "Content-Type: application/json" \
    --data '{"jsonrpc":"2.0","id":1,"method":"eth_blockNumber","params":[]}' \
    "$RPC_URL")
  echo "$res" | jq -r '.result'
}

# --- main ---
main() {
  # resolve TO_BLOCK
  if [ "$TO_BLOCK" = "latest" ]; then
    latest_hex=$(get_latest_block)
    TO_BLOCK_DEC=$(hex_to_dec "$latest_hex")
  else
    TO_BLOCK_DEC=$(hex_to_dec "$TO_BLOCK")
  fi

  # FROM_BLOCK decimal
  FROM_BLOCK_DEC=$(hex_to_dec "$FROM_BLOCK")

  echo "Fetching Swap logs for pool: $POOL_ADDRESS"
  echo "From block: $FROM_BLOCK_DEC  To block: $TO_BLOCK_DEC  chunk: $CHUNK_BLOCK_COUNT"
  out_file_base="$OUT_DIR/swaps_${POOL_ADDRESS}_${FROM_BLOCK_DEC}_${TO_BLOCK_DEC}.json"
  tmp_agg="$OUT_DIR/.tmp_swaps_agg.json"
  echo "[]" > "$tmp_agg"

  start=$FROM_BLOCK_DEC
  while [ "$start" -le "$TO_BLOCK_DEC" ]; do
    end=$(( start + CHUNK_BLOCK_COUNT - 1 ))
    [ "$end" -gt "$TO_BLOCK_DEC" ] && end=$TO_BLOCK_DEC

    start_hex=$(dec_to_hex "$start")
    end_hex=$(dec_to_hex "$end")

    echo "  querying blocks $start -> $end (hex $start_hex -> $end_hex)..."

    read -r -d '' BODY <<EOF || true
{"jsonrpc":"2.0","id":1,"method":"eth_getLogs","params":[{"address":"$POOL_ADDRESS","fromBlock":"$start_hex","toBlock":"$end_hex","topics":["$SWAP_TOPIC"]}]}
EOF

    resp=$(curl -sS -X POST -H "Content-Type: application/json" --data "$BODY" "$RPC_URL" || true)

    # check RPC error
    err=$(echo "$resp" | jq -r 'select(.error!=null) | .error.message' 2>/dev/null || true)
    if [ -n "$err" ]; then
      echo "  RPC error for range $start-$end: $err"
      echo "  retrying once after 1s..."
      sleep 1
      resp=$(curl -sS -X POST -H "Content-Type: application/json" --data "$BODY" "$RPC_URL" || true)
    fi

    logs=$(echo "$resp" | jq -c '.result // []')
    if [ "$(echo "$logs" | jq 'length')" -gt 0 ]; then
      merged=$(jq -s '.[0] + .[1]' <(cat "$tmp_agg") <(echo "$logs"))
      echo "$merged" > "$tmp_agg"
      echo "    got $(echo "$logs" | jq 'length') logs"
    else
      echo "    no logs in this chunk"
    fi

    start=$(( end + 1 ))
    sleep 0.15
  done

  mv "$tmp_agg" "$out_file_base"
  echo "Done. Combined logs saved to: $out_file_base"
  echo "Total logs: $(jq 'length' "$out_file_base")"
}

main

