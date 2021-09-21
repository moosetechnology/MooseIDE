"
I am a Spec widget allowing a user to choose a Color by its RGB values with the sliders, each for one of the RBG values.

Color can be chosen by setting RGB values (using sliders or text fileds), or from a palette of examples.

One gets the chosen color with `#color`

_Note: The sliders are quite buggy. But this is a bug in the Spec library._
"
Class {
	#name : #SpRGBChooser,
	#superclass : #SpPresenter,
	#instVars : [
		'redSlider',
		'greenSlider',
		'blueSlider',
		'colorPreview',
		'colorSamples',
		'colorPalette'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #initialization }
SpRGBChooser class >> defaultSpec [
	^SpBoxLayout newTopToBottom
		add: (SpBoxLayout newLeftToRight
			add: #colorPreview expand: false ;
			add: (SpBoxLayout newTopToBottom
				add: #redSlider expand: false ;
				add: #greenSlider expand: false ;
				add: #blueSlider expand: false ;
				yourself);
			yourself) ;

		add: 'Sample colors:' expand: false ;
		add: #colorSamples expand: false ;

		yourself.

]

{ #category : #initialization }
SpRGBChooser class >> windowSize [
	^ 700 @ 180
]

{ #category : #accessing }
SpRGBChooser >> blueSlider [

	^ blueSlider
]

{ #category : #accessing }
SpRGBChooser >> color [

	^ Color
		  r: redSlider value
		  g: greenSlider value
		  b: blueSlider value
		  range: 255
]

{ #category : #accessing }
SpRGBChooser >> colorPalette [
	"some colors to choose from. A constant for now"
	^ { 
        Color fromString: '#d4ac0d'.
        Color fromString: '#875692'.
        Color fromString: '#f38400'.
        Color fromString: '#a1caf1'.
        Color fromString: '#be0032'.
        Color fromString: '#008856'.
        Color fromString: '#e68fac'.
        Color fromString: '#0067a5'.
        Color fromString: '#f99379'.
        Color fromString: '#c2b280'.
        Color fromString: '#873600'.
        Color fromString: '#8db600'.
        Color fromString: '#f7dc6f'.
        Color fromString: '#48c9b0'.
        Color fromString: '#ff5050'}
]

{ #category : #private }
SpRGBChooser >> colorPreviewed [
	"for tests gets a pixel of the colorPreview Form"
	^Color fromHexString: ((colorPreview image bits anyOne printStringBase: 16) copyFrom: 3 to:  8)
]

{ #category : #private }
SpRGBChooser >> colorSamples [
	"for tests"
	^colorSamples 
]

{ #category : #initialization }
SpRGBChooser >> connectPresenters [

	self whenChangedDo: [ self refreshPreview ]
]

{ #category : #accessing }
SpRGBChooser >> greenSlider [

	^ greenSlider
]

{ #category : #initialization }
SpRGBChooser >> initializePresenters [

	redSlider := self makeSlider: 'Red'.
	greenSlider := self makeSlider: 'Green'.
	blueSlider := self makeSlider: 'Blue'.
	colorPreview := self newImage
		                image: self makeRGBForm;
		                yourself.
	colorSamples := self newToolbar.
	self colorPalette do: [ :color | colorSamples addItem: (self makeColorSample: color) ].

]

{ #category : #initialization }
SpRGBChooser >> makeColorSample: aColor [
	^SpToolbarButtonPresenter new
		icon: ((Form extent: self sampleSize @ self sampleSize depth: 32) fillColor: aColor);
		color: aColor ;
		action: [ self setColor: aColor ] ;
		yourself
]

{ #category : #initialization }
SpRGBChooser >> makeRGBForm [

	^ (Form extent: 80 @ 80 depth: 32) fillColor: self color
]

{ #category : #initialization }
SpRGBChooser >> makeSlider: name [
	^(self instantiate: SpSliderInputPresenter)
		min: 0;
		max: 255;
		label: name ;
		yourself
]

{ #category : #accessing }
SpRGBChooser >> redSlider [

	^ redSlider
]

{ #category : #initialization }
SpRGBChooser >> refreshPreview [

	^ colorPreview image: self makeRGBForm
]

{ #category : #initialization }
SpRGBChooser >> sampleSize [
	^(self class buttonWidth / 3) asInteger
]

{ #category : #accessing }
SpRGBChooser >> setColor: aColor [

	redSlider value: (aColor red * 255 round: 1).
	greenSlider value: (aColor green * 255 round: 1).
	blueSlider value: (aColor blue * 255 round: 1).
	colorPreview image fillColor: self color
]

{ #category : #announcing }
SpRGBChooser >> whenChangedDo: aBlock [

	redSlider whenValueChangedDo: aBlock.
	greenSlider whenValueChangedDo: aBlock.
	blueSlider whenValueChangedDo: aBlock
]
