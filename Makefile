# URL of the subversion  repository for static content
SVNURL = https://cougar.mw.lexmark.com/lexmark.com/prod/site

# Location of the Local content
CONTENTDIR = ~/Sites/www.lexmark.com/site

# Homebrew Folder
prefix = /usr/local

# Location of the Apache config file
CONFPATH = $(prefix)/etc/apache2/2.4
CONFFILE = $(CONFPATH)/httpd.conf

# name of the backup file.
CONFBACKUP = $(CONFFILE).$(shell date +'%Y%m%d-%H%M%S')


main: checkout editConfig

# checkout minimum static content from Subverison.
checkout:
	if [ ! -d $(CONTENTDIR)/.svn ]; then \
		svn checkout --depth immediates $(SVNURL) $(CONTENTDIR); \
	fi
	svn update --set-depth infinity $(CONTENTDIR)/_localhost

editConfig:
	cp $(CONFFILE) $(CONFBACKUP)
	awk -v HOMEBREW_PREFIX=$(prefix) -f edit-conf.awk < $(CONFBACKUP) > $(CONFFILE)
