SVNURL = https://cougar.mw.lexmark.com/lexmark.com/prod/site
CONTENTDIR = ~/Sites/www.lexmark.com/site

checkout:
	svn co --depth immediates $(SVNURL) $(CONTENTDIR)
	svn update --set-depth infinity $(CONTENTDIR)/_localhost

