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
