"
I represent a sequence of modified key combinations.

I am only working if all keys are modified.
"
Class {
	#name : #KMModifiedKeyCombinationSequence,
	#superclass : #KMKeyCombinationSequence,
	#category : #'MooseIDE-NewTools-Keymapping'
}

{ #category : #printing }
KMModifiedKeyCombinationSequence >> acceptVisitor: aKMShortcutPrinter [

	^ aKMShortcutPrinter visitModifiedCombinationShortcut: self
]

{ #category : #matching }
KMModifiedKeyCombinationSequence >> matchesCompletely: anEventBuffer [

	anEventBuffer size = shortcuts size ifFalse: [ ^ false ].

	anEventBuffer with: shortcuts do: [ :event :shortcut | 
		(shortcut matchesCompletely: event asKeyCombination) ifFalse: [ 
			^ false ] ].

	^ true
]
