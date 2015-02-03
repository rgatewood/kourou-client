BEGIN {
  if (length(HOMEBREW_PREFIX) == 0) {
     HOMEBREW_PREFIX = "/usr/local";
  }
  inLoadModule = 0;
  inRootDirectory = 0;
  inDocumentRootDirectory = 0;
  FS = " ";
  documentRoot = sprintf("/Users/%s/Sites/www.lexmark.com/site", ENVIRON["USER"]);
}
# Listen on port 8485 (pronouced eighty, four-eighty-five)
/^[ \t]*Listen[ \t]+/ { print $1, "127.0.0.1:8485"; next; }
# Have Apache run as the current user
/^[ \t]*User[ \t]+/ { print $1, ENVIRON["USER"]; next; }
/^[ \t]*Group[ \t]+/ { print $1, "staff"; next; }

# Check for modules
/^[ \t]*LoadModule[ \t]/ { inLoadModule = 1;
    hasModules[$2] = 1;
}

# detect end of the module section
inLoadModule && !/^[ \t]*(#|LoadModule|AddType)/ { inLoadModule = 0;
  # for (i in hasModules) { print i }
  if (!("php5_module" in hasModules)) {
    # Add php module using homebrew version of PHP
    print "LoadModule php5_module " HOMEBREW_PREFIX "/opt/php55/libexec/apache2/libphp5.so"
    print "AddType application/x-httpd-php .php"
  }
}

#Secure the Root Directory
/^[ \t]*<Directory[ \t]*\/[ \t]*>/ { inRootDirectory = 1;
    print;
    print "  Require all denied";
    print "</Directory>";
    next;
}
inRootDirectory && /^[ \t]*<\/Directory[ \t]*>/ { inRootDirectory = 0; next; }
inRootDirectory { next; }

# Change the DocumentRoot
/^[ \t]*DocumentRoot[ \t]/ {
  printf("DocumentRoot \"%s\"\n", documentRoot);
  printf("\n<Directory %s>\n", documentRoot);
  print("  Options All");
  print("  AllowOverride All");
  print("  AddDefaultCharset utf-8");
  print("  Require local");
  print("</Directory>");
  printf("\nAlias /@locale@ %s/en_US\n", documentRoot);
  next;
}
# Supress the Alias line for @locale@
/^[ \t]*Alias[ \t]+\/@locale@/ { next; }

# Suppress any existing DocumentRoot Directory section
match($0, "^[ \t]*<Directory[ \t]+" documentRoot) { inDocumentRootDirectory = 1; }
inDocumentRootDirectory && /^[ \t]*<\/Directory[ \t]*>/ { inDocumentRootDirectory = 0; next; }
inDocumentRootDirectory { next; }

# Pass through everything else
{ print }