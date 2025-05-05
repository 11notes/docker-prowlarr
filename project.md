${{ content_synopsis }} This image will give you a rootless and lightweight Prowlarr installation. Prowlarr is an indexer manager/proxy built on the popular *arr .net/reactjs base stack to integrate with your various PVR apps. Prowlarr supports management of both Torrent Trackers and Usenet Indexers. It integrates seamlessly with Lidarr, Mylar3, Radarr, Readarr, and Sonarr offering complete management of your indexers with no per app Indexer setup required (we do it all).

${{ content_uvp }} Good question! All the other images on the market that do exactly the same don’t do or offer these options:

${{ github:> [!IMPORTANT] }}
${{ github:> }}* This image runs as 1000:1000 by default, most other images run everything as root
${{ github:> }}* This image is created via a secure, pinned CI/CD process and immune to upstream attacks, most other images have upstream dependencies that can be exploited
${{ github:> }}* This image contains a proper health check that verifies the app is actually working, most other images have either no health check or only check if a port is open or ping works
${{ github:> }}* This image works as read-only, most other images need to write files to the image filesystem
${{ github:> }}* This repository has an auto update feature that will automatically build the latest version if released, most other providers don't do this
${{ github:> }}* This image is smaller than most other images

If you value security, simplicity and the ability to interact with the maintainer and developer of an image. Using my images is a great start in that direction.

${{ content_comparison }}

**Why is this image not distroless?** I would have loved to create a distroless, single binary image, sadly the way that Prowlarr is setup makes it really difficult to compile a static binary from source. Enabling AOT breaks almost 30% of used libraries because they are not setup to be statically linked (like Assembly.GetExecutingAssembly().Location). It’s also not fixable with a single PR. This is something the Prowlarr team would need to do.

${{ title_volumes }}
* **${{ json_root }}/etc** - Directory of all your settings and database

${{ content_compose }}

${{ content_defaults }}

${{ content_environment }}

${{ content_source }}

${{ content_parent }}

${{ content_built }}

${{ content_tips }}