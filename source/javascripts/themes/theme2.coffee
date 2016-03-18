# global js
//= require ../main

# theme js (there's a bug, probably sprockets, where the file is not being found if the _ is not on the file name in this require, see https://github.com/sstephenson/sprockets/issues/706 and https://github.com/middleman/middleman-sprockets/issues/75)
//= require ./theme2/_example
