Extension { #name : #FamixTagCategory }

{ #category : #'*MooseIDE-Tagging' }
FamixTagCategory >> removeTag: aTag [

	self markedTags remove: aTag
]
