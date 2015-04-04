test: git
	rm -rf p
	sh test.sh
git:
	git clone 'https://github.com/git/git'

clean:
	rm -rf p
