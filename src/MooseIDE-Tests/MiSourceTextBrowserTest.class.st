Class {
	#name : #MiSourceTextBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiSourceTextBrowserTest >> browserClass [
	^ MiSourceTextBrowser
]

{ #category : #running }
MiSourceTextBrowserTest >> stubImmediateAnchorText: aString [
	^FamixTest1SourceTextAnchor new
		source: aString 
		yourself.

]

{ #category : #running }
MiSourceTextBrowserTest >> stubIndexedAnchorText: aString [
	^self stubIndexedAnchorText: aString positions: 1@(aString size)
]

{ #category : #running }
MiSourceTextBrowserTest >> stubIndexedAnchorText: aString positions: startEndPos [
	^FamixStubIndexedFileAnchor new
		source: aString ;
		startPos: startEndPos x ;
		endPos: startEndPos y ;
		yourself.

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

{ #category : #'tests - highlighting' }
MiSourceTextBrowserTest >> testHighlightChildNotIndexedAnchor [
	| entity |
	entity := FamixStClass new
		name: 'aClass' ;
		sourceAnchor: (self stubImmediateAnchorText: 
'code of aClass {
	code of aMethod()
}').
	FamixStMethod new
		name: 'aMethod' ;
		parentType: entity ;
		sourceAnchor: (self stubImmediateAnchorText: '	code of aMethod()' ).
		
	browser followEntity: entity.

	self assert: browser containedBrowser textRenderer formatedText unembellished.
]

{ #category : #'tests - highlighting' }
MiSourceTextBrowserTest >> testHighlightChildWithIndexedFileAnchor [

	| entity displayedText |
	entity := FamixStClass new
		          name: 'aClass';
		          sourceAnchor:
			          (self stubIndexedAnchorText: 'code of aClass {
	code of aMethod()
}').
	FamixStMethod new
		name: 'aMethod';
		parentType: entity;
		sourceAnchor:
			(self stubIndexedAnchorText: #whatever positions: 18 @ 36).

	browser followEntity: entity.

	displayedText := browser containedBrowser textRenderer formatedText.
	self deny: displayedText unembellished.
	self assert: (displayedText attributesAt: 20) isEmpty.
	self deny: (displayedText attributesAt: 30) isEmpty.
	self assert: ((displayedText attributesAt: 30) anySatisfy: [ :att | 
			 att mayActOnEvent: MouseEvent new ])
]

{ #category : #'tests - highlighting' }
MiSourceTextBrowserTest >> testHighlightChildWithNoAnchor [

	| entity |
	entity := FamixStClass new
		          name: 'aClass';
		          sourceAnchor:
			          (self stubIndexedAnchorText: 'code of aClass {
	code of aMethod()
}').
	FamixStMethod new
		name: 'aMethod';
		parentType: entity.

	browser followEntity: entity.

	self assert:
		browser containedBrowser textRenderer formatedText unembellished
]

{ #category : #'tests - highlighting' }
MiSourceTextBrowserTest >> testHighlightNoAnchor [

	| entity displayedText |
	entity := FamixStClass new name: 'aClass'.
	FamixStMethod new
		name: 'aMethod';
		parentType: entity.

	browser followEntity: entity.

	displayedText := browser containedBrowser textRenderer formatedText.
	self
		assert: displayedText
		equals: 'There is no source code to show for aClass'.
	self deny: displayedText unembellished.
	self deny: (displayedText attributesAt: displayedText size) isEmpty
]

{ #category : #'tests - highlighting' }
MiSourceTextBrowserTest >> testHighlightNoChild [

	| entity |
	entity := FamixStClass new
		          name: 'aClass';
		          sourceAnchor:
			          (self stubIndexedAnchorText: 'code of aClass {
	code of aMethod()
}').

	browser followEntity: entity.

	self assert:
		browser containedBrowser textRenderer formatedText unembellished
]

{ #category : #tests }
MiSourceTextBrowserTest >> testMiSelectedItem [

	| entityToSelect |
	self should: [browser miSelectedItem] raise: MiNoSelectedElementToPropagateException.

	entityToSelect := FamixStClass named: 'TestClass'.
	browser followEntity: entityToSelect.

	self assert: browser miSelectedItem equals: entityToSelect
]

{ #category : #tests }
MiSourceTextBrowserTest >> testShowNoSourceCodeMessage [

	browser receiveEntity: (FamixStClass named: 'TestClass').
	self
		assert: browser model displayedText
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
