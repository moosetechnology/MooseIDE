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
MiSourceTextBrowserTest >> testHighlightChildWithImmediateTextAnchor [
	| entity displayedText |

	entity := FamixStClass new
		name: 'aClass' ;
		sourceAnchor: (self stubImmediateAnchorText: 
'Class {
	#name : ''aClass'',
	#package : ''For-Testing''
}

aClass >> aMethod()
	"nothing"
').
	FamixStMethod new
		name: 'aMethod' ;
		parentType: entity ;
		sourceAnchor: (self stubImmediateAnchorText: '	code of aMethod()' ).
		
	browser followEntity: entity.

	displayedText := browser textRenderer formatedText.
	self deny: displayedText unembellished.
	self assert: (displayedText attributesAt: 30) isEmpty.
	self deny: (displayedText attributesAt: 70) isEmpty.
	self assert: ((displayedText attributesAt: 70) anySatisfy: [ :att | att mayActOnEvent: MouseEvent new ]).
	self assert: ((displayedText attributesAt: 70) anySatisfy: [ :att | (att class = TextEmphasis) and: [ att set ] ]).
]

{ #category : #'tests - highlighting' }
MiSourceTextBrowserTest >> testHighlightChildWithIndexedFileAnchor [
	| entity displayedText |
	entity := FamixJavaClass new
		name: 'aClass' ;
		sourceAnchor: (self stubIndexedAnchorText: 
'code of aClass {
	code of aMethod()
}').
	FamixJavaMethod new
		name: 'aMethod' ;
		parentType: entity ;
		sourceAnchor: (self stubIndexedAnchorText: #whatever positions: 18@36 ).
		
	browser followEntity: entity.

	displayedText := browser textRenderer formatedText.
	self deny: displayedText unembellished.
	self assert: (displayedText attributesAt: 20) isEmpty.
	self deny: (displayedText attributesAt: 30) isEmpty.
	self assert:
		((displayedText attributesAt: 30) anySatisfy: [ :att | att mayActOnEvent: MouseEvent new ]).
	self assert:
		((displayedText attributesAt: 30) anySatisfy: [ :att | (att class = TextEmphasis) and: [ att set ] ]).
]

{ #category : #'tests - highlighting' }
MiSourceTextBrowserTest >> testHighlightChildWithNoAnchor [
	| entity displayedText |
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

	displayedText := browser textRenderer formatedText.
	self deny: displayedText unembellished.
	self assert: (displayedText attributesAt: 20) isEmpty.
	self assert: (displayedText attributesAt: 30) isEmpty.

]

{ #category : #'tests - highlighting' }
MiSourceTextBrowserTest >> testHighlightJavaComment [

	| entity displayedText |
	entity := FamixJavaClass new
		          name: 'aClass';
		          sourceAnchor: (self stubIndexedAnchorText: 'code of aClass {
	/* this is a Java comment */
}').
	FamixJavaComment new
		sourceAnchor: (self stubIndexedAnchorText: 'this is a Java comment');
		commentedEntity: entity;
		sourceAnchor: (self stubIndexedAnchorText: #whatever positions: 19 @ 46).

	browser followEntity: entity.

	displayedText := browser textRenderer formatedText.
	self deny: displayedText unembellished.
	self assert: (displayedText attributesAt: 15) isEmpty.
	self deny: (displayedText attributesAt: 25) isEmpty.
	self assert: ((displayedText attributesAt: 25) noneSatisfy: [ :att | att mayActOnEvent: MouseEvent new ]).
	self assert: ((displayedText attributesAt: 25) anySatisfy: [ :att | att class = TextColor and: [ att color = Color gray ] ])
]

{ #category : #'tests - highlighting' }
MiSourceTextBrowserTest >> testHighlightNoAnchor [
	| entity displayedText |
	entity := FamixStClass new
		name: 'aClass'.
	FamixStMethod new
		name: 'aMethod' ;
		parentType: entity.
		
	browser followEntity: entity.

	displayedText := browser textRenderer formatedText.
	self assert: displayedText equals: 'There is no source code to show for aClass'.
	self deny: displayedText unembellished.
	self deny: (displayedText attributesAt: (displayedText size)) isEmpty.
]

{ #category : #'tests - highlighting' }
MiSourceTextBrowserTest >> testHighlightNoChild [
	| entity displayedText |
	entity := FamixStClass new
		name: 'aClass' ;
		sourceAnchor: (self stubIndexedAnchorText: 
'code of aClass {
	code of aMethod()
}' ).
		
	browser followEntity: entity.

	displayedText := browser textRenderer formatedText.
	self deny: displayedText unembellished.
	self assert: (displayedText attributesAt: 20) isEmpty.
	self assert: (displayedText attributesAt: 30) isEmpty.

]

{ #category : #'tests - highlighting' }
MiSourceTextBrowserTest >> testHighlightStComment [

	| entity displayedText |
	entity := FamixStClass new
		          name: 'aClass';
		          sourceAnchor: (self stubIndexedAnchorText: 'code of aClass {
	"this is a Pharo comment"
}').
	FamixStComment new
		sourceAnchor: (self stubIndexedAnchorText: 'this is a Pharo comment');
		commentedEntity: entity.

	browser followEntity: entity.

	displayedText := browser textRenderer formatedText.
	self deny: displayedText unembellished.
	self assert: (displayedText attributesAt: 15) isEmpty.
	self deny: (displayedText attributesAt: 25) isEmpty.
	self assert: ((displayedText attributesAt: 25) noneSatisfy: [ :att | att mayActOnEvent: MouseEvent new ]).
	self assert: ((displayedText attributesAt: 25) anySatisfy: [ :att | att class = TextColor and: [ att color = Color gray ] ])
]

{ #category : #'tests - highlighting' }
MiSourceTextBrowserTest >> testHighlightStCommentForClass [
	"class comment appear before the class in Pharo"

	| entity displayedText |
	entity := FamixStClass new
		          name: 'aClass';
		          sourceAnchor: (self stubIndexedAnchorText: '"this is a Pharo class comment"
code of aClass {
}').
	FamixStComment new
		sourceAnchor: (self stubIndexedAnchorText: 'this is a Pharo class comment');
		commentedEntity: entity.

	browser followEntity: entity.

	displayedText := browser textRenderer formatedText.
	self deny: displayedText unembellished.
	self assert: (displayedText attributesAt: 35) isEmpty.
	self deny: (displayedText attributesAt: 20) isEmpty.
	self assert: ((displayedText attributesAt: 20) noneSatisfy: [ :att | att mayActOnEvent: MouseEvent new ]).
	self assert: ((displayedText attributesAt: 20) anySatisfy: [ :att | att class = TextColor and: [ att color = Color gray ] ])
]

{ #category : #tests }
MiSourceTextBrowserTest >> testMiSelectedItem [

	| entityToSelect |
	self assert: browser miSelectedItem isNil.

	entityToSelect := FamixStClass named: 'TestClass'.
	browser followEntity: entityToSelect.

	self assert: browser miSelectedItem equals: entityToSelect
]

{ #category : #'tests - tags' }
MiSourceTextBrowserTest >> testSelectedTagSetAndGet [
	| model entity tag |
	model := FamixRepTestModel new.
	tag := model tagNamed: 'aTag'.
	entity := FamixRepTestClass new name: 'aClass' ; mooseModel: model ; yourself.

	browser followEntity: entity.
	browser selectedTag: tag.
	self assert: browser selectedTag equals: tag
]

{ #category : #'tests - opening' }
MiSourceTextBrowserTest >> testSettingsAction [

	self assert: browser hasSettings
]

{ #category : #tests }
MiSourceTextBrowserTest >> testShowNoSourceCodeMessage [

	browser receiveEntity: (FamixStClass named: 'TestClass').
	self
		assert: browser specModel displayedText
		equals: 'There is no source code to show for TestClass'
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
