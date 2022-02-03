Class {
	#name : #MiColorSlider,
	#superclass : #SpRoassalPresenter,
	#instVars : [
		'hue',
		'rainbowSlider',
		'circleHue'
	],
	#category : #'MooseIDE-Tagging-ColorPicker'
}

{ #category : #initialization }
MiColorSlider >> hueChanged: evt [

	| c |
	(evt position x
		 between: -1 * rainbowSlider width / 2
		 and: rainbowSlider width / 2) ifFalse: [ ^ self ].
	c := self hueFromPosition: evt position.
	circleHue color: c.
	self owner updateHue: hue.
	circleHue translateTo: evt position x @ 0.
	evt signalUpdate
]

{ #category : #hooks }
MiColorSlider >> hueFromPosition: aPoint [

	| offset |
	offset := 240 /2 + aPoint x.
	hue := (offset * 360 / 240) floor.
	^ Color h: hue s: 1 v: 1
]

{ #category : #initialization }
MiColorSlider >> initializePresenters [

	| paint h w can slider |
	h := 10.
	w := 240.
	can := self canvas.
	can extent: w @ h.
	can color: Color transparent.
	slider := RSComposite new.
	paint := LinearGradientPaint fromArray: { 
			         (0 -> (Color h: 0 s: 1 v: 1)).
			         (0.1 -> (Color h: 36 s: 1 v: 1)).
			         (0.2 -> (Color h: 72 s: 1 v: 1)).
			         (0.3 -> (Color h: 108 s: 1 v: 1)).
			         (0.5 -> (Color h: 144 s: 1 v: 1)).
			         (0.5 -> (Color h: 180 s: 1 v: 1)).
			         (0.6 -> (Color h: 216 s: 1 v: 1)).
			         (0.7 -> (Color h: 252 s: 1 v: 1)).
			         (0.8 -> (Color h: 288 s: 1 v: 1)).
			         (0.9 -> (Color h: 324 s: 1 v: 1)).
			         (1 -> (Color h: 360 s: 1 v: 1)) }.
	paint
		start: -1 * w / 2 @ 0;
		stop: w / 2 @ 0.
	rainbowSlider := RSBox new
		                 extent: w @ h;
		                 paint: paint.
	circleHue := RSCircle new
		             radius: 10;
		             border: (RSBorder new
				              width: 2;
				              color: Smalltalk ui theme textColor).
	slider
		when: RSMouseDragging send: #hueChanged: to: self;
		when: RSMouseLeftClick send: #hueChanged: to: self.
	slider
		add: rainbowSlider;
		add: circleHue.
	can add: slider.
	slider adjustToChildren
]

{ #category : #hooks }
MiColorSlider >> positionFromHue: aHue [

	^ (hue * 240 / 360) floor - (240 / 2) @ 0
]

{ #category : #initialization }
MiColorSlider >> setColor: aColor [

	hue := aColor hue.
	circleHue translateTo: (self positionFromHue: hue).
	circleHue color: (Color h: hue s: 1 v: 1).
	self canvas signalUpdate
]
