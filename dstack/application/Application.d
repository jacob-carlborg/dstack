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

abstract class Application
{
	mixin Singleton;
	
	protected string[] args;
	
	static int start (T this) (string[] args)
	{
		T.instance._start(args);
	}
	
	private int releaseStart (string[] args)
	{
		try
			run();
			
		catch (ApplicationException e)
		{
			println("An error occurred: ", e);
			return ExiteCode.failure;
		}
		
		catch (Exception e)
		{
			println("An unknown error occurred: ", e);
			throw e;
		}
		
		return ExiteCode.sucess;
	}
	
	private int debugStart (string[] args)
	{
		run();
		return ExiteCode.sucess;
	}

	protected abstract void run ();
}