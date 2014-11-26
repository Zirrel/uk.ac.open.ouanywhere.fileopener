var argscheck = require('cordova/argscheck'),
	    channel = require('cordova/channel'),
	    utils = require('cordova/utils'),
	    exec = require('cordova/exec'),
	    cordova = require('cordova');
	
FileOpener.prototype.openFile = function(successCallback, errorCallback, filename, buttonDims) {
	exec(successCallback, errorCallback, "FileOpener", "openFile", [filename, buttonDims]);
};
	
module.exports = new FileOpener();
