"
Basic slider inspired from sliders from mobile phones
"
Class {
	#name : #MiCoSlider,
	#superclass : #MiCoAbstractSlider,
	#instVars : [
		'value',
		'getValueSelector',
		'setValueSelector'
	],
	#category : #'MooseIDE-CoUsageMap-Sliders'
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
	min := 0.
	max := 1.
	self
		value: 0.5;
		initializeScale
	
]

{ #category : #initialization }
MiCoSlider >> initializeScale [
	scale := NSScale linear
		domain: { min. max };
		range: #(0 1).
]

{ #category : #accessing }
MiCoSlider >> radius [
	^ 10
]

{ #category : #hooks }
MiCoSlider >> renderIn: aCanvas [
	self initializeScale.
	aCanvas color: Color transparent.
	aCanvas 
		addShape: self backLine;
		addShape: self rangeLine.
	
	value := self valueFromModel.
	self resizeSlider: aCanvas.
	aCanvas 
		when: RSExtentChangedEvent send: #resizeSlider: to: self;
		when: RSMouseClick send: #updateValue: to: self;
		when: RSMouseDragging send: #updateValue: to: self
]

{ #category : #events }
MiCoSlider >> resizeSlider: evt [
	| extent w h minPoint maxPoint valuePoint winScale |
	extent := evt canvas extent.
	w := extent x - self lineGap.
	h := extent y.
	winScale := NSScale linear range: { w/ -2 @ 0. w/2 @ 0 }.
	minPoint := winScale scale: 0.
	maxPoint := winScale scale: 1.
	valuePoint := winScale scale: value.
	backLine startPoint: minPoint; endPoint: maxPoint.
	rangeLine startPoint: minPoint; endPoint: valuePoint.
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
	| w newValue winScale |
	w := evt canvas extent x-self lineGap.
	winScale := NSScale linear clamp; range: { w/ -2 @ 0. w/2 @ 0 }.
	newValue := (winScale invert: evt position) x.
	newValue := newValue min: 1 max: 0.
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
