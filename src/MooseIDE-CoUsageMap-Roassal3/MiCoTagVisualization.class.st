"
TODO
"
Class {
	#name : #MiCoTagVisualization,
	#superclass : #RSAbstractContainerBuilder,
	#instVars : [
		'tags',
		'conflictTag'
	],
	#category : #'MooseIDE-CoUsageMap-Roassal3'
}

{ #category : #adding }
MiCoTagVisualization >> addTag: aMiCoTag [ 
	tags add: aMiCoTag
]

{ #category : #hooks }
MiCoTagVisualization >> boxLabelExtent [
	^ 25@15
]

{ #category : #public }
MiCoTagVisualization >> conflicTag: aString tags: aCollection colorPalette: aNSOrdinalScale [ 
	self conflictTag: (MiCoTag new name: aString; yourself).
	aCollection do: [:str |
		self addTag: (MiCoTag new name: str; yourself) ].
	{ conflictTag  }, self tags do: [ :tag |
		tag color: (aNSOrdinalScale scale: tag) ]
]

{ #category : #accessing }
MiCoTagVisualization >> conflictTag [
	^ conflictTag
]

{ #category : #accessing }
MiCoTagVisualization >> conflictTag: aMiCoTag [ 
	conflictTag := aMiCoTag
]

{ #category : #public }
MiCoTagVisualization >> conflictTag: aString tags: aCollection [ 
	self conflicTag: aString tags: aCollection colorPalette: NSScale category20
]

{ #category : #initialization }
MiCoTagVisualization >> initialize [
	super initialize.
	tags := OrderedCollection new: 5
]

{ #category : #hooks }
MiCoTagVisualization >> legendShapeRenderIn: aCanvas [
	| legendShape |
	legendShape := shapes asShape
		padding: 10;
		color: (Color white alpha: 0.8);
		isFixed: true;
		border: (RSBorder new color: Color lightGray; width: 0.5);
		when: RSMouseClick send: #toggleLegend: to: self;
		yourself.
	aCanvas 
		when: RSExtentChangedEvent 
		do: [ :evt | self moveLegend: legendShape toCornerIn: evt canvas ].
	
	aCanvas addShape: legendShape.
	self moveLegend: legendShape toCornerIn: aCanvas.
]

{ #category : #hooks }
MiCoTagVisualization >> moveLegend: legendShape toCornerIn: aCanvas [
	RSLocation new
		inner;
		top;
		right;
		offset: -10 @ 10;
		move: legendShape on: (0 asPoint corner: aCanvas extent).

]

{ #category : #public }
MiCoTagVisualization >> removeOldLegend [
	| canvas legendShape |
	
	canvas := self canvas.
	legendShape := canvas fixedShapes 
		detect: [ :shape | shape class = RSComposite ] 
		ifNone: [ nil ].
	legendShape ifNil: [ ^ self ].
	conflictTag := nil.
	tags := OrderedCollection new.
	canvas removeInteractionIfPresent: self class.
	legendShape remove.
	

]

{ #category : #hooks }
MiCoTagVisualization >> renderIn: aCanvas [
	| tagShapes |
	shapes := RSGroup new.
	
	shapes add: self titleShape.
	conflictTag ifNotNil: [ shapes add: (self tagShapeFor: conflictTag) ].
	tagShapes := self tags collect: [ :tag | self tagShapeFor: tag ].
	shapes addAll: tagShapes.
	shapes add: self shapeBoxDescription.
	
	RSVerticalLineLayout new
		gapSize: 2;
		on: shapes.
	self legendShapeRenderIn: aCanvas.
]

{ #category : #hooks }
MiCoTagVisualization >> shapeBoxDescription [

	| box marker arrow label |
	box := RSBox new
		border: (RSBorder new color: Color black; width: 2);
		extent: self boxLabelExtent;
		color: Color white;
		yourself.
	marker := RSShapeFactory arrow
		size: 10;
		color: Color black;
		yourself.
	arrow := RSLine new
		startPoint: 0@0;
		endPoint: self boxLabelExtent x @ 0;
		color: Color black;
		marker: marker;
		yourself.
	label := RSLabel new
		text: 'Number of accesses';
		color: Color black;
		yourself. 
	RSVerticalLineLayout new gapSize: 5; on: { box. arrow }.
	RSHorizontalLineLayout new gapSize: 5; on: { { box. arrow } asGroup. label }.
	^ { box. arrow. label } asGroup asShape
		
]

{ #category : #accessing }
MiCoTagVisualization >> tagNamed: aString [ 
	^ self tags detect: [ :tag | tag name = aString ] ifNone: [ nil ]
]

{ #category : #hooks }
MiCoTagVisualization >> tagShapeFor: aMiCoTag [ 
	| label box |
	label := RSLabel new
		text: aMiCoTag name;
		color: Color black;
		yourself.
	box := RSBox new
		extent: self boxLabelExtent;
		color: aMiCoTag color;
		yourself.
	RSHorizontalLineLayout new gapSize: 5; on: { box. label }.
	^ { box. label } asGroup asShape
]

{ #category : #accessing }
MiCoTagVisualization >> tags [
	^ tags
]

{ #category : #hooks }
MiCoTagVisualization >> titleShape [
	^ RSLabel new
		text: 'Legend';
		color: Color black;
		fontSize: 12;
		bold;
		yourself 
]

{ #category : #events }
MiCoTagVisualization >> toggleLegend: evt [

	| legendShape isCollapse |
	legendShape := evt shape.
	isCollapse := legendShape children size = 1.
	legendShape children copy do: [:child | child remove ].
	isCollapse 
		ifTrue: [ legendShape addAll: shapes ]
		ifFalse: [ legendShape add: self titleShape ].
	
	legendShape adjustToChildren.
	legendShape padding: 10.
	self moveLegend: legendShape toCornerIn: evt canvas.
	evt signalUpdate.
]
