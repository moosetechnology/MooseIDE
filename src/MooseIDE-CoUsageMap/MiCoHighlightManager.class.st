"
This class provides the highlight system for MiCoUsageMapBuilder
There are two kinds of Highlights:
- highlight: when the mouse enters or leaves an inner box
- select: when there is a mouse click on an inner box (kind-of permanent highlight)
"
Class {
	#name : #MiCoHighlightManager,
	#superclass : #RSInteraction,
	#instVars : [
		'highlight',
		'mapBuilder'
	],
	#category : #'MooseIDE-CoUsageMap-Roassal3'
}

{ #category : #accessing }
MiCoHighlightManager >> defaultBoxBorder [
	^  RSBorder new color: Color black; joinMiter
]

{ #category : #selection }
MiCoHighlightManager >> deselectInnerBox: evt [
	"called when clicking on a shape ('permanent' highlight)"

	evt canvas 
		propertyAt: highlight propertyKey 
		put: (highlight highlightShapesFor: mapBuilder selectedInnerShape).
	mapBuilder selectedInnerShape: nil.
	highlight unhighlightRecordedShapes: evt shape.
	evt signalUpdate.
]

{ #category : #highlighting }
MiCoHighlightManager >> highlight: evt [
	"called on mouse entering a shape"

	mapBuilder selectedInnerEntity
		ifNil: [ evt shape border: self selectedBoxBorder ]
		ifNotNil: [
		].
]

{ #category : #initialization }
MiCoHighlightManager >> highlightInteraction [
	^ RSHighlightable new
		highlightShapes: [ :shape | shape canvas deepShapesFromModel: shape model ];
		when: RSHighlightEvent send: #highlight: to: self;
		when: RSUnHighlightEvent send: #unhighlight: to: self;
		yourself
		
]

{ #category : #initialization }
MiCoHighlightManager >> initialize [
	super initialize.
	highlight := self highlightInteraction.
	
]

{ #category : #accessing }
MiCoHighlightManager >> mapBuilder [
	^mapBuilder
]

{ #category : #accessing }
MiCoHighlightManager >> mapBuilder: aCoUsageMapBuilder [
	mapBuilder := aCoUsageMapBuilder
]

{ #category : #hooks }
MiCoHighlightManager >> onShape: aShape [
	(aShape isShape not or: [aShape isComposite]) ifTrue: [ 
		aShape when: RSMouseClick send: #deselectInnerBox: to: self.
		^ self ].
	aShape 
		addInteraction: highlight;
		when: RSMouseLeftClick send: #selectInnerBox: to: self.
]

{ #category : #selection }
MiCoHighlightManager >> selectInnerBox: evt [
	"called when clicking on a shape ('permanent' highlight)"

	mapBuilder selectedInnerEntity ifNotNil: [
		self deselectInnerBox: evt ].
	highlight doHighlight: evt shape.
	mapBuilder selectedInnerShape: evt shape.
]

{ #category : #accessing }
MiCoHighlightManager >> selectedBoxBorder [
	^ RSBorder new 
		color: Color orange;
		width: 3;
		joinMiter;
		yourself.
]

{ #category : #highlighting }
MiCoHighlightManager >> unhighlight: evt [
	"called on mouse leaving a shape"

	mapBuilder selectedInnerEntity
		ifNil: [ evt shape border: self defaultBoxBorder ]
		ifNotNil: [ 
		].
]
