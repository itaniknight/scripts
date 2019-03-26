#!/bin/sh

set -uo pipefail

rm ~/.local/share/applications/wine-extension*.desktop
rm ~/.local/share/icons/hicolor/*/*/application-x-wine-extension*

rm ~/.local/share/applications/mimeinfo.cache
rm ~/.local/share/mime/packages/x-wine*
rm ~/.local/share/mime/application/x-wine-extension*

update-desktop-database ~/.local/share/applications
update-mime-database ~/.local/share/mime/
