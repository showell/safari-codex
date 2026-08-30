# Bundle the ring-fed WASM plug: the transpiler-plug chapter set that
# codex/plugs/wasm/build.ps1 assembles, with WasmPlugRing as the body instead
# of WasmPlug -- the serial ring for an intake rather than a file chardev.
#
# The ladder's ast/bundle_ringplug.ps1 is the crib and this is its wasm twin;
# the only differences are the emitter, the body and the quire. Build-TranspilerPlug
# is not used because it ends by COMPILING, on a host toolchain this box does not
# have -- the compile here is a QEMU guest driven by ring_compile.py.
param(
    [string]$OutName = 'wasmringplug-source.codex',
    [string]$Body = 'WasmPlugRing.codex',
    [string]$PlugName = 'wasmringplug'
)
$ErrorActionPreference = 'Stop'

# COBBLESTONE_ROOT, not CODEX_ROOT: this bundle must come from the worktree that
# carries the wasm plug's real-conversion rows, and CODEX_ROOT points at the
# shared checkout the rest of the loop reads. Defaulting to CODEX_ROOT would
# quietly bundle an emitter with three holes in it.
$repo = if ($env:COBBLESTONE_ROOT) { $env:COBBLESTONE_ROOT } else { $env:CODEX_ROOT }
if (-not $repo) { throw 'set COBBLESTONE_ROOT (or CODEX_ROOT) to a Cobblestone checkout' }
$repo = (Resolve-Path $repo).Path
$here = $PSScriptRoot

. "$repo/codex/plugs/common/plug-build-lib.ps1"

$lines = [System.Collections.Generic.List[string]]::new()
foreach ($decl in @('codex/compiler/Core/Name.codex',
                    'codex/compiler/Core/SourceText.codex',
                    'codex/compiler/Types/CodexType.codex',
                    'codex/compiler/Ast/AstNodes.codex',
                    'codex/compiler/IR/IRChapter.codex')) {
    $drop = if ($decl -like '*AstNodes.codex') { @('Deck Copies') } else { @() }
    Add-PlugChapter -Lines $lines -Path (Join-Path $repo $decl) -Quire 'Wasm' -DropSections $drop
}
Add-PlugChapter -Lines $lines -Path (Join-Path $repo 'codex/plugs/common/PlugTypes.codex') -Quire 'Wasm'
Add-PlugChapter -Lines $lines -Path (Join-Path $repo 'codex/plugs/common/IRTextParser.codex') -Quire 'Wasm'
Add-PlugChapter -Lines $lines -Path (Join-Path $repo 'codex/plugs/wasm/WasmEmitter.codex') -Quire 'Wasm'
Add-PlugChapter -Lines $lines -Path (Join-Path $here $Body) -Quire 'Wasm'

$preLines = Resolve-PlugForewords $lines
Bundle-PlugSource -PreLines $preLines -Lines $lines -BundleSrc (Join-Path $here '..' 'build' $OutName) -PlugName $PlugName
