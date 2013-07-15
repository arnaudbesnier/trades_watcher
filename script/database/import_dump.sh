# If not backup path specified, use the default one
if [ "$1" ]; then
	BACKUP="$1"
else
	BACKUP="$HOME/Dropbox/Documents/Money/Trades-watcher/last.dump"
fi

echo '--- Clear schema'
psql -U postgres -d trades_watcher_development << EOF
  DROP SCHEMA IF EXISTS public CASCADE
EOF

# Restore db (see http://devcenter.heroku.com/articles/pgbackups#exporting_via_a_backup)
echo '--- Restore dump'
pg_restore --verbose --clean --no-acl --no-owner  -U postgres -d trades_watcher_development "$BACKUP"