"
Builds a legend for visualization with all tags in it.
The legend allows to check/uncheck each tag individually
"
Class {
	#name : #MiCoTagLegendBuilder,
	#superclass : #RSAbstractContainerBuilder,
	#instVars : [
		'tags',
		'mapBuilder'
	],
	#category : #'MooseIDE-CoUsageMap-Roassal3'
}

{ #category : #adding }
MiCoTagLegendBuilder >> addTag: aTag [
	self tags add: aTag
]

{ #category : #hooks }
MiCoTagLegendBuilder >> boxLabelExtent [
	^ 25@15
]

{ #category : #hooks }
MiCoTagLegendBuilder >> checkBoxFor: aTag [
	^ self iconNamed: (aTag isHidden  
		ifTrue: [ #checkboxUnselected ]
		ifFalse: [ #checkboxSelected ])
]

{ #category : #highlighting }
MiCoTagLegendBuilder >> highlightLegend: evt [
	| shape |
	self unhighlight: evt.
	shape := evt shape.
	shape border: (RSBorder new width: 2; color: Color gray).
	evt canvas propertyAt: #tagCheck put: shape.
	evt signalUpdate.
]

{ #category : #hooks }
MiCoTagLegendBuilder >> legendBottomLine [
	"explains the form of the innerBoxes (width based on number of dependencies)"
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
		text: 'Number of links';
		color: Color black;
		yourself. 
	RSVerticalLineLayout new gapSize: 5; on: { box. arrow }.
	RSHorizontalLineLayout new gapSize: 5; on: { label. { box. arrow } asGroup }.
	^ { box. arrow. label } asGroup asShape
]

{ #category : #hooks }
MiCoTagLegendBuilder >> legendDo: aShape [
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
		when: RSMouseMove send: #yourself to: self;
		color: ((Color colorFrom: 'f4f4f4') alpha: 0.9);
		border: (RSBorder new color: Color lightGray; width: 0.5);
		addInteraction: highlight
]

{ #category : #hooks }
MiCoTagLegendBuilder >> legendTagLine: aTag [ 
	| label icon checkBox line |
	checkBox := RSBitmap new
		model: aTag;
		form: (self checkBoxFor: aTag);
		when: RSMouseEnter send: #highlightLegend: to: self; 
		when: RSMouseLeave send: #unhighlightLegend: to: self; 
		when: RSMouseClick send: #toggleTag: to: self; 
		yourself.
	icon := RSBitmap new form: (mapBuilder iconForTag: aTag).
	label := RSLabel new
		text: aTag name;
		color: Color black;
		yourself.

	line := { checkBox. icon. label } asGroup asShape.
	RSHorizontalLineLayout new
		gapSize: 5 ;
		alignMiddle ;
		on: line children.
	line adjustToChildren.

	^ line
]

{ #category : #accessing }
MiCoTagLegendBuilder >> legendTitle [
	^ 'Legend'
]

{ #category : #accessing }
MiCoTagLegendBuilder >> mapBuilder [
	self flag: 'interactions with MiCoUsageMapBuilder should go through specModel ?'.
	^ mapBuilder
]

{ #category : #accessing }
MiCoTagLegendBuilder >> mapBuilder: aMiCoUsageMapBuilder [
	mapBuilder := aMiCoUsageMapBuilder
]

{ #category : #public }
MiCoTagLegendBuilder >> removeOldLegend [
	| canvas legendShape |
	canvas := self canvas.
	legendShape := canvas fixedShapes 
		detect: [ :shape | shape class = RSComposite ] 
		ifNone: [ nil ].
	legendShape ifNil: [ ^ self ].
	tags := nil.
	canvas removeInteractionIfPresent: self class.
	legendShape remove.
	

]

{ #category : #hooks }
MiCoTagLegendBuilder >> renderIn: aCanvas [
	| tagShapes legend |
	legend := RSLegend new
		container: aCanvas;
		yourself.
	shapes := RSGroup new.
	tagShapes := self tags collect: [ :tag | self legendTagLine: tag ].
	shapes addAll: tagShapes.
	shapes add: self legendBottomLine.
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

{ #category : #accessing }
MiCoTagLegendBuilder >> specModel [
	^ mapBuilder specModel
]

{ #category : #accessing }
MiCoTagLegendBuilder >> tagNamed: aString [ 
	^ self tags detect: [ :tag | tag name = aString ] ifNone: [ nil ]
]

{ #category : #accessing }
MiCoTagLegendBuilder >> tags [
	^tags ifNil: [tags := self specModel tagList]
]

{ #category : #hooks }
MiCoTagLegendBuilder >> toggleTag: evt [
	| checkBox tag |
	checkBox := evt shape.
	tag := checkBox model.
	self flag: 'Hidding tag is part of its normal API ?!?'.
	tag toggleVisibility.
	checkBox form: (self checkBoxFor: tag).
	mapBuilder updateShapeColors.
	evt signalUpdate.
	
	
]

{ #category : #highlighting }
MiCoTagLegendBuilder >> unhighlightLegend: evt [
	evt canvas
		propertyAt: #tagCheck
		ifPresent: [ :s | s border: nil ];
		removeKey: #tagCheck.
	evt signalUpdate.
]
