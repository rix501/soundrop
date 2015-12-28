# Soundrop

Getting Started
---------------

First install all dependencies:
```bash
npm install
```
This will install elm, electron and all deps needed for npm scripts to run and electron js to work.

Once you have that you can go ahead and start the app with:
```bash
npm run build && npm run start
```


Working with Elm app
-----------------------
### For building:

```bash
npm run build-elm
```
This creates the `elm.js` file loaded in the Electron app.

### Developing
For starting dev server with watcher (no css):

```bash
npm run dev-elm
```
This will open a browser with `elm-reactor` debugger setup.
Elm code will be automatically compiled when saving.

Working with Electron
------------

### Starting

```bash
npm run start-app
```
### Packaging

```bash
npm run package
```
