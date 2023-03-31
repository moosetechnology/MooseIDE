"
slider with two handles representing a min and a max on a scale
"
Class {
	#name : #MiCoDualSlider,
	#superclass : #MiCoAbstractSlider,
	#instVars : [
		'minValue',
		'maxValue',
		'minButton',
		'maxButton',
		'getMin',
		'setMin',
		'getMax',
		'setMax'
	],
	#category : #'MooseIDE-CoUsageMap-Sliders'
}

{ #category : #'default values' }
MiCoDualSlider >> defaultMaxValue [
	^ 0.6
]

{ #category : #'default values' }
MiCoDualSlider >> defaultMinValue [
	^ 0.4
]

{ #category : #examples }
MiCoDualSlider >> example01 [
	<script: 'self new example01 open'>
	^ self
	
]

{ #category : #accessing }
MiCoDualSlider >> getMax: anObject [
	getMax := anObject
]

{ #category : #accessing }
MiCoDualSlider >> getMin: anObject [
	getMin := anObject
]

{ #category : #highlighting }
MiCoDualSlider >> highlight: evt [
	| paint |
	evt interaction record: evt shape selector: #paint value: evt shape paint.
	paint := self rangePaint.
	paint 
		start: 0 @ evt shape height / -2;
		stop: 0 @ evt shape height / 2.
	evt shape color: paint.
]

{ #category : #highlighting }
MiCoDualSlider >> hightlightInteraction [
	^ RSHighlightable new
		when: RSHighlightEvent send: #highlight: to: self;
		when: RSUnHighlightEvent send: #unhighlight: to: self;
		yourself.
]

{ #category : #initialization }
MiCoDualSlider >> initialize [
	super initialize.
	self
		minValue: self defaultMinValue;
		maxValue: self defaultMaxValue;
		min: 0;
		max: 1.
		
]

{ #category : #hooks }
MiCoDualSlider >> maxButton [
	^ maxButton := self newButton
		when: RSMouseDragging send: #updateMaxValue: to: self;
		when: RSMouseDragEnd send: #updateMaxValueUp: to: self;
		yourself
]

{ #category : #accessing }
MiCoDualSlider >> maxValue [
	^ maxValue
]

{ #category : #accessing }
MiCoDualSlider >> maxValue: aNumber [
	maxValue := aNumber
]

{ #category : #public }
MiCoDualSlider >> maxValueFromModel [
	model ifNil: [ ^ self defaultMaxValue ].
	getMax ifNil: [ ^ self defaultMaxValue ].
	^ scale scale: ((model perform: getMax) roundTo: quantum).
]

{ #category : #public }
MiCoDualSlider >> maxValueFromModel: aNumber [
	model ifNil: [ ^ self ].
	setMax ifNil: [ ^ self ].
	model perform: setMax with: ((scale invert: aNumber) roundTo: quantum)
]

{ #category : #hooks }
MiCoDualSlider >> minButton [
	^ minButton := self newButton
		when: RSMouseDragging send: #updateMinValue: to: self;
		when: RSMouseDragEnd send: #updateMinValueUp: to: self;
		yourself
		
]

{ #category : #accessing }
MiCoDualSlider >> minValue [
	^ minValue
]

{ #category : #accessing }
MiCoDualSlider >> minValue: aNumber [
	minValue := aNumber
]

{ #category : #public }
MiCoDualSlider >> minValueFromModel [
	model ifNil: [ ^ 0.4 ].
	getMin ifNil: [ ^ 0.4 ].
	^ scale scale: ((model perform: getMin) roundTo: quantum).
]

{ #category : #public }
MiCoDualSlider >> minValueFromModel: aNumber [
	model ifNil: [ ^ self ].
	setMin ifNil: [ ^ self ].
	model perform: setMin with: ((scale invert: aNumber) roundTo: quantum)
]

{ #category : #hooks }
MiCoDualSlider >> newButton [
	| size paint |
	paint := self backPaint.
	size := 20.
	paint
		start: 0 @ size / -2;
		stop: 0 @ size / 2.
	^ RSEllipse new
		addInteraction: self hightlightInteraction;
		withBorder;
		color: paint;
		size: size;
		yourself
]

{ #category : #hooks }
MiCoDualSlider >> renderIn: aCanvas [
	aCanvas 
		color: Color transparent;
		addShape: self backLine;
		addShape: self rangeLine;
		addShape: self minButton;
		addShape: self maxButton.
	scale := NSScale linear
		domain: { min. max };
		range: #(0 1).
	minValue := self minValueFromModel.
	maxValue := self maxValueFromModel.
	
	self resizeSlider: aCanvas.
	aCanvas
		when: RSExtentChangedEvent send: #resizeSlider: to: self;
		when: RSMouseClick send: #updateCloserPoint: to: self.
		
]

{ #category : #events }
MiCoDualSlider >> resizeSlider: evt [
	| extent w h minPoint maxPoint canvasScale |
	extent := evt canvas extent.
	w := extent x - self lineGap.
	h := extent y.
	
	backLine
		startPoint: w/2 @ 0;
		endPoint: w/ -2 @ 0.
	canvasScale := NSScale linear range: { w/ -2. w / 2 }.
	
	minPoint := (canvasScale scale: minValue) @ 0.
	maxPoint := (canvasScale scale: maxValue) @ 0.
	rangeLine
		startPoint: minPoint;
		endPoint: maxPoint.
	minButton position: minPoint.
	maxButton position: maxPoint.
	
]

{ #category : #accessing }
MiCoDualSlider >> setMax: anObject [
	setMax := anObject
]

{ #category : #accessing }
MiCoDualSlider >> setMin: anObject [
	setMin := anObject
]

{ #category : #highlighting }
MiCoDualSlider >> unhighlight: evt [
	evt interaction restore: evt shape selector: #paint.
]

{ #category : #events }
MiCoDualSlider >> updateCloserPoint: evt [
	| dist1 dist2 button |
	dist1 := evt position distanceTo: minButton position.
	dist2 := evt position distanceTo: maxButton position.
	button := dist1 < dist2
		ifTrue: [ minButton ]
		ifFalse: [ maxButton ].
	button announce: (RSMouseDragging new 
		position: evt position;
		step: evt position- minButton position;
		yourself).
	button announce: RSMouseDragEnd new.
	evt signalUpdate.
]

{ #category : #events }
MiCoDualSlider >> updateMaxValue: evt [
	| newValue w |
	w := evt canvas extent x - self lineGap.
	newValue := evt position x + (w/2) / w.
	newValue := newValue min: 1 max: minValue.
	maxValue := newValue.
	self resizeSlider: evt.
	evt signalUpdate.
]

{ #category : #events }
MiCoDualSlider >> updateMaxValueUp: evt [
	self maxValueFromModel: maxValue.
]

{ #category : #events }
MiCoDualSlider >> updateMinValue: evt [
	| newValue w |
	w := evt canvas extent x - self lineGap.
	newValue := evt position x + (w/2) / w.
	newValue := newValue min: maxValue max: 0.
	minValue := newValue.

	self resizeSlider: evt.
	evt signalUpdate.
]

{ #category : #events }
MiCoDualSlider >> updateMinValueUp: evt [
	self minValueFromModel: minValue.
]

{ #category : #update }
MiCoDualSlider >> updateValue [
	minValue := self minValueFromModel.
	maxValue := self maxValueFromModel.
	self resizeSlider: self container.
	self container signalUpdate.
]
