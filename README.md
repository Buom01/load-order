> Important notes: This package doesn't work very well, and I think that the best way to do this is using gruntjs

> Wait next update before installing this package ! Next update will use gruntjs

## Meteor Load Order

Create your own file load order rules for Meteor.
Forked from https://github.com/enimton/load-order

## Installation

```
meteor add buom01:load-order
```

After installation `packages/load-order-config` folder will be created.

## Where Write Load Order Rules

```
myapp/
  packages/
    load-order-config/
      load-order-config.coffee  <-- Write rules here (CoffeeScript)
      load-order-config.js      <-- Write rules here (JavaScript)
      load-order.min.js         <-- Don't touch this file
      package.js                <-- Don't touch this file
```

## Configuration Syntax

```js
// packages/load-order-config/load-order-config.js
loadOrder.config = {
  // Where your application lives.
  // IMPORTANT: Must be inside `private` directory.
  sourceFolder: 'private/app',

  // Where your application will be "compiled" to.
  // Exclude this directory from code editor. **Don't start its name with a dot !**
  targetFolder: '_app',

  // Chose to copy file or symlink. ALPHA stage.
  // Probably not supported on windows, and you will get meteor crying that any files are doubled.
  // Possible solution: use dot at the begining of source/app floder.
  symlink: false,

  // Should return number from 0 to 9.
  // 0 files are loaded first, 9 files are loaded last.
  getLoadOrderIndex: function(filepath, filename, ext) {
    return 0;
  },

  // Should return 'client', 'server' or 'shared'.
  getLocus: function(filepath, filename, ext) {
    return 'shared';
  }
};
```

## How to Use This Package

1. You write application in `private/app` directory
2. `order-rules` watches for file changes
3. When you do changes, `order-rules` "compiles" your app intro `_app` directory
4. Then Meteor reads your app from `_app` directory
5. That how it works

You can change `private/app` and `_app` directories in configuration file. **Don't start its name with a dot, it's must be readable by meteor***

It's recommended to exclude `_app` directory from your code editor.

## Configuration Example

```js
loadOrder.config = {
  sourceFolder: 'private/app',

  targetFolder: '_app',

  symlink: false,

  getLoadOrderIndex: function(filepath, filename, ext) {
    if (filename === 'main.js') {
      return 0;
    }

    return 1;
  },

  getLocus: function(filepath, filename, ext) {
    if ([ 'css', 'less', 'html' ].indexOf(ext) >= 0) {
      return 'client';
    }

    if (filename.indexOf('.s.') >= 0) {
      return 'server';
    }

    if (filename.indexOf('.c.') >= 0) {
      return 'client';
    }

    return 'shared';
  }
};
```

With this configuration:

- `main.js` file will be loaded first
- All styles and templates will be served to client only
- All scripts with `.s.` in their filenames (e.g. `collections.s.js`) will be served to server
- All scripts with `.c.` in their filenames (e.g. `router.c.js`) will be served to client only
- All rest scripts will be served to both: client and server


## Others notes
### Now maintained by Buom01

Because it had many bugs and it's original author stop its developpement, I decided to update it.

### Major differences from imkost's version
  - Decompiled compressed file
  - Add warning about dot in output file
  - Now allowing two file with the same name
  - Now work (optionnaly) with symlink in alpha stage
