#!/bin/bash

# Poggit-Delta
#
# Copyright (C) 2018-2019 Poggit
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

alias tsc=/home/node/.npm-packages/bin/tsc
alias ts-node=/home/node/.npm-packages/bin/ts-node

cd /home/node/ex
echo Copying ro to ex
cp -r /home/node/ro/* .
echo Installing dependencies
NODE_ENV=development npm install
cd server

function copy-dir {
	rm -r "$1"
	cp -r /home/node/ro/"$1" "$1"
}
echo Starting server
while true
do
	cd ..
	copy-dir client
	copy-dir public
	copy-dir sass
	copy-dir secrets
	copy-dir server
	copy-dir shared
	copy-dir view

	echo Compiling client.js
	(cd client && /home/node/.npm-packages/bin/tsc)

	echo Minimizing client.js

	echo "(function(define, require, requirejs){" > gen/client/main.debug.js
	cat gen/client/modules.js >> gen/client/main.debug.js
	cat client/loader.js >> gen/client/main.debug.js
	echo >> gen/client/main.debug.js
	echo "})(define, require, requirejs)" >> gen/client/main.debug.js

	java -jar /home/node/closure-compiler.jar \
			--compilation_level SIMPLE \
			--js gen/client/main.debug.js \
			--js_output_file gen/client/main.js \
			--language_out ECMASCRIPT3
	cd server
	/home/node/.npm-packages/bin/ts-node ../bin/www 2>>../output.log >> ../output.log
	if test "$?" == 42
	then
		echo Restarting server
	else
		break
	fi
done