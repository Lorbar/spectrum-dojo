#!/bin/sh
# Serve Spectrum Dojo on your local network. Open the printed address on any phone, tablet or laptop on the same Wi-Fi.
cd "$(dirname "$0")"
PORT="${1:-8081}"
IP=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || hostname -I 2>/dev/null | awk '{print $1}')
echo "Spectrum Dojo is being served."
echo "  This Mac:        http://localhost:$PORT/"
[ -n "$IP" ] && echo "  Other devices:   http://$IP:$PORT/"
echo "Press Ctrl+C to stop."
exec python3 -m http.server "$PORT" --bind 0.0.0.0
