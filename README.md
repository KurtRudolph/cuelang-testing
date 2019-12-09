# testing

**NOTE: Still in early beta and subject to breaking API changes**

A assertion package,
for [cuelang](https://github.com/cuelang/cue).

## Usage

Given [`github.com/ipcf/foo/foo.cue`](https://github.com/ipcf/foo/blob/master/foo.cue):
```
package foo

Bar: =~ "^([foo]|[bar])+$"
```

one might define tests as follows [`github.com/ipcf/foo/test/foo.cue`](https://github.com/ipcf/foo/blob/master/test/foo.cue):
```
package test

import "github.com/ipcf/testing"
import "github.com/ipcf/foo"

testing.T & {
		test: "foo.Bar": {
			[t.NumDot]: subject: foo.Bar
			"0": assert: ok: "foo"
			"1": assert: notOK: "foobar" // will fail
			"2": assert: ok: "bar"
			"3": assert: ok: "barfoo"
			"4": assert: ok: "barfoo"
			"5": assert: ok: "barfoofoobarfoo"
			"6": assert: notOk: ""
			"7": assert: notOk: "bar1"
			"8": assert: notOk: "1bar"
			"9": assert: notOk: int
			"10": assert: notOk: null
			"11": assert: notOk: {}
		}
	}
}
```

and then evaluate package in the `test/` directory:

```
foo/test [master] » cue eval
test: {
    BarBaz: {
        "0": {
            subject: =~"^([foo]|[bar])+$"
            assert: {
                ok:   "foo"
                pass: true
            }
        }
        "1": {
            subject: =~"^([foo]|[bar])+$"
.
.
.
```

Kind of a lot of output so let's just look at failed tests:
```
foo/test [master] » cue eval --expression FAIL
BarBaz: {
    "1": {
        subject: =~"^([foo]|[bar])+$"
        assert: {
            pass:  false
            notOk: "foobar"
        }
    }
}
```
Looks like `BarBaz: "1": notOk: "foobar"` failed :+1

## LICENSE

MIT License, see [LICENSE](LICENSE)
