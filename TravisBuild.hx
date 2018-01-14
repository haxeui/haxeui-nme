import haxe.io.Path;
import haxe.macro.Compiler;
import sys.io.Process;

using StringTools;

class TravisBuild {
	public static function addNmeClasspaths () {
		var proc = new Process("haxelib", ["path", "nme"]);
		proc.exitCode();
		var path = proc.stdout.readAll().toString().split("\n");
		proc.close();

		var cp = "";
		for (p in path) {
			if (p.startsWith("-L ") || p.startsWith("-D ") || p == "") {
				continue;
			}
			cp = p;
			break;
		}

		Compiler.addClassPath(Path.join([cp, "src"]));

		if (Compiler.getDefine("NME_NO_HAXE_COMPAT") == null) {
			Compiler.addClassPath(Path.join([cp, "src/haxe/compat"]));
		}
	}
}
