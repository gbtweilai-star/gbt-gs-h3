# gs_h3

**One capability bit from GBT V8, packaged standalone.** No. 39 of 341,
`creation` domain (Creation).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> GS-prompt-extend 提示词工作台接线（三节点一个不差）：模型加载器/提示词工作台/模型卸载器 → op=loader/workbench/unload；H3 规则与组装零依赖可跑（rules/compose），扩写走我们的模型链（external_llm）不必下 GGUF；ComfyUI 依赖用 40 行垫片替代（不装 ComfyUI 也能驱动，不改第三方源码）

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-gs-h3.git
cd gbt-gs-h3
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_gs_h3 info                  # capability card
python -m gbt_gs_h3 spec --json           # machine-readable contract
python -m gbt_gs_h3 check --payload '{}'
python -m gbt_gs_h3 run   --payload '{}'
```

Real `info` output from this machine:

```text
gs_h3  (creation)  v1.0.0
----------------------------------------
GS-prompt-extend 提示词工作台接线（三节点一个不差）：模型加载器/提示词工作台/模型卸载器 → op=loader/workbench/unload；H3 规则与组装零依赖可跑（rules/compose），扩写走我们的模型链（external_llm）不必下 GGUF；ComfyUI 依赖用 40 行垫片替代（不装 ComfyUI 也能驱动，不改第三方源码）

gated      : True   <- needs explicit consent
external   : False
multi-op   : True
params     : (none)
values     : loader, workbench, unload
```

Wire a real implementation:

```python
from gbt_gs_h3 import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（3 个）**：`loader`、`workbench`、`unload`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Gated: this bit is marked `safe: false` in the registry — it can change state that no inverse action restores.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.13s
```

## Provenance

| field | value |
|---|---|
| capability | `gs_h3` |
| domain | `creation` |
| handler | `gs_h3` |
| safe | `False` (gated = `True`) |
| external | `False` |
| atlas page | [creation/gs_h3](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/creation/gs_h3.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
