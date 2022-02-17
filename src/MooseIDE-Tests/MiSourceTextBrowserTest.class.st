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
	^FAMIXSourceTextAnchor new
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

	browser actionButtons do: [ :button | self deny: button isEnabled ].

	browser receiveEntity: (FamixStClass named: 'TestClass').

	browser actionButtons do: [ :button | self assert: button isEnabled ]
]

{ #category : #'tests - externalEditor' }
MiSourceTextBrowserTest >> testFollowEntityPassesOnToToolbar [
	| toolbar wasCalled |
	wasCalled := false.
	toolbar := Mock named: 'mock toolbar'.
	toolbar stub newEntity will: [ wasCalled := true ].

	browser toolBarExternalEditor: toolbar.
	
	browser followEntity: (FamixStClass named: 'TestClass').
	self assert: wasCalled
]

{ #category : #'tests - externalEditor' }
MiSourceTextBrowserTest >> testHasExternalEditorEmacs [

	self assert: browser externalEditor equals: MiSourceTextExternalEditorEmacs 
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

	self assert: browser sourceText unembellished.
]

{ #category : #'tests - highlighting' }
MiSourceTextBrowserTest >> testHighlightChildWithIndexedFileAnchor [
	| entity |
	entity := FamixStClass new
		name: 'aClass' ;
		sourceAnchor: (self stubIndexedAnchorText: 
'code of aClass {
	code of aMethod()
}').
	FamixStMethod new
		name: 'aMethod' ;
		parentType: entity ;
		sourceAnchor: (self stubIndexedAnchorText: #whatever positions: 18@36 ).
		
	browser followEntity: entity.

	self deny: browser sourceText unembellished.
	self assert: (browser sourceText attributesAt: 20) isEmpty.
	self deny: (browser sourceText attributesAt: 30) isEmpty.
	self assert: ((browser sourceText attributesAt: 30) anySatisfy: [ :att | att mayActOnEvent: MouseEvent new ])
]

{ #category : #'tests - highlighting' }
MiSourceTextBrowserTest >> testHighlightChildWithNoAnchor [
	| entity |
	entity := FamixStClass new
		name: 'aClass' ;
		sourceAnchor: (self stubIndexedAnchorText: 
'code of aClass {
	code of aMethod()
}').
	FamixStMethod new
		name: 'aMethod' ;
		parentType: entity.
		
	browser followEntity: entity.

	self assert: browser sourceText unembellished.
]

{ #category : #'tests - highlighting' }
MiSourceTextBrowserTest >> testHighlightNoAnchor [
	| entity |
	entity := FamixStClass new
		name: 'aClass'.
	FamixStMethod new
		name: 'aMethod' ;
		parentType: entity.
		
	browser followEntity: entity.

	self assert: browser sourceText equals: 'There is no source code to show for aClass'.
	self deny: browser sourceText unembellished.
	self deny: (browser sourceText attributesAt: 1) isEmpty.
]

{ #category : #'tests - highlighting' }
MiSourceTextBrowserTest >> testHighlightNoChild [
	| entity |
	entity := FamixStClass new
		name: 'aClass' ;
		sourceAnchor: (self stubIndexedAnchorText: 
'code of aClass {
	code of aMethod()
}' ).
		
	browser followEntity: entity.
	
	self assert: browser sourceText unembellished 
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
	self assert: browser sourceText equals: 'There is no source code to show for TestClass'

]

{ #category : #'tests - externalEditor' }
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
