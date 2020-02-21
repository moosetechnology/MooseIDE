Class {
	#name : #MiInspector,
	#superclass : #StInspector,
	#category : #'Midas-Inspector'
}

{ #category : #'private factory' }
MiInspector >> newInspectorFor: aModel [
	| newInspector |
	
	newInspector := MiObjectInspector on: (self toInspectorModel: aModel). 
	millerList pages ifNotEmpty: [ :pages |
		newInspector trySelectAnyPageNamed: { 
			lastPageSelectedTabName. 
			pages last selectedPageName } ].
	self withHeaderBar ifFalse:[newInspector buildWithSpec: #noHeaderSpec].

	^ newInspector
]
