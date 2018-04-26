#!/bin/sh
sudo ./addrouter.pl
sudo birdc configure
sudo birdc show protocols
