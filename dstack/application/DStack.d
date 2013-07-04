/**
 * Copyright: Copyright (c) 2013 Jacob Carlborg. All rights reserved.
 * Authors: Jacob Carlborg
 * Version: Initial created: Jun 30, 2012
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module dstack.application.DStack;

import dstack.application.Application;
import dstack.application.Configuration;

struct DStack
{
static:

    private
    {
        Application application_;
        Configuration config_;
    }

    @property Application application ()
    {
        return application_;
    }

    @property Application application (Application application)
    {
        if (application_)
            return application_;

        return application_ = application;
    }

    @property Configuration config ()
    {
        return config_;
    }

    @property Configuration config (Configuration config)
    {
        if (config_)
            return config_;

        return config_ = config;
    }
}