loadOrder.FILES['load-order.js'] = '''
var path = Npm.require("path");
var glob = Npm.require("glob");
var rimraf = Npm.require("rimraf");
var fs = Npm.require("fs");
var mkdirp = Npm.require("mkdirp");

var config = this.loadOrder.config;

this.loadOrder.helpers = {
  pathResolve: path.resolve,
  getFilename: path.basename,
  getAllFiles: glob.sync,
  deleteFolder: rimraf.sync,
  getExtension: function(filename) {
    return path.extname(filename).slice(1);
  },
  copyFile: function(source, dest) {
    var newFilename = source.replace(config.sourceFolder+"/","").replace(/\\/|\\\\/g,'-');
    var absoluteSource = path.join(path.resolve('.'),source);
    var absoluteDest = path.join(dest,newFilename);
    mkdirp.sync(dest);
    if(config.symlink){
      fs.symlinkSync(absoluteSource,absoluteDest, 'file');
    }else{
      fs.createReadStream(absoluteSource).pipe(fs.createWriteStream(absoluteDest));
    }
  }
};
var helpers = this.loadOrder.helpers;
this.loadOrder.processFile = function(source) {
  var filename = helpers.getFilename(source);
  var ext = helpers.getExtension(source);
  return helpers.copyFile(source, helpers.pathResolve(config.targetFolder, String(config.getLoadOrderIndex(source, filename, ext)),config.getLocus(source, filename, ext)));
};
helpers.deleteFolder(config.targetFolder);
helpers.getAllFiles(config.sourceFolder + "/**/*.*").forEach(loadOrder.processFile);

  '''
