# t

As bdd assertion package, similar to [ruby rspec](https://github.com/rspec/rspec),
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

import "github.com/ipcf/t"

import "github.com/ipcf/foo"

test: t.Test & {
	describe: "package foo ": {
		subject: foo.Bar
		it: "should accept foo": {
			assert: valid: value: "foo"
		}
		it: "should reject baz": {
			assert: invalid: value: "baz"
		}
		it: "should accept foobar": {
			assert: valid: value: "foobar"
		}
		it: "should accepts only strings with foo bar in them": [
			{assert: valid: value:   "foobar"},
			{assert: invalid: value: "baz"},
			{assert: valid: value:   "foo"},
			{assert: invalid: value: 5},
			{assert: invalid: value: null},
			{assert: invalid: value: float},
			{assert: invalid: value: []},
			{assert: invalid: value: {}},
		]
		describe: "array of describe tests": [
			{
				describe: "package foo ": {
					subject: foo.Bar
					it: "should accept foo": {
						assert: valid: value: "foo"
					}
					it: "should reject baz": {
						assert: invalid: value: "baz"
					}
					it: "should accept foobar": {
						assert: valid: value: "foobar"
					}
					it: "should accepts only strings with foo bar in them": [
						{assert: valid: value:   "foobar"},
						{assert: invalid: value: "baz"},
						{assert: valid: value:   "foo"},
						{assert: invalid: value: 5},
						{assert: invalid: value: null},
						{assert: invalid: value: float},
						{assert: invalid: value: []},
						{assert: invalid: value: {}},
					]
				}
			},
		]
	}
}
```

and then evaluate package in the `test/` directory:

```
foo/test [master] » cue eval
test: {
	subject: _
	describe: {
		"package foo ": {
			subject: =~"^([foo]|[bar])+$"
			describe: {
				"array of describe tests": [{
					describe: {
						"package foo ": {
							subject: =~"^([foo]|[bar])+$"
							it: {
								"should accept foo": {
									assert: {
										valid: {
											value: "foo"
											pass:  true
										}
									}
								}
								"should reject baz": {
									assert: {
										invalid: {
											value: "baz"
											pass:  true
										}
									}
								}
								"should accept foobar": {
									assert: {
										valid: {
											value: "foobar"
											pass:  true
										}
									}
								}
								"should accepts only strings with foo bar in them": [{
									assert: {
										valid: {
											value: "foobar"
											pass:  true
										}
									}
								}, {
									assert: {
										invalid: {
											value: "baz"
											pass:  true
										}
									}
								}, {
									assert: {
										valid: {
											value: "foo"
											pass:  true
										}
									}
								}, {
									assert: {
										invalid: {
											value: 5
											pass:  true
										}
									}
								}, {
									assert: {
										invalid: {
											value: null
											pass:  true
										}
									}
								}, {
									assert: {
										invalid: {
											value: float
											pass:  true
										}
									}
								}, {
									assert: {
										invalid: {
											value: []
											pass: true
										}
									}
								}, {
									assert: {
										invalid: {
											value: {
											}
											pass: true
										}
									}
								}]
							}
						}
					}
				}]
			}
			it: {
				"should accept foo": {
					assert: {
						valid: {
							value: "foo"
							pass:  true
						}
					}
				}
				"should reject baz": {
					assert: {
						invalid: {
							value: "baz"
							pass:  true
						}
					}
				}
				"should accept foobar": {
					assert: {
						valid: {
							value: "foobar"
							pass:  true
						}
					}
				}
				"should accepts only strings with foo bar in them": [{
					assert: {
						valid: {
							value: "foobar"
							pass:  true
						}
					}
				}, {
					assert: {
						invalid: {
							value: "baz"
							pass:  true
						}
					}
				}, {
					assert: {
						valid: {
							value: "foo"
							pass:  true
						}
					}
				}, {
					assert: {
						invalid: {
							value: 5
							pass:  true
						}
					}
				}, {
					assert: {
						invalid: {
							value: null
							pass:  true
						}
					}
				}, {
					assert: {
						invalid: {
							value: float
							pass:  true
						}
					}
				}, {
					assert: {
						invalid: {
							value: []
							pass: true
						}
					}
				}, {
					assert: {
						invalid: {
							value: {
							}
							pass: true
						}
					}
				}]
			}
		}
	}
}
```

Now change a `value` field nested in a `it` field to something you that should fail the assertion.
NOTE: there are both `valid` and `invalid` value fields in these tests.
You should see something like the following:

```
foo/test [master●] » cue eval
test.describe."package foo ".it."should accept foo".assert.valid.error: invalid operation null & "The value should NOT have resulted in `_|_`. Try running with `cue eval --ignore` and searching for this string" (mismatched types null and string):
    ../cue.mod/pkg/github.com/ipcf/t/t.cue:14:14
    ../cue.mod/pkg/github.com/ipcf/t/t.cue:14:21
```
