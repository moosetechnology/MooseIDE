Class {
	#name : #MiColorMap,
	#superclass : #SpRoassalPresenter,
	#instVars : [
		'circleColor',
		'map',
		'saturation',
		'brightness'
	],
	#category : #'MooseIDE-Tagging-ColorPicker'
}

{ #category : #initialization }
MiColorMap >> initialize [

	super initialize.
	saturation := 1.
	brightness := 1
]

{ #category : #initialization }
MiColorMap >> initializePresenters [

	| can blackGradient paint |
	can := self canvas.
	can color: Color transparent.
	map := RSBox new
		       extent: 240 @ 130;
		       paint: ((LinearGradientPaint fromArray: { 
						         (0 -> Color red).
						         (1 -> Color white) })
				        start: 120 @ 0;
				        stop: -120 @ 0;
				        yourself).
	circleColor := RSCircle new
		               radius: 8;
		               border: (RSBorder new
				                width: 2;
				                color: Color white).
	paint := LinearGradientPaint fromArray: { 
			         (0 -> Color black).
			         (1 -> Color transparent) }.
	paint
		start: 0 @ 65;
		stop: 0 @ -65.
	blackGradient := RSBox new
		                 extent: 240 @ 130;
		                 paint: paint.
	can
		when: RSMouseDragging send: #svChanged: to: self;
		when: RSMouseLeftClick send: #svChanged: to: self.
	can add: map.
	can add: blackGradient.
	can add: circleColor
]

{ #category : #initialization }
MiColorMap >> positionFromColor: aColor [

	| x y |
	x := (240 * aColor saturation) floor.
	y := 130 - (130 * aColor brightness) floor.

	^ x - 120 @ (y - 65)
]

{ #category : #initialization }
MiColorMap >> setColor: aColor [

	saturation := aColor saturation.
	brightness := aColor brightness.
	circleColor translateTo: (self positionFromColor: aColor).
	self setHue: aColor hue.
	self canvas signalUpdate
]

{ #category : #initialization }
MiColorMap >> setHue: hue [

	map paint: ((LinearGradientPaint fromArray: { 
						         (0 -> (Color h: hue s: 1 v: 1)).
						         (1 -> Color white) })
				        start: 120 @ 0;
				        stop: -120 @ 0;
				        yourself).
	circleColor color: (Color h: hue s: saturation v: brightness).
	self canvas signalUpdate
]

{ #category : #initialization }
MiColorMap >> svChanged: evt [

	(evt position x between: -120 and: 120) ifTrue: [ 
		circleColor translateTo: evt position x @ circleColor position y ].
	(evt position y between: -65 and: 65) ifTrue: [ 
		circleColor translateTo: circleColor position x @ evt position y ].
	saturation := (circleColor position x +120) / 240. 
	brightness  := 130 - (circleColor position y + 65) / 130.
	circleColor color: (Color h: self owner hue s: saturation v: brightness).
	self owner updateSaturation: saturation brightness: brightness.
	self canvas signalUpdate
]
