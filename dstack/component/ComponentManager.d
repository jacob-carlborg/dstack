/**
 * Copyright: Copyright (c) 2013 Jacob Carlborg. All rights reserved.
 * Authors: Jacob Carlborg
 * Version: Initial created: Feb 03, 2013
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module dstack.component.ComponentManager;

import mambo.core._;

import mambo.util.Singleton;

import dstack.component.Component;

final class ComponentManager
{
	private Component[] components;

	void register (Component component)
	{
		components ~= component;
	}

	void initialize ()
	{
		foreach (component ; components)
			component.initialize();
	}

	bool run ()
	{
		return components.map!(c => c.run()).reduce!(true, (a, b) => a && b);
	}
}