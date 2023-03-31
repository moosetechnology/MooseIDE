"
Utility class to have a waiting message while building the visualization

TODO: remove and make a general infrstructure for all MooseIDE browsers
"
Class {
	#name : #MiJob,
	#superclass : #Object,
	#instVars : [
		'block',
		'label',
		'backLine',
		'frontLine',
		'currentValue',
		'background',
		'canvas',
		'newCanvas',
		'morph'
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
	newCanvas removeInteractionIfPresent: self class.
	
	morph canvas: canvas.
	canvas morph: morph.
	canvas extent: morph extent.
	morph := nil.
	newCanvas := nil.
	
	
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
	newCanvas := RSCanvas new.
	morph := canvas morph.
	morph canvas: newCanvas.
	newCanvas morph: morph.
	newCanvas camera 
		position: 0@0;
		scale: 1. 
	newCanvas 
		addShape: background;
		addShape: label;
		addShape: backLine;
		addShape: frontLine.
	newCanvas
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
	newCanvas ifNil: [ ^ self ].
	label text: aString.
	newCanvas signalUpdate.
]

{ #category : #update }
MiJob >> update [
	| visibleRect delta from to scale |
	newCanvas ifNil: [ ^ self ].
	visibleRect := 0@0 extent: newCanvas extent.
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
	newCanvas signalUpdate.
	
	
	
]
