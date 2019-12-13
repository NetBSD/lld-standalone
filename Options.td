include "llvm/Option/OptParser.td"

class F<string name>: Flag<["--", "-"], name>;

def version: F<"version">, HelpText<"Display the version number and exit">;
def v: Flag<["-"], "v">, HelpText<"Display the version number">;
def: Flag<["-"], "V">, Alias<version>, HelpText<"Alias for --version">;
