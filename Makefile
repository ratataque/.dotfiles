.PHONY: sync-config sync-config-apply backup-config backup-config-apply restore-config restore-config-apply

sync-config:
	bash ./sync-config.sh

sync-config-apply:
	bash ./sync-config.sh --apply

backup-config:
	bash ./backup-config.sh

backup-config-apply:
	bash ./backup-config.sh --apply

restore-config:
	bash ./restore-config.sh

restore-config-apply:
	bash ./restore-config.sh --apply
