# docker-apaxy

A simple configurable container to generate an Apache docker container with [Apaxy](http://adamwhitcroft.com/apaxy/). Thanks to Adam Whitcroft for creating, maintaining, and sharing the [Apaxy project](https://github.com/AdamWhitcroft/Apaxy).

## Examples

### Quick Start

Run the following:

```
docker run -d -it \
 --name apaxy \
 -v /your/file/share/directory:/data \
 -p 80:80 \
 xetusoss/apaxy
 ```

Add files to `/your/file/share/directory/webroot` on your Docker host to see them populate in the Apaxy-style Apache file index running in the new container.

### Apaxy Configuration

To override the default header, footer, and css provided out-of-the-box with Apaxy:

```
docker run -d -it \
 --name apaxy \
 -v /your/file/share/directory:/data \
 -p 80:80 \
 -e APAXY_HEADER=/data/header-override.html \
 -e APAXY_FOOTER=/data/footer-override.html \
 -e APAXY_CSS=/data/style-override.css \
 xetusoss/apaxy
``` 

## Details

The container exposes a data volume at `/data`. The following directories are added by default once the container starts up if they don't already exist:

```
# The document root for the Apache server. If the 
# APAXY_CONTEXT_PATH option is specified, the path
# will be generated as a subdirectory to this webroot
# folder if it does not already exist.
/data/webroot

# The location of the Apaxy error log
/data/log

# The directory out of which the Apaxy theme files are served.
# Note that this will not be generated if it exists when the container 
# is started
/data/apaxy_theme
```

## Configuration

The following environment variable configurations are available:

* __APAXY_CONTEXT_PATH__: The context path from which the Apaxy file index should be configured. Defaults to no context path (the Apaxy file index is configured at the root ('/') endpoint).
* __APAXY_HEADER__: The path to a custom Apaxy header.html file with which to override Apaxy's default header. Please see the Apaxy source for the header's requirements. 
* __APAXY_FOOTER__: The path to a custom Apaxy footer.html file with which to override Apaxy's default footer. Please see the Apaxy source for the footer's requirements.
* __APAXY_CSS__: The path to a CSS file that should be used instead of the default Apaxy CSS file.


## Credits

Thanks agian to Adam Whitcroft for creating, maintaining, and sharing the [Apaxy project](https://github.com/AdamWhitcroft/Apaxy).