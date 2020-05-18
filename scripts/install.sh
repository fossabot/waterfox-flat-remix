#!/bin/bash

THEMEDIRECTORY=$(cd `dirname $0` && cd .. && pwd)
WATERFOXFOLDER=~/.waterfox/
PROFILENAME=""
GNOMISHEXTRAS=false

# Get options.
while getopts 'f:p:g' flag; do
	case "${flag}" in    
		f) WATERFOXFOLDER="${OPTARG}" ;;
		p) PROFILENAME="${OPTARG}" ;;
		g) GNOMISHEXTRAS=true ;;
	esac
done

# Define profile folder path.
if test -z "$PROFILENAME" 
	then
		PROFILEFOLDER="$WATERFOXFOLDER/*.default"
	else
		PROFILEFOLDER="$WATERFOXFOLDER/$PROFILENAME"
fi

# Enter Waterfox profile folder.
cd $PROFILEFOLDER
echo "Installing theme in $PWD"

# Create a chrome directory if it doesn't exist.
mkdir -p chrome
cd chrome

# Copy theme repo inside
echo "Coping repo in $PWD"
cp -R $THEMEDIRECTORY $PWD

# Create single-line user CSS files if non-existent or empty.
[[ -s userChrome.css ]] || echo >> userChrome.css

# Import this theme at the beginning of the CSS files.
sed -i '1s/^/@import "waterfox-flat-remix\/userChrome.css";\n/' userChrome.css

# If GNOMISH extras enabled, import it in customChrome.css.
if [ "$GNOMISHEXTRAS" = true ] ; then
	echo "Enabling GNOMISH extra features"
    [[ -s customChrome.css ]] || echo >> waterfox-flat-remix/customChrome.css
	sed -i '1s/^/@import "theme\/hide-single-tab.css";\n/' waterfox-flat-remix/customChrome.css
	sed -i '2s/^/@import "theme\/matching-autocomplete-width.css";\n/' waterfox-flat-remix/customChrome.css
fi

# Symlink user.js to waterfox-flat-remix one.
echo "Set configuration user.js file"
ln -s chrome/waterfox-flat-remix/configuration/user.js ../user.js

echo "Done."
