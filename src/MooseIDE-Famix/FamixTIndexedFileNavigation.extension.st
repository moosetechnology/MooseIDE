Extension { #name : #FamixTIndexedFileNavigation }

{ #category : #'*MooseIDE-Famix' }
FamixTIndexedFileNavigation >> childInterval: aChildEntity [
	"Assume parent anchor is a FamixTIndexedFileNavigation just like receiver"

	^aChildEntity sourceAnchor
		ifNotNil: [ :anchor |
			Interval from: (anchor startPos - startPos + 1) to: (anchor endPos - startPos + 1)
		]
]
