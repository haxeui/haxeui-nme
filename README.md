![build status](https://github.com/haxeui/haxeui-nme/actions/workflows/build.yml/badge.svg)

# haxeui-nme
`haxeui-nme` is the `NME` backend for HaxeUI.

<p align="center">
	<img src="https://github.com/haxeui/haxeui-nme/raw/master/screen.png" />
</p>

## Installation
 * `haxeui-nme` has a dependency to <a href="https://github.com/haxeui/haxeui-core">`haxeui-core`</a>, and so that too must be installed.
 * `haxeui-nme` also has a dependency to <a href="https://github.com/haxenme/nme/">NME</a>, please refer to the installation instructions on their <a href="https://github.com/haxenme/nme/">NME</a>.
 
Eventually all these libs will become haxelibs, however, currently in their alpha form they do not even contain a `haxelib.json` file (for dependencies, etc) and therefore can only be used by downloading the source and using the `haxelib dev` command or by directly using the git versions using the `haxelib git` command (recommended). Eg:

```
haxelib git haxeui-core https://github.com/haxeui/haxeui-core
haxelib dev haxeui-nme path/to/expanded/source/archive
```

## Usage
The simplest method to create a new `NME` application that is HaxeUI ready is to use one of the <a href="https://github.com/haxeui/haxeui-templates">haxeui-templates</a>. These templates will allow you to start a new project rapidly with HaxeUI support baked in. 

If however you already have an existing application, then incorporating HaxeUI into that application is straight forward:

### project.nmml
Assuming `haxeui-core` and `haxeui-nme` have been installed, then adding HaxeUI to your existing application is as simple as adding these two lines to your `project.nmml`:

```xml
<haxelib name="haxeui-core" />
<haxelib name="haxeui-nme" />
```

_Note: Currently you must also include `haxeui-core` explicitly during the alpha, eventually `haxelib.json` files will exist to take care of this dependency automatically._ 

### Toolkit initialisation and usage
Initialising the toolkit requires you to add this single line somewhere _before_ you start to actually use HaxeUI in your application:

```
Toolkit.init();
```
Once the toolkit is initialised you can add components using the methods specified <a href="https://github.com/haxeui/haxeui-core#adding-components-using-haxe-code">here</a>.

## NME specifics

As well as using the generic `Screen.instance.addComponent`, it is also possible to add components directly to any other `NME` sprite (eg: `Lib.current.stage.addChild`)

## Addtional resources
* <a href="http://haxeui.org/explorer/">component-explorer</a> - Browse HaxeUI components
* <a href="http://haxeui.org/builder/">playground</a> - Write and test HaxeUI layouts in your browser
* <a href="https://github.com/haxeui/component-examples">component-examples</a> - Various componet examples
* <a href="http://haxeui.org/api/haxe/ui/">haxeui-api</a> - The HaxeUI api docs.
* <a href="https://github.com/haxeui/haxeui-guides">haxeui-guides</a> - Set of guides to working with HaxeUI and backends.
