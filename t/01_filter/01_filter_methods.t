#!/usr/bin/perl

use strict;
use warnings;

use lib qw{./t/lib};
use TestSuite::Filter;
TestSuite::Filter->runtests();
