FROM=.
TO=~/.ansible/roles/newrelic.newrelic_install

make:
	rm -rf $(TO)
	cp -R $(FROM) $(TO)