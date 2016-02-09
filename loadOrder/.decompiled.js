var path = Npm.require("path");
var glob = Npm.require("glob");
var rimraf = Npm.require("rimraf");
var mkdirp = Npm.require("mkdirp");
var fs = Npm.require("fs");
this.loadOrder.helpers = {
  pathResolve: path.resolve,
  getFilename: path.basename,
  getAllFiles: glob.sync,
  deleteFolder: rimraf.sync,
  getExtension: function(filename) {
    return path.extname(filename).slice(1);
  },
  copyFile: function(source, dest) {
    return mkdirp.sync(dest), fs.createReadStream(source).pipe(fs.createWriteStream(path.join(dest, path.basename(source))));
  }
};
var helpers = this.loadOrder.helpers;
var config = this.loadOrder.config;
this.loadOrder.processFile = function(source) {
  var filename = helpers.getFilename(source);
  var ext = helpers.getExtension(source);
  return helpers.copyFile(source, helpers.pathResolve(config.targetFolder, config.getLocus(source, filename, ext), String(config.getLoadOrderIndex(source, filename, ext))));
};
helpers.deleteFolder(config.targetFolder);
helpers.getAllFiles(config.sourceFolder + "/**/*.*").forEach(loadOrder.processFile);
