#!/bin/sh

#
# Expose the followign configurations:
#
#   - APAXY_CONTEXT_PATH - the context path to the Apaxy instance. Defaults
#   to no context path
#
export APAXY_CONTEXT_PATH=${APAXY_CONTEXT_PATH}

#
# Non-configurable constants
#
export APACHE_SERVER_ROOT=/data/webroot
export APAXY_THEME_PATH=/data/apaxy_theme
export APAXY_THEME_ALIAS=/.apaxy_theme
export FOLDERNAME="${APAXY_THEME_ALIAS}"
export APAXY_LOG_FILE=/data/log/apaxy.log

APAXY_CONFIGURED_PATH=/root/Apaxy/webroot

mkdir -p "$(dirname ${APAXY_LOG_FILE})"

#
# Ensure the server root and context path exist
#
mkdir -p /data/webroot/"${APAXY_CONTEXT_PATH}"

#
# To keep the webroot directory clean of Apaxy configurations:
#
#   1. Migrate the Apaxy configurations into the virtualhost template
#   2. Evaluate the virtualhost template and save the result in the 
#   sites-enabled/apaxy.conf file 
#
sed -i.bak 's;APAXY_TEMP_FOLDER/theme;'"${APAXY_THEME_ALIAS}"';g' \
    $APAXY_CONFIGURED_PATH/.htaccess
APAXY_CONFIGURATIONS="$(cat $APAXY_CONFIGURED_PATH/.htaccess)"
mkdir -p /usr/local/apache2/conf/sites-enabled/
eval "echo \"`cat "/root/apaxy.tpl"`\"" > \
     /usr/local/apache2/conf/sites-enabled/apaxy.conf

#
# Determine whether or not the Apaxy installation has been
# completed yet
#
if [ ! -e "${APAXY_THEME_PATH}/icons" ] \
      || [ ! $(ls -A "${APAXY_THEME_PATH}/icons") ]; then
  
  #
  # Copy the Apaxy "theme" folder contents to the theme 
  # path folder
  #
  mkdir -p "${APAXY_THEME_PATH}"
  cp -r $APAXY_CONFIGURED_PATH/theme/* "${APAXY_THEME_PATH}"

  #
  # Support configuring the Apaxy style:
  #
  #   - APAXY_HEADER - the path to the header.html override
  #   - APAXY_FOOTER - the path to the footer.html override
  #   - APAXY_CSS - the path to the style.css override
  #
  if [ -n "${APAXY_HEADER}" ] && [ -e "${APAXY_HEADER}" ]; then
    echo "Installing the Apaxy header supplied at ${APAXY_HEADER}"
    cp "${APAXY_HEADER}" "${APAXY_THEME_PATH}"/header.html
  fi

  if [ -n "${APAXY_FOOTER}" ] && [ -e "${APAXY_FOOTER}" ]; then
    echo "Installing the Apaxy footer supplied at ${APAXY_FOOTER}"
    cp "${APAXY_FOOTER}" "${APAXY_THEME_PATH}"/footer.html
  fi

  if [ -n "${APAXY_CSS}" ] && [ -e "${APAXY_CSS}" ]; then
    echo "Installing the Apaxy stylesheet supplied at ${APAXY_CSS}"
    cp "${APAXY_CSS}" "${APAXY_THEME_PATH}"/style.css
  fi
else
  echo "Skipping installation of Apaxy theme path at ${APAXY_THEME_PATH}"
fi

#
# Start the apache server
#
echo "Starting the Apache server, this may take several seconds..."
apachectl start

#
# Ensure the container keeps running
#
tail -f /dev/null
