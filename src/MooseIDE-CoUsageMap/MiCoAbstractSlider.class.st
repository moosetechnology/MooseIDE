"
Abstract class for sliders made with Roassal

TODO: Make generic for whole MooseIDE ?
"
Class {
	#name : #MiCoAbstractSlider,
	#superclass : #RSAbstractContainerBuilder,
	#instVars : [
		'backLine',
		'rangeLine',
		'quantum',
		'min',
		'max',
		'model',
		'scale'
	],
	#category : #'MooseIDE-CoUsageMap-Sliders'
}

{ #category : #hooks }
MiCoAbstractSlider >> backLine [
	| paint width |
	backLine ifNotNil: [ ^ backLine ].
	width := self lineWidth.
	paint := self backPaint.
	paint 
		start: 0@ width / -2;
		stop: 0 @ width / 2.
	^ backLine := RSLine new
		startPoint: 0@0;
		endPoint: 100@0;
		width: width;
		color: paint;
		capRound;
		yourself
		
]

{ #category : #accessing }
MiCoAbstractSlider >> backPaint [
	^ LinearGradientPaint fromArray:
		{0->'cfd9df'. 
		1->'e2ebf0' }.
]

{ #category : #accessing }
MiCoAbstractSlider >> lineGap [
	^ 25
]

{ #category : #accessing }
MiCoAbstractSlider >> lineWidth [
	^ 15
]

{ #category : #accessing }
MiCoAbstractSlider >> max [
	^ max
]

{ #category : #accessing }
MiCoAbstractSlider >> max: aNumber [
	max := aNumber
]

{ #category : #accessing }
MiCoAbstractSlider >> min [
	^ min
]

{ #category : #accessing }
MiCoAbstractSlider >> min: aNumber [
	min := aNumber
]

{ #category : #accessing }
MiCoAbstractSlider >> model [
	^ model
]

{ #category : #accessing }
MiCoAbstractSlider >> model: anObject [
	model ifNotNil: [model removeDependent: self].
	anObject ifNotNil: [anObject addDependent: self].
	model := anObject.
]

{ #category : #accessing }
MiCoAbstractSlider >> quantum [

	^ quantum
]

{ #category : #accessing }
MiCoAbstractSlider >> quantum: anObject [

	quantum := anObject
]

{ #category : #hooks }
MiCoAbstractSlider >> rangeLine [
	| width paint |
	rangeLine ifNotNil: [ ^ rangeLine ].
	width := self lineWidth.
	paint := self rangePaint.
	paint 
		start: 0 @ width / -2;
		stop: 0 @ width / 2.
	
	^ rangeLine :=  RSLine new
		startPoint: 0 @ 0;
		endPoint: 100 @ 0;
		width: width;
		color: paint;
		capRound;
		yourself
]

{ #category : #accessing }
MiCoAbstractSlider >> rangePaint [
	^ LinearGradientPaint fromArray:
		{0->'a1c4fd'. 
		1->'c2e9fb' }
]

{ #category : #events }
MiCoAbstractSlider >> resizeSlider: evt [
	self subclassResponsibility
]

{ #category : #protocol }
MiCoAbstractSlider >> updateValue [
	self subclassResponsibility
]
