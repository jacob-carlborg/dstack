/**
 * Copyright: Copyright (c) 2013 Jacob Carlborg. All rights reserved.
 * Authors: Jacob Carlborg
 * Version: Initial created: Feb 03, 2013
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module dstack.component.Component;

import dstack.component.Configuration;

abstract class Component
{
	Configuration config;

	void initialize ()
	{
		
	}

	bool run ()
	{
		return true;
	}
}