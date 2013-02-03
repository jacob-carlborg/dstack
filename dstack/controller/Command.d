/**
 * Copyright: Copyright (c) 2013 Jacob Carlborg. All rights reserved.
 * Authors: Jacob Carlborg
 * Version: Initial created: Feb 03, 2013
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module dstack.controller.Command;

import dstack.controller.Controller;

abstract class Command : Controller
{
	protected override void initialize ()
	{
		super.initialize();
	}
}