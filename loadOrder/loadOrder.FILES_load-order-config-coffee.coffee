loadOrder.FILES['load-order-config.coffee'] = '''
  ###
  loadOrder.config =

    # Where your application lives.
    # IMPORTANT: Must be inside `private` directory.
    sourceFolder: 'private/app'

    # Where your application will be "compiled" to.
    # Exclude this directory from code editor. Don't start its name with a dot !
    targetFolder: '_app'

    // Chose to copy file or symlink. ALPHA stage.
    // Probably not supported on windows, and you will get meteor crying that any files are doubled.
    // Possible solution: use dot at the begining of source/app floder.
    symlink: false

    # Should return number from 0 to 9.
    # 0 files are loaded first, 9 files are loaded last.
    getLoadOrderIndex: (filepath, filename, ext) ->
      return 0

    # Should return 'client', 'server' or 'shared'.
    getLocus: (filepath, filename, ext) ->
      return 'shared'
  ###

  '''
