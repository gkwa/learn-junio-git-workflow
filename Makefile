test: git
	rm -rf myproject
	sh test.sh
git:
	git clone 'https://github.com/git/git'

clean:
	rm -rf myproject
