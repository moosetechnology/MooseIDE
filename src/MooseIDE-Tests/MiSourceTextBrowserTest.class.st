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

	browser actionButtons do: [ :button | self deny: button isEnabled ].

	browser receiveEntity: (FamixStClass named: 'TestClass').

	browser actionButtons do: [ :button | self assert: button isEnabled ]
]

{ #category : #tests }
MiSourceTextBrowserTest >> testFollowEntityPassesOnToToolbar [
	| toolbar wasCalled |
	wasCalled := false.
	toolbar := Mock named: 'mock toolbar'.
	toolbar stub newEntity will: [ wasCalled := true ].

	browser toolBarExternalEditor: toolbar.
	
	browser followEntity: (FamixStClass named: 'TestClass').
	self assert: wasCalled
]

{ #category : #tests }
MiSourceTextBrowserTest >> testHasExternalEditorEmacs [

	self assert: browser externalEditor equals: MiSourceTextExternalEditorEmacs 
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
	self assert: browser sourceText text equals: 'There is no source code to show for TestClass'

]

{ #category : #tests }
MiSourceTextBrowserTest >> testToolbarAutoTransmit [
	| toolbar editor entity received |
	toolbar := browser toolBarExternalEditor.
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
