Extension { #name : #String }

{ #category : #'*MooseIDE-CriticBrowser' }
String >> asValuable [

	^ (Smalltalk compiler evaluate: self) ifNil: [ self asValidSelector ]
]
