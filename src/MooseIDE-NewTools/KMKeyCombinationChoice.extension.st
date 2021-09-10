Extension { #name : #KMKeyCombinationChoice }

{ #category : #'*MooseIDE-NewTools' }
KMKeyCombinationChoice >> acceptVisitor: aKMShortcutPrinter [

	^ aKMShortcutPrinter visitShortcutCombinationChoice: self
]

{ #category : #'*MooseIDE-NewTools' }
KMKeyCombinationChoice >> shortcuts [

	^ shortcuts
]
