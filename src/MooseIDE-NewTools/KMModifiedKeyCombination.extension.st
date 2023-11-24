Extension { #name : #KMModifiedKeyCombination }

{ #category : #'*MooseIDE-NewTools' }
KMModifiedKeyCombination >> , aShortcut [

	^ KMModifiedKeyCombinationSequence
		  first: self
		  next: aShortcut asKeyCombination
]
