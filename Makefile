FROM=.
TO=~/.ansible/roles/newrelic.install

make:
	rm -rf $(TO)
	cp -R $(FROM) $(TO)