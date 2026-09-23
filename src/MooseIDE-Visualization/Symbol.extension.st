Extension { #name : #Symbol }

{ #category : #'*MooseIDE-Visualization' }
Symbol >> asWords [
	"#numberOfMethods >>> 'Number of methods'"

	^ (' ' join: (self asString splitCamelCase collect: #asLowercase))
		  capitalized
]
