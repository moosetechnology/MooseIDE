Class {
	#name : #MiSelection,
	#superclass : #RSInteraction,
	#instVars : [
		'shadowColor'
	],
	#category : #'Midas-Vizualisation'
}

{ #category : #accessing }
MiSelection >> key [
	^ self class name
]

{ #category : #hooks }
MiSelection >> onShape: aShape [
	aShape model ifNil: [ ^ self ].
	aShape when: RSMouseClick do: [ self selection: aShape ]
]

{ #category : #hooks }
MiSelection >> putShadowOn: aShape [
	| shadow |
	shadow := RSBox new
		fromRectangle: (aShape encompassingRectangle expandBy: aShape extent * 0.05); 
		paint: self shadowColor;
		yourself.
	aShape parent
		addShape: shadow before: aShape.
	aShape topParent 
		propertyAt: self key
		put: shadow
]

{ #category : #hooks }
MiSelection >> removeShadowOn: aShape [
	aShape topParent
		propertyAt: self key
		ifPresent: [ :shadow |shadow remove ].
]

{ #category : #hooks }
MiSelection >> selection: aShape [
	self inform: 'Selection !'.
	self
		removeShadowOn: aShape;
		putShadowOn: aShape.
	aShape canvas signalUpdate
]

{ #category : #accessing }
MiSelection >> shadowColor [
	^ shadowColor ifNil: [ shadowColor := Color blue alpha: 0.3 ]
]

{ #category : #accessing }
MiSelection >> shadowColor: aColor [
	shadowColor := aColor
]
