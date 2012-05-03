/**
 * Copyright: Copyright (c) 2012 Jacob Carlborg. All rights reserved.
 * Authors: Jacob Carlborg
 * Version: Initial created: May 3, 2012
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module dstack.application.ApplicationException;

class ApplicationException : Exception
{
	this (string message, string file = null, size_t line = 0)
	{
		super(message, file, line);
	}
}