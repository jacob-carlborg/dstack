/**
 * Copyright: Copyright (c) 2013 Jacob Carlborg. All rights reserved.
 * Authors: Jacob Carlborg
 * Version: Initial created: Feb 03, 2013
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module dstack.core.Exceptions;

class DStackException : Exception
{
	template Constructor ()
	{
		@safe pure nothrow this (string message, string file = __FILE__, size_t line = __LINE__, Throwable next = null)
		{
			super(message, file, line, next);
		}

		@safe pure nothrow this (string message, Throwable next, string file = __FILE__, size_t line = __LINE__)
	    {
			super(message, file, line, next);
		}
	}

	mixin Constructor;
}