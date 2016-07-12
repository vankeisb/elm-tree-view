'use strict';

require('./index.html');
require('./tree-style.less');

var Main = require('./Main.elm').Main;

var mountNode = document.getElementById('main');

// The third value on embed are the initial values for incomming ports into Elm
var app = Main.embed(mountNode);
