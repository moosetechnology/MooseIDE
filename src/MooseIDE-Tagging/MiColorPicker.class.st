Class {
	#name : #MiColorPicker,
	#superclass : #MiPresenter,
	#instVars : [
		'colorSlider',
		'colorMap',
		'colorCodePresenter',
		'colorBox',
		'color',
		'hue',
		'brightness',
		'saturation',
		'paletteChooser',
		'actionBlock'
	],
	#category : #'MooseIDE-Tagging-ColorPicker'
}

{ #category : #specs }
MiColorPicker class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: #colorPicker expand: false;
		  add: #colorSlider expand: false;
		  add: (SpBoxLayout newLeftToRight
				   add: #rCode;
				   add: #gCode;
				   add: #bCode;
				   yourself) expand: false;
		  yourself
]

{ #category : #specs }
MiColorPicker class >> openExemple [

	<script>
	^ self new
		  open;
		  yourself
]

{ #category : #accessing }
MiColorPicker >> color [

	^ color
]

{ #category : #accessing }
MiColorPicker >> color: anObject [

	color := anObject
]

{ #category : #update }
MiColorPicker >> connectPresenters [
]

{ #category : #accessing }
MiColorPicker >> hue [

	^ hue
]

{ #category : #accessing }
MiColorPicker >> hue: anObject [

	hue := anObject
]

{ #category : #initialization }
MiColorPicker >> initialize [

	super initialize.
	hue := 0.
	brightness := 1.
	saturation := 1.
	actionBlock := [ :c |  ].
	self setColor: Color blue
]

{ #category : #initialization }
MiColorPicker >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: colorMap height: 130;
			 add: colorSlider expand: false;
			 add: colorCodePresenter expand: false;
			 add: paletteChooser;
			 spacing: 2;
			 yourself)
]

{ #category : #initialization }
MiColorPicker >> initializePresenters [

	colorSlider := self instantiate: MiColorSlider.
	colorCodePresenter := self instantiate: MiColorCodePresenter.
	colorMap := self instantiate: MiColorMap.
	paletteChooser := self instantiate: MiSmallColorPalette.
	self initializeLayout
]

{ #category : #initialization }
MiColorPicker >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Color picker';
		initialExtent: 260@400;
		windowIcon: self windowIcon
]

{ #category : #update }
MiColorPicker >> setColor: aColor [

	color := aColor.
	hue := aColor hue.
	saturation := aColor saturation.
	brightness := aColor brightness.
	colorMap setColor: aColor.
	colorSlider setColor: aColor.
	colorCodePresenter setColor: aColor.
	actionBlock value: aColor
]

{ #category : #update }
MiColorPicker >> updateHue: aHue [

	| c |
	hue := aHue.
	colorMap setHue: hue.
	c := Color h: hue s: saturation v: brightness.
	color := c.
	colorCodePresenter setColor: c.
	actionBlock value: c
]

{ #category : #update }
MiColorPicker >> updateSaturation: s brightness: v [

	| c |
	saturation := s.
	brightness := v.
	c := Color h: hue s: saturation v: brightness.
	color := c.
	colorCodePresenter setColor: c.
	actionBlock value: c
]

{ #category : #update }
MiColorPicker >> whenColorChangedDo: aBlock [

	actionBlock := aBlock
]
