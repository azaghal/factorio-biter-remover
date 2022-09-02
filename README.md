Biter Remover
=============


About
-----

Biter remover is a utility mod that implements a number of console commands that can be used to disable or remove biters and pollution mid-game.

Mod is primarily intended for use in late game or alongside larger modpacks to deal with heavy drops in UPS due to number of biters that get spawned as effect of factory pollution.

Commands are fairly granular and where possible operate on specific surfaces. This can be particularly helpful with larger mods such as Space Exploration where normally one (large) surface will be the main source of UPS drop (usually Nauvis).

Player must be an administrator in order to run the commands.


Features
--------


### Remove nests, worms, and biters

Removes all hostile nests, worms, and biters from listed surfaces.

Usage:
```
/remove-biters [SURFACE]...
```

Parameters:

-   `[SURFACE]...`

    > List of (space-separated) surfaces from which to remove hostile nests, worms, and biters. For currently visible surface, specify `current` as surface name. To remove biters from every single surface in the game, pass-in `all` as surface name.


### Disable biter base generation

Disables biter base generation on newly generated chunks.

Usage:
```
/disable-biter-base-generation [SURFACE]
```

Parameters:

-   `[SURFACE]...`

    > List of (space-separated) surfaces where biter base generation should be disabled. For currently visible surface, specify "current" as surface name. To disable biter base generation on every single surface in the game, pass-in "all" as surface name.


### Enable biter base generation

Enables biter base generation on newly generated chunks.

Usage:
```
/enable-biter-base-generation [SURFACE]
```

Parameters:

-   `[SURFACE]...`

    > List of (space-separated) surfaces where biter base generation should be enabled. For currently visible surface, specify "current" as surface name. To enable biter base generation on every single surface in the game, pass-in "all" as surface name.


### Disable pollution

Disables all pollution.

Usage:
```
/disable-pollution
```


### Enable pollution

Enables pollution.

Usage:
```
/enable-pollution
```


### Clear pollution from surfaces

Clears all polution on listed surfaces. Does not disable pollution (this can only be done globally).

Usage:
```
/clear-polution [SURFACE]
```

Parameters:

-   `[SURFACE]...`
    > List of (space-separated) surfaces on which to clear pollution. For currently visible surface, specify "current" as surface name. To enable biter base generation on every single surface in the game, pass-in "all" as surface name.


Known issues
------------

There are no known issues at this time.


Contributions
-------------

Bugs and feature requests can be reported through discussion threads or through project's issue tracker. For general questions, please use discussion threads.

Pull requests for implementing new features and fixing encountered issues are always welcome.


Credits
-------

Implementation was inspired by the various suggestions on how to increase the game UPS by removing the biters. In particular, main inspiration came from a [comment on steam discussion](https://steamcommunity.com/app/427520/discussions/0/1636417404918725229/#c1636417404918817381).


License
-------

All code, documentation, and assets implemented as part of this mod are released under the terms of MIT license (see the accompanying `LICENSE` file), with the following exceptions:

-    `assets/thumbnail.svg]`, which is a derivative based on Factorio game assets as provided by *Wube Software Ltd*. For details, see [Factorio Terms of Service](https://www.factorio.com/terms-of-service).
-    `thumbnail.png`, which is a derivative based on Factorio game assets as provided by *Wube Software Ltd*. For details, see [Factorio Terms of Service](https://www.factorio.com/terms-of-service).
