Extension { #name : #KMShortcutPrinter }

{ #category : #'*MooseIDE-NewTools' }
KMShortcutPrinter >> visitModifiedCombinationShortcut: aModifiedCombination [

	^ String streamContents: [ :stream | 
		  (self shortcutModifiersOf: aModifiedCombination sequence first) 
			  ifNotEmpty: [ :modifiers | 
				  modifiers
					  do: [ :each | stream << each ]
					  separatedBy: [ stream << '+' ].
				  stream << '+' ].
		  aModifiedCombination sequence do: [ :e | 
			  stream << (self mapSpecialCharacter: e platformCharacter) ] ]
]

{ #category : #'*MooseIDE-NewTools' }
KMShortcutPrinter >> visitShortcutCombinationChoice: aShortcutCombinationChoice [

	^ (aShortcutCombinationChoice shortcuts detect: [ :s | 
		   s platform = Smalltalk os platformFamily or: [ s platform = #all ] ])
		  shortcut acceptVisitor: self
]
