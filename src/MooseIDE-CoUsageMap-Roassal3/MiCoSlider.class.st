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
		'label'
	],
	#category : #'MooseIDE-CoUsageMap-Roassal3'
}

{ #category : #accessing }
MiCoSlider >> getValueSelector: aString [ 
	getValueSelector := aString
]

{ #category : #initialization }
MiCoSlider >> initialize [
	super initialize.
	self radius: 10.
	self value: 0.5
]

{ #category : #accessing }
MiCoSlider >> model: anObject [
	model := anObject
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
	bar := RSBox new
		color: Color lightGray;
		cornerRadius: radius;
		isFixed: true;
		yourself.
	label := RSLabel new
		color: Color red;
		isFixed: true;
		text: 123;
		yourself.
	aCanvas addShape: bar.
	aCanvas addShape: label.
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
	blue := Smalltalk ui theme selectionColor.
	gray := Color lightGray.
	paint := LinearGradientPaint fromArray: { 
		0 -> blue.
		value -> blue.
		value -> gray.
		1 -> gray. }.
	paint start: extent x / -2 @0.
	paint stop: extent x / 2 @ 0.
	label text: (value * 100) asInteger asString, '%'.
	label position: extent / 2.
	
	bar paint: paint.
	bar extent: extent.
	bar position: extent / 2.
	
	
]

{ #category : #accessing }
MiCoSlider >> setValueSelector: aString [ 
	setValueSelector := aString
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

{ #category : #hooks }
MiCoSlider >> valueFromModel [
	model ifNil: [ ^ 0.5 ].
	getValueSelector ifNil: [ ^ 0.5 ].
	^ model perform: getValueSelector
	
]

{ #category : #events }
MiCoSlider >> valueFromModel: aNumber [
	model ifNil: [ ^ self ].
	setValueSelector ifNil: [ ^ self ].
	model perform: setValueSelector with: aNumber.
]
