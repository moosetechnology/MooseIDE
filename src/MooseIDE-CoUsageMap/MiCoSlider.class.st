"
Basic slider inspired in sliders from mobile phones
"
Class {
	#name : #MiCoSlider,
	#superclass : #RSAbstractContainerBuilder,
	#instVars : [
		'bar',
		'radius',
		'value',
		'getValueSelector',
		'setValueSelector',
		'model',
		'min',
		'max',
		'quantum',
		'scale'
	],
	#category : #'MooseIDE-CoUsageMap-Slider'
}

{ #category : #accessing }
MiCoSlider >> getValueSelector [

	^ getValueSelector
]

{ #category : #accessing }
MiCoSlider >> getValueSelector: aString [ 
	getValueSelector := aString
]

{ #category : #initialization }
MiCoSlider >> initialize [
	super initialize.
	self
		radius: 10;
		value: 0.5;
		min: 0;
		max: 1.
	
]

{ #category : #accessing }
MiCoSlider >> max [

	^ max
]

{ #category : #accessing }
MiCoSlider >> max: anObject [

	max := anObject
]

{ #category : #accessing }
MiCoSlider >> min [

	^ min
]

{ #category : #accessing }
MiCoSlider >> min: anObject [

	min := anObject
]

{ #category : #accessing }
MiCoSlider >> model [

	^ model
]

{ #category : #accessing }
MiCoSlider >> model: anObject [
	model ifNotNil: [model removeDependent: self].
	anObject ifNotNil: [anObject addDependent: self].
	model := anObject.
]

{ #category : #accessing }
MiCoSlider >> quantum [

	^ quantum
]

{ #category : #accessing }
MiCoSlider >> quantum: anObject [

	quantum := anObject
]

{ #category : #accessing }
MiCoSlider >> radius [
	^ radius
]

{ #category : #accessing }
MiCoSlider >> radius: aNumber [
	radius := aNumber
]

{ #category : #hooks }
MiCoSlider >> renderIn: aCanvas [
	aCanvas color: Color transparent.
	bar := RSBox new
		color: Color lightGray;
		cornerRadius: radius;
		isFixed: true;
		yourself.
	aCanvas addShape: bar.
	scale := NSScale linear
		domain: { min. max };
		range: #(0 1).
	value := self valueFromModel.
	self resizeSlider: aCanvas.
	aCanvas 
		when: RSExtentChangedEvent send: #resizeSlider: to: self;
		when: RSMouseClick send: #updateValue: to: self;
		when: RSMouseDragging send: #updateValue: to: self.
		
]

{ #category : #events }
MiCoSlider >> resizeSlider: evt [
	| extent w h paint blue gray |
	extent := evt canvas extent.
	w := extent x.
	h := extent y.
	blue := Smalltalk ui theme selectionColor darker.
	gray := Color lightGray.
	paint := LinearGradientPaint fromArray: { 
		0 -> blue.
		value -> blue.
		value -> gray.
		1 -> gray. }.
	paint start: extent x / -2 @0.
	paint stop: extent x / 2 @ 0.
	
	bar paint: paint.
	bar extent: extent.
	bar position: extent / 2.
	
	
]

{ #category : #accessing }
MiCoSlider >> setValueSelector [

	^ setValueSelector
]

{ #category : #accessing }
MiCoSlider >> setValueSelector: aString [ 
	setValueSelector := aString
]

{ #category : #updating }
MiCoSlider >> update: aParameter [
	aParameter = getValueSelector ifTrue: [ self updateValue ].
]

{ #category : #updating }
MiCoSlider >> updateValue [
	value := self valueFromModel.
	self resizeSlider: self container.
]

{ #category : #events }
MiCoSlider >> updateValue: evt [
	| w newValue |
	w := evt canvas extent x.
	newValue := (evt camera fromSpaceToPixel: evt position) x/ w.
	newValue := (newValue min: 1) max: 0.
	value := newValue.
	self valueFromModel: value.
	self resizeSlider: evt.
	evt signalUpdate.
]

{ #category : #accessing }
MiCoSlider >> value [
	^ value
]

{ #category : #accessing }
MiCoSlider >> value: aNumber [
	value :=aNumber
]

{ #category : #accessing }
MiCoSlider >> valueFromModel [
	model ifNil: [ ^ 0.5 ].
	getValueSelector ifNil: [ ^ 0.5 ].
	^ scale scale: ((model perform: getValueSelector) roundTo: quantum).
	
]

{ #category : #accessing }
MiCoSlider >> valueFromModel: aNumber [
	model ifNil: [ ^ self ].
	setValueSelector ifNil: [ ^ self ].
	model perform: setValueSelector with: ((scale invert: aNumber) roundTo: quantum).
]
