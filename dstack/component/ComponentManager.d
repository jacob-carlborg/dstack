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
	mixin Singleton;

	private Component[] components;

	static void register (Component component)
	{
		ComponentManager.instance._register(component);
	}

	static void initialize ()
	{
		ComponentManager.instance._initialize();
	}

	static bool run ()
	{
		return ComponentManager.instance._run();
	}

private:

	void _register (Component component)
	{
		components ~= component;
	}

	void _initialize ()
	{
		foreach (component ; components)
			component.initialize();
	}

	bool _run ()
	{
		return components.map!(c => c.run()).reduce!((a, b) => a && b)(true);
	}
}