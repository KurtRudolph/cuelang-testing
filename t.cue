package t

Describe:: {
	[_]: {
		describe?: Describe
		subject?:  _
		it?: {
			[_] : close({
				assert: valid?: {
					value: _
					testsResult = value & subject
					pass: testsResult != _|_
					if pass == false {
						error: null & "The value should NOT have resulted in `_|_`. Try running with `cue eval --ignore` and searching for this string"
					}
				}
				assert: invalid?: {
					value: _
					testsResult = value & subject
					pass: testsResult == _|_
					if pass == false {
						error: null & "The value SHOULD have resulted in `_|_`. Try running with `cue eval --ignore` and searching for this string"
					}
				}
			})
		}
	}
}

Test:: {
	subject: _
	describe: {
		Describe
	}
}
