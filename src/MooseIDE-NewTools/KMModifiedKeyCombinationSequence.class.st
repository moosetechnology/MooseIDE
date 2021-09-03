"
I represent a sequence of modified key combinations.

I am only working if all keys are modified.
"
Class {
	#name : #KMModifiedKeyCombinationSequence,
	#superclass : #KMKeyCombinationSequence,
	#category : #'MooseIDE-NewTools-Keymapping'
}

{ #category : #visiting }
KMModifiedKeyCombinationSequence >> acceptVisitor: aKMShortcutPrinter [

	^ aKMShortcutPrinter visitModifiedCombinationShortcut: self
]
