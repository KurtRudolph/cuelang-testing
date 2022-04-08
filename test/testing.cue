package test

import "github.com/ipcf/testing"

testing.T & {
	let BarBaz = =~"^([foo]|[bar])+$"

	test: "BarBaz": {
		[testing.NumDot]: subject: BarBaz
		"0": assert: ok:     "foo"
		"1": assert: ok:     "foobar"
		"2": assert: ok:     "bar"
		"3": assert: ok:     "barfoo"
		"4": assert: ok:     "barfoo"
		"5": assert: ok:     "barfoofoobarfoo"
		"6": assert: notOk:  ""
		"7": assert: notOk:  "bar1"
		"8": assert: notOk:  "1bar"
		"9": assert: notOk:  int
		"10": assert: notOk: null
		"11": assert: notOk: {}
	}

	let FooBar = close({
		thing:    string
		greeting: "hey" | "hello"
		result:   "\(greeting) \(thing)"
	})

	test: "FooBar": {
		[testing.NumDot]: subject: FooBar
		"0": assert: ok: {thing:   "world", greeting: "hello"}
		"1": assert: notOk: {thing1: "world"} // invalid key
		"3": assert: ok: {thing: "world", greeting: "hello", result: "hello world"}
	}

	test: "FooBar": "#thing can only be a string": {
		[testing.NumDot]: subject: FooBar.thing
		"0": assert: ok:    "someString"
		"1": assert: ok:    "someOtherString"
		"2": assert: notOk: 4
		"3": assert: notOk: null
		"4": assert: notOk: true
	}

	test: "testing.NumStr": {
		[=~"^[0-9]$"]: subject: testing.NumDot
		"0": assert: ok:     "0"
		"1": assert: ok:     "1"
		"2": assert: ok:     "9999999999999999999999"
		"3": assert: notOk:  ".1"
		"4": assert: ok:     "1.1"
		"5": assert: ok:     "1.12"
		"6": assert: ok:     "91.129"
		"7": assert: notOk:  "1."
		"8": assert: ok:     "1.1.1.1"
		"9": assert: notOk:  "foo"
		"10": assert: notOk: "foo0"
		"11": assert: notOk: "0foo"
		"12": assert: notOk: "0f1"
	}

	let someFailures = {
		"0": {subject: string, assert: {ok: "shouldPass", pass: true}}
		"1": {subject: string, assert: {notOk: "shouldFail", pass: false}}
		"2": {subject: string, assert: {ok: 4, pass: false}}
	}

	test: "testing.T.PASS testing.T.FAIL": {
		subject: testing.T
		assert: ok: test: "test 0 pass, test 1,2 fail": someFailures
		assert: ok: PASS: "test 0 pass, test 1,2 fail": "0": someFailures["0"]
		assert: ok: FAIL: "test 0 pass, test 1,2 fail": {"1": someFailures["1"], "2": someFailures["2"]}
	}
}
