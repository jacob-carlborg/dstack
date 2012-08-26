/**
 * Copyright: Copyright (c) 2012 Jacob Carlborg. All rights reserved.
 * Authors: Jacob Carlborg
 * Version: Initial created: Aug 26, 2012
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module dstack.application.Configuration;

import mambo.core._;
import mambo.text.ConfigMap;
import mambo.util.Reflection;

class Configuration
{
    mixin ConfigMapMixin;
	alias map this;

	this (T) (T subclass)
	{
		addSubclassFields(subclass);
	}

private:

	void addSubclassFields (T) (T subclass)
	{
		foreach (i, _ ; typeof(T.tupleof))
		{
			enum field = nameOfFieldAt!(T, i);
			alias TypeOfField!(T, field) Type;
			map[field] = Value(getValueOfField!(T, Type, field)(subclass).toString);
		}
	}
}