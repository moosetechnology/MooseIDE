"
This class provides the highlight system for MiCoUsageMapBuilder
"
Class {
	#name : #MiCoHighlightManager,
	#superclass : #RSInteraction,
	#instVars : [
		'selectedInnerBox',
		'highlight'
	],
	#category : #'MooseIDE-CoUsageMap-Roassal3'
}

{ #category : #'accessing - computed' }
MiCoHighlightManager >> defaultBoxBorder [
	^  RSBorder new color: Color black; joinMiter
]

{ #category : #selection }
MiCoHighlightManager >> deselectInnerBox: evt [
	selectedInnerBox ifNil: [ ^ self ].
	evt canvas 
		propertyAt: highlight propertyKey 
		put: (highlight highlightShapesFor: selectedInnerBox).
	selectedInnerBox := nil.
	highlight unhighlightRecordedShapes: evt shape.
	evt signalUpdate.
]

{ #category : #highlighting }
MiCoHighlightManager >> highlight: evt [
	selectedInnerBox 
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
	self deselectInnerBox: evt.
	highlight doHighlight: evt shape.
	selectedInnerBox := evt shape.
]

{ #category : #'accessing - computed' }
MiCoHighlightManager >> selectedBoxBorder [
	^ RSBorder new 
		color: Color orange;
		width: 3;
		joinMiter;
		yourself.
]

{ #category : #highlighting }
MiCoHighlightManager >> unhighlight: evt [
	selectedInnerBox
		ifNil: [ evt shape border: self defaultBoxBorder ]
		ifNotNil: [ 
			
		].
]
