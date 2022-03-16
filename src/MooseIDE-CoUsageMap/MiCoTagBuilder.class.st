"
This builder from roassal creates shapes that represent tags
"
Class {
	#name : #MiCoTagBuilder,
	#superclass : #RSAbstractContainerBuilder,
	#instVars : [
		'tags',
		'conflictTag'
	],
	#category : #'MooseIDE-CoUsageMap-Roassal3'
}

{ #category : #adding }
MiCoTagBuilder >> addTag: aMiCoTag [ 
	tags add: aMiCoTag
]

{ #category : #hooks }
MiCoTagBuilder >> boxLabelExtent [
	^ 25@15
]

{ #category : #public }
MiCoTagBuilder >> conflicTag: aString tags: aCollection colorPalette: aNSOrdinalScale [ 
	self conflictTag: (MiCoTag new name: aString; yourself).
	aCollection do: [:str |
		self addTag: (MiCoTag new name: str; yourself) ].
	{ conflictTag  }, self tags do: [ :tag |
		tag color: (aNSOrdinalScale scale: tag) ]
]

{ #category : #accessing }
MiCoTagBuilder >> conflictTag [
	^ conflictTag
]

{ #category : #accessing }
MiCoTagBuilder >> conflictTag: aMiCoTag [
	conflictTag := aMiCoTag
]

{ #category : #public }
MiCoTagBuilder >> conflictTag: aString tags: aCollection [ 
	self conflicTag: aString tags: aCollection colorPalette: NSScale category20
]

{ #category : #highlighting }
MiCoTagBuilder >> highlight: evt [
	| shape |
	self unhighlight: evt.
	shape := evt shape.
	shape border: (RSBorder new width: 2; color: Color gray).
	evt canvas propertyAt: #tagCheck put: shape.
	evt signalUpdate.
]

{ #category : #hooks }
MiCoTagBuilder >> iconFor: aMiCoTag [
	^ self iconNamed: (aMiCoTag isHidden  
		ifTrue: [ #checkboxUnselected ]
		ifFalse: [ #checkboxSelected ])
]

{ #category : #initialization }
MiCoTagBuilder >> initialize [
	super initialize.
	tags := OrderedCollection new: 5
]

{ #category : #hooks }
MiCoTagBuilder >> legendDo: aShape [
	| highlight |
	highlight := RSHighlightable new
		when: RSHighlightEvent do: [ :evt | 
			evt shape border color: Color blue.
			evt signalUpdate ];
		when: RSUnHighlightEvent do: [ :evt | 
			evt shape border color: Color lightGray.
			 evt signalUpdate ].
	aShape shapes last translateBy: 0@15.
	aShape
		adjustToChildren;
		padding: 10;
		color: ((Color colorFrom: 'f4f4f4') alpha: 0.9);
		border: (RSBorder new color: Color lightGray; width: 0.5);
		addInteraction: highlight
]

{ #category : #accessing }
MiCoTagBuilder >> legendTitle [
	^ 'Legend'
]

{ #category : #public }
MiCoTagBuilder >> removeOldLegend [
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
MiCoTagBuilder >> renderIn: aCanvas [
	| tagShapes legend |
	legend := RSLegend new
		container: aCanvas;
		yourself.
	shapes := RSGroup new.
	conflictTag ifNotNil: [ shapes add: (self tagShapeFor: conflictTag) ].
	tagShapes := self tags collect: [ :tag | self tagShapeFor: tag ].
	shapes addAll: tagShapes.
	shapes add: self shapeBoxDescription.
	legend shapes ifNotNil:[ :collection | collection addAll: shapes].
	legend layout vertical gapSize: 2.
	legend defaultTitle
		color: Color black;
		fontSize: 12.
	legend 
		legendDo: [ :l | self legendDo: l ];
		beFixedWithTitle: self legendTitle;
		build.
]

{ #category : #hooks }
MiCoTagBuilder >> shapeBoxDescription [
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
	RSHorizontalLineLayout new gapSize: 5; on: { label. { box. arrow } asGroup }.
	^ { box. arrow. label } asGroup asShape
]

{ #category : #accessing }
MiCoTagBuilder >> tagNamed: aString [ 
	^ self tags detect: [ :tag | tag name = aString ] ifNone: [ nil ]
]

{ #category : #hooks }
MiCoTagBuilder >> tagShapeFor: aMiCoTag [ 
	| label box check shape |
	label := RSLabel new
		text: aMiCoTag name;
		color: Color black;
		yourself.
	box := RSBox new
		extent: self boxLabelExtent;
		color: aMiCoTag color;
		yourself.
	check := RSBitmap new
		model: aMiCoTag;
		form: (self iconFor: aMiCoTag);
		when: RSMouseEnter send: #highlight: to: self; 
		when: RSMouseLeave send: #unhighlight: to: self; 
		when: RSMouseClick send: #toggleTag: to: self; 
		yourself.
	shape := { check. box. label } asGroup asShape.
	aMiCoTag == conflictTag ifTrue: [ 
		check announcer: nil.
		check form: (self iconNamed: #empty) ].
		
	RSHorizontalLineLayout new gapSize: 5; alignMiddle; on: shape children.
	shape adjustToChildren.
	^ shape
]

{ #category : #accessing }
MiCoTagBuilder >> tags [
	^ tags
]

{ #category : #events }
MiCoTagBuilder >> toggleTag: evt [
	| shape tag |
	shape := evt shape.
	tag := shape model.
	tag toggleVisibility.
	shape form: (self iconFor: tag).
	evt signalUpdate.
	
	
]

{ #category : #highlighting }
MiCoTagBuilder >> unhighlight: evt [
	evt canvas
		propertyAt: #tagCheck
		ifPresent: [ :s | s border: nil ];
		removeKey: #tagCheck.
	evt signalUpdate.
]
