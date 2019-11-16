package test

import "github.com/ipcf/t"

FooBar: string

test: t.Test & {
	describe: "One big definition": {
		subject: FooBar
		it: "should work for invalid": {
			assert: invalid: {value: 5}
		}
		it: "should work for valid": {
			assert: valid: {value: "foo"}
		}
		it: "should allow both invalid and valid": {
			assert: valid: {value: "foo"}
			assert: invalid: {value: 5}
		}
		describe: "NESTED": {
			subject: FooBar
			it: "NESTED should work for invalid": {
				assert: invalid: {value: 5}
			}
			it: "NESTED should work for valid": {
				assert: valid: {value: "foo"}
			}
			it: "NESTED should allow both invalid and valid": {
				assert: valid: {value: "foo"}
				assert: invalid: {value: 5}
			}
		}
		parent_subject = subject
		describe: "NESTED1": {
			subject: parent_subject
			it: "NESTED1 subject should work for invalid": {
				assert: invalid: {value: 5}
			}
			it: "NESTED1 subject should work for valid": {
				assert: valid: {value: "foo"}
			}
			it: "NESTED1 subject should allow both invalid and valid": {
				assert: valid: {value: "foo"}
				assert: invalid: {value: 5}
			}
		}
	}
}

test1: t.Test
test1: describe: "Lots of small definitions with shared field path": subject: FooBar
test1: describe: "Lots of small definitions with shared field path": it: "should work for invalid": assert: invalid: value:             5
test1: describe: "Lots of small definitions with shared field path": it: "should work for valid": assert: valid: value:                 "foo"
test1: describe: "Lots of small definitions with shared field path": it: "should allow both invalid and valid": assert: valid: value:   "foo"
test1: describe: "Lots of small definitions with shared field path": it: "should allow both invalid and valid": assert: invalid: value: 5

test1: t.Test
test1: describe: "Lots of small definitions with shared field path": describe: "NESTED": subject: FooBar
test1: describe: "Lots of small definitions with shared field path": describe: "NESTED": it: "NESTED should work for invalid": assert: invalid: value:             5
test1: describe: "Lots of small definitions with shared field path": describe: "NESTED": it: "NESTED should work for valid": assert: valid: value:                 "foo"
test1: describe: "Lots of small definitions with shared field path": describe: "NESTED": it: "NESTED should allow both invalid and valid": assert: valid: value:   "foo"
test1: describe: "Lots of small definitions with shared field path": describe: "NESTED": it: "NESTED should allow both invalid and valid": assert: invalid: value: 5

test1: t.Test
test1: describe: "Lots of small definitions with shared field path": {
	//parent_subject = test1.describe["Lots of small definitions with shared field path"].subject
	subject?: _
	parent_subject = subject
	describe: "NESTED1": subject: parent_subject
}
test1: describe: "Lots of small definitions with shared field path": describe: "NESTED1": it: "NESTED1 should work for invalid": assert: invalid: value:             5
test1: describe: "Lots of small definitions with shared field path": describe: "NESTED1": it: "NESTED1 should work for valid": assert: valid: value:                 "foo"
test1: describe: "Lots of small definitions with shared field path": describe: "NESTED1": it: "NESTED1 should allow both invalid and valid": assert: valid: value:   "foo"
test1: describe: "Lots of small definitions with shared field path": describe: "NESTED1": it: "NESTED1 should allow both invalid and valid": assert: invalid: value: 5

sharedTests = {
	_extraInfo: *"" | string
	subject:    FooBar
	it: "\(_extraInfo)should work for invalid": {
		assert: invalid: {value: 5}
	}
	it: "\(_extraInfo)should work for valid": {
		assert: valid: {value: "foo"}
	}
	it: "\(_extraInfo)should allow both invalid and valid": {
		assert: valid: {value: "foo"}
		assert: invalid: {value: 5}
	}
}

test2: t.Test
test2: describe: "shared tests": sharedTests
test2: describe: "shared tests": describe: "Nested": sharedTests & {_extraInfo: "Nested "}

test3: t.Test
test3: describe: "0": describe: "1": describe: "2": describe: "3": describe: "4": describe: "5": describe: "6": describe: "7": sharedTests & {_extraInfo: "max nesting depth "}
