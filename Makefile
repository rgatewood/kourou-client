# URL of the subversion  repository for static content
SVNURL = https://cougar.mw.lexmark.com/lexmark.com/prod/site

# Location of the Local content
CONTENTDIR = ~/Sites/www.lexmark.com/site

# Location of the Apache config file
CONFPATH = /usr/local/etc/apache2/2.4

CONFFILE = $(CONFPATH)/httpd.conf

# name of the backup file.
CONFBACKUP = $(CONFFILE).$(shell date +'%Y%m%d-%H%M%S')


main: checkout editConfig

checkout:
	svn co --depth immediates $(SVNURL) $(CONTENTDIR)
	svn update --set-depth infinity $(CONTENTDIR)/_localhost

editConfig:
	cp $(CONFFILE) $(CONFBACKUP)
	awk -f edit-conf.awk < $(CONFBACKUP) > $(CONFFILE)
