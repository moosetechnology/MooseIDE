"
Utility class to have a waiting message
"
Class {
	#name : #MiJob,
	#superclass : #Object,
	#instVars : [
		'block',
		'canvas',
		'label',
		'backLine',
		'frontLine',
		'currentValue',
		'background'
	],
	#category : #'MooseIDE-CoUsageMap-Roassal3'
}

{ #category : #accessing }
MiJob >> block: aBlock [
	block := aBlock
]

{ #category : #accessing }
MiJob >> canvas: aRSCanvas [
	canvas := aRSCanvas
]

{ #category : #utilities }
MiJob >> cleanCanvas [
	label remove.
	backLine remove.
	frontLine remove.
	background remove.
	canvas removeInteractionIfPresent: self class.
	canvas notifyExtentChanged.
]

{ #category : #accessing }
MiJob >> currentValue: aNumber [
	currentValue := aNumber.
	self update
]

{ #category : #initialization }
MiJob >> initialize [
	super initialize.
	currentValue := 0
]

{ #category : #utilities }
MiJob >> newLine [
	^ RSLine new
		width: 20;
		capRound;
		isFixed: true;
		yourself
]

{ #category : #utilities }
MiJob >> prepareForRendering [
	background := RSBox new isFixed: true; color: Color white.
	label := RSLabel new isFixed: true.
	backLine := self newLine color: Color gray.
	frontLine := self newLine color: Smalltalk ui theme selectionColor.
	canvas camera 
		position: 0@0;
		scale: 1.
	canvas 
		addShape: background;
		addShape: label;
		addShape: backLine;
		addShape: frontLine.
	canvas
		when: RSExtentChangedEvent
		send: #update
		to: self.
	
	self update
]

{ #category : #running }
MiJob >> run [
	^ [ 
		self prepareForRendering.
		block value: self.
		self cleanCanvas ] fork
]

{ #category : #accessing }
MiJob >> title: aString [
	canvas ifNil: [ ^ self ].
	label text: aString.
	canvas signalUpdate.
]

{ #category : #update }
MiJob >> update [
	| visibleRect delta from to scale |
	canvas ifNil: [ ^ self ].
	visibleRect := 0@0 extent: canvas extent.
	background fromRectangle: visibleRect.
	
	visibleRect := (-20 @ 0) asMargin expandRectangle: visibleRect.
	label position: visibleRect floatCenter.
	delta := 0@ 25.
	from := visibleRect leftCenter + delta.
	to := visibleRect rightCenter + delta.
	backLine startPoint: from; endPoint: to.
	scale := NSScale linear
		domain: { 0. 100 };
		range: { from. to };
		clamp: true;
		yourself.
	frontLine startPoint: from; endPoint: (scale scale: currentValue).
	canvas signalUpdate.
	
	
	
]
