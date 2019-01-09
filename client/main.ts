/*
 * Poggit-Delta
 *
 * Copyright (C) 2018-2019 Poggit
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import * as $ from "jquery"
import {initPageCiProject} from "./pages/ci/project"
import {initPageCiUser} from "./pages/ci/user"
import {initPageError} from "./pages/error"
import {initPageHome} from "./pages/home"
import {initPageTos} from "./pages/tos"
import {initCursorNotes} from "./util/CursorNote"

declare const PoggitPageName: string

export function main(){
	$(() => {
		initCursorNotes()

		switch(PoggitPageName){
			case "error":
				return initPageError()
			case "home":
				return initPageHome()
			case "tos":
				return initPageTos()
			case "ci/user":
				return initPageCiUser()
			case "ci/project":
				return initPageCiProject()
		}
	})
}
