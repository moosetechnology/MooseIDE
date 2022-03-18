Class {
	#name : #MiSourceTextBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiSourceTextBrowserTest >> browserClass [
	^ MiSourceTextBrowser
]

{ #category : #tests }
MiSourceTextBrowserTest >> testActivateActionButtons [
	{ MiInspectCommand . MiPropagateCommand }
	do: [ :cmdClass | self deny: (self actionButton: cmdClass) isEnabled ].
	self assert: (self actionButton: MiDragWindowCommand) isEnabled.

	browser receiveEntity: (FamixStClass named: 'TestClass').

	{ MiInspectCommand . MiPropagateCommand . MiDragWindowCommand }
	do: [ :cmdClass | self assert: (self actionButton: cmdClass) isEnabled ].

]

{ #category : #tests }
MiSourceTextBrowserTest >> testFollowEntityPassesOnToToolbar [

	| wasCalled |
	wasCalled := false.

	browser containedBrowser toolBarExternalEditor stub newEntity will: [ 
		wasCalled := true ].

	browser followEntity: (FamixStClass named: 'TestClass').
	self assert: wasCalled
]

{ #category : #tests }
MiSourceTextBrowserTest >> testHasExternalEditorEmacs [

	self
		assert: browser containedBrowser externalEditor
		equals: MiSourceTextExternalEditorEmacs
]

{ #category : #tests }
MiSourceTextBrowserTest >> testMiSelectedItem [

	| entityToSelect |
	self assert: browser miSelectedItem isNil.

	entityToSelect := FamixStClass named: 'TestClass'.
	browser followEntity: entityToSelect.

	self assert: browser miSelectedItem equals: entityToSelect
]

{ #category : #tests }
MiSourceTextBrowserTest >> testShowNoSourceCodeMessage [

	browser receiveEntity: (FamixStClass named: 'TestClass').
	self
		assert: browser containedBrowser sourceText text
		equals: 'There is no source code to show for TestClass'
]

{ #category : #tests }
MiSourceTextBrowserTest >> testToolbarAutoTransmit [
	| toolbar editor entity received |
	toolbar := browser containedBrowser toolBarExternalEditor.
	entity := FamixStClass named: 'TestClass'.
	received := #nothing.

	editor := Mock named: 'mock external editor'.
	editor stub new willReturn: editor.
	(editor stub open: entity) will: [ :e | received := e ].
	toolbar externalEditor: editor.

	toolbar autoTransmit: false.
	browser followEntity: entity.
	self assert: received equals: #nothing.

	toolbar autoTransmit: true.
	browser followEntity: entity.

	self assert: received equals: entity.
]
