Class {
	#name : 'MiSourceTextRendererModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'rendererModel'
	],
	#category : 'MooseIDE-Tests-Browsers',
	#package : 'MooseIDE-Tests',
	#tag : 'Browsers'
}

{ #category : 'running' }
MiSourceTextRendererModelTest >> browserClass [
	^ MiSourceTextBrowser
]

{ #category : 'running' }
MiSourceTextRendererModelTest >> setUp [
	super setUp.

	rendererModel := MiSourceTextRendererModel new.
	rendererModel renderer: Mock new
]

{ #category : 'running' }
MiSourceTextRendererModelTest >> stubImmediateAnchorText: aString [
	^FamixTest1SourceTextAnchor new
		source: aString 
		yourself.

]

{ #category : 'running' }
MiSourceTextRendererModelTest >> stubIndexedAnchorText: aString [
	^self stubIndexedAnchorText: aString positions: 1@(aString size)
]

{ #category : 'running' }
MiSourceTextRendererModelTest >> stubIndexedAnchorText: aString positions: startEndPos [
	^FamixStubIndexedFileAnchor new
		source: aString ;
		startPos: startEndPos x ;
		endPos: startEndPos y ;
		yourself.

]

{ #category : 'tests - highlighting' }
MiSourceTextRendererModelTest >> testDoNotHighlightChildren [
	| entity |

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

	rendererModel shouldHighlightChildren: false.
	rendererModel renderTextFor: entity.

	self assert: rendererModel highlights size equals: 0
]

{ #category : 'tests - highlighting' }
MiSourceTextRendererModelTest >> testHighlightChildWithImmediateTextAnchor [
	| entity |

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
		
	rendererModel renderTextFor: entity.

	self assert: rendererModel highlights size equals: 2.
	rendererModel highlights do: [ :highlight |
		self assert: highlight class equals: MiSourceTextIdentifierHighlight.
	].

	self assertCollection: (rendererModel highlights collect: #from) hasSameElements: #(19 67)

]

{ #category : 'tests - highlighting' }
MiSourceTextRendererModelTest >> testHighlightChildWithIndexedFileAnchor [
	| entity |
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
		
	rendererModel renderTextFor: entity.

	self assert: rendererModel highlights size equals: 2.
	rendererModel highlights do: [ :highlight |
		self assert: highlight class equals: MiSourceTextIdentifierHighlight.
	].

	self assertCollection: (rendererModel highlights collect: #from) hasSameElements: #(9 27)

]

{ #category : 'tests - highlighting' }
MiSourceTextRendererModelTest >> testHighlightChildWithNoAnchor [
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

	rendererModel renderTextFor: entity.

	self assert: rendererModel highlights size equals: 2.
	rendererModel highlights do: [ :highlight |
		self assert: highlight class equals: MiSourceTextIdentifierHighlight
	].

	"one highlight has an interval, the other not"
	self assert: (rendererModel highlights anySatisfy: #hasInterval).
	self assert: (rendererModel highlights anySatisfy: [ :highlight | highlight hasInterval not]).

]

{ #category : 'tests - highlighting' }
MiSourceTextRendererModelTest >> testHighlightJavaComment [

	| entity highlight |
	entity := FamixJavaClass new
		name: 'aClass';
		sourceAnchor: (self stubIndexedAnchorText: 'code of aClass {
	/* this is a Java comment */
}').
	FamixJavaComment new
		sourceAnchor: (self stubIndexedAnchorText: 'this is a Java comment');
		commentedEntity: entity;
		sourceAnchor:
			(self stubIndexedAnchorText: #whatever positions: 19 @ 46).

	rendererModel renderTextFor: entity.

	self assert: rendererModel highlights size equals: 2.

	highlight := rendererModel highlights
		detect: [ :hghlght | hghlght class = MiSourceTextCommentHighlight ]
		ifNone: [ self fail: 'Should have one MiSourceTextCommentHighlight' ].

	self assert: highlight from equals: 19
]

{ #category : 'tests - highlighting' }
MiSourceTextRendererModelTest >> testHighlightJavaKeywords [

	| entity positions |
	entity := FamixJavaClass new
		name: 'aClass' ;
		mooseModel: FamixJavaModel new ;
		sourceAnchor: (self stubIndexedAnchorText: 'public class aClass { }').
	entity mooseModel sourceLanguage: FamixJavaSourceLanguage new.

	rendererModel renderTextFor: entity.

	self assert: rendererModel highlights size equals: 3.

	self assert: (rendererModel highlights count: [ :hghlght | hghlght class = MiSourceTextKeywordHighlight ]) equals: 2.

	positions := rendererModel highlights
		select: [ :hghlght | hghlght class = MiSourceTextKeywordHighlight ]
		thenCollect: [ :hghlght | hghlght from ].
	
	self assertCollection: positions hasSameElements: #(1 8)
]

{ #category : 'tests - highlighting' }
MiSourceTextRendererModelTest >> testHighlightNoAnchor [
	| entity |
	entity := FamixStClass new
		name: 'aClass'.
	FamixStMethod new
		name: 'aMethod' ;
		parentType: entity.
		
	rendererModel renderTextFor: entity.

	self assert: rendererModel displayedText equals: 'There is no source code to show for aClass'.
	self assert: rendererModel highlights anyOne class equals: MiSourceTextErrorHighlight
]

{ #category : 'tests - highlighting' }
MiSourceTextRendererModelTest >> testHighlightNoChild [
	| entity |
	entity := FamixStClass new
		name: 'aClass' ;
		sourceAnchor: (self stubIndexedAnchorText: 
'code of aClass {
	code of aMethod()
}' ).
		
	rendererModel renderTextFor: entity.

	self assert: rendererModel highlights size equals: 1.
	self assert: rendererModel highlights anyOne class equals: MiSourceTextIdentifierHighlight.
	self assert: rendererModel highlights anyOne from equals: 9.
	self assert: rendererModel highlights anyOne to   equals: 14
]

{ #category : 'tests - highlighting' }
MiSourceTextRendererModelTest >> testHighlightNoKeywordInComment [

	| entity |
	entity := FamixJavaClass new
		name: 'aClass' ;
		mooseModel: FamixJavaModel new ;
		sourceAnchor: (self stubIndexedAnchorText: 'code of aClass {
	/* this word "class" is not a keyword */
}').
	entity mooseModel sourceLanguage: FamixJavaSourceLanguage new.
	FamixJavaComment new
		sourceAnchor: (self stubIndexedAnchorText: 'this word "class" is not a keyword');
		commentedEntity: entity;
		sourceAnchor: (self stubIndexedAnchorText: #whatever positions: 19 @ 58).

	rendererModel renderTextFor: entity.

	self assert: rendererModel highlights size equals: 2.
	self assert: (rendererModel highlights noneSatisfy: [ :hghlght | hghlght class = MiSourceTextKeywordHighlight ])
]

{ #category : 'tests - highlighting' }
MiSourceTextRendererModelTest >> testHighlightStComment [

	| entity highlight |
	entity := FamixStClass new
		          name: 'aClass';
		          sourceAnchor: (self stubIndexedAnchorText: 'code of aClass {
	"this is a Pharo comment"
}').
	FamixStComment new
		sourceAnchor: (self stubIndexedAnchorText: 'this is a Pharo comment');
		commentedEntity: entity.

	rendererModel renderTextFor: entity.

	self assert: rendererModel highlights size equals: 2.

	highlight := rendererModel highlights
		detect: [ :hghlght | hghlght class = MiSourceTextCommentHighlight ]
		ifNone: [ self fail: 'Should have one MiSourceTextCommentHighlight' ].

	self assert: highlight from equals: 20
]

{ #category : 'tests - highlighting' }
MiSourceTextRendererModelTest >> testHighlightStCommentForClass [
	"class comment appear before the class in Pharo"

	| entity highlight |
	entity := FamixStClass new
		          name: 'aClass';
		          sourceAnchor: (self stubIndexedAnchorText: '"this is a Pharo class comment"
code of aClass {
}').
	FamixStComment new
		sourceAnchor: (self stubIndexedAnchorText: 'this is a Pharo class comment');
		commentedEntity: entity.

	rendererModel renderTextFor: entity.

	self assert: rendererModel highlights size equals: 2.

	highlight := rendererModel highlights
		detect: [ :hghlght | hghlght class = MiSourceTextCommentHighlight ]
		ifNone: [ self fail: 'Should have one MiSourceTextCommentHighlight' ].

	self assert: highlight from equals: 2
]

{ #category : 'tests' }
MiSourceTextRendererModelTest >> testShowNoSourceCodeMessage [

	rendererModel renderTextFor: (FamixStClass named: 'TestClass').

	self
		assert: rendererModel displayedText
		equals: 'There is no source code to show for TestClass'.
]
