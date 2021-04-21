# Extract help from Makefile comments start marked by "$HELP$" end by empty line

state == "" && $1 == "#" && $0 ~ /\$HELP\$/  { state = 1; next; }

state == 1 && $1 ~ /^#/ { l = $0; sub(/^#/, "", l); gsub(/^ /, "", l); print l; next; }

state == 1 && $0 == "" { state = 0; next; }
