/**
 * Copyright: Copyright (c) 2012 Jacob Carlborg. All rights reserved.
 * Authors: Jacob Carlborg
 * Version: Initial created: May 3, 2012
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module dstack.application.Application;

import mambo.core._;
import mambo.sys.System;
import mambo.util.Singleton;

import dstack.application.ApplicationException;

abstract class Application
{
	protected string[] args;
	
	static int start (this T) (string[] args)
	{
		auto app = T.instance;
		app.args = args;
		
		debug
			return app.debugStart();
		
		else
			return app.releaseStart();
	}
	
	private int releaseStart ()
	{
		try
			run();
			
		catch (ApplicationException e)
		{
			println("An error occurred: ", e);
			return ExitCode.failure;
		}
		
		catch (Exception e)
		{
			println("An unknown error occurred: ", e);
			throw e;
		}
		
		return ExitCode.success;
	}
	
	private int debugStart ()
	{
		run();
		return ExitCode.success;
	}

	protected abstract void run ();
}