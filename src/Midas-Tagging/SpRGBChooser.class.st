"
I am a Spec widget allowing a user to choose a Color by its RGB values with the sliders, each for one of the RBG values.

I manage three `SpSliderInput`.
I set their min at 0 and their max at 255.
I provide the method `color` that calculates a Color with the current values of the RGB sliders.

_Note: The sliders are quite buggy. But this is a bug in the Spec library._
"
Class {
	#name : #SpRGBChooser,
	#superclass : #SpPresenter,
	#instVars : [
		'redSlider',
		'greenSlider',
		'blueSlider',
		'colorPreview'
	],
	#category : #'Midas-Tagging'
}

{ #category : #specs }
SpRGBChooser class >> defaultSpec [

	^ SpPanedLayout newLeftToRight
		  add: #colorPreview;
		  add: (SpBoxLayout newTopToBottom
				   add: #redSlider;
				   add: #greenSlider;
				   add: #blueSlider;
				   yourself);
		  yourself
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

{ #category : #initialization }
SpRGBChooser >> connectPresenters [

	self whenChangedDo: [ colorPreview image: self makeRGBForm ]
]

{ #category : #accessing }
SpRGBChooser >> greenSlider [

	^ greenSlider
]

{ #category : #initialization }
SpRGBChooser >> initializePresenters [

	redSlider := self instantiate: SpSliderInputPresenter.
	greenSlider := self instantiate: SpSliderInputPresenter.
	blueSlider := self instantiate: SpSliderInputPresenter.
	colorPreview := self newImage
		                image: self makeRGBForm;
		                yourself.
	redSlider
		min: 0;
		max: 255;
		label: 'Red'.
	greenSlider
		min: 0;
		max: 255;
		label: 'Green'.
	blueSlider
		min: 0;
		max: 255;
		label: 'Blue'.
	self focusOrder
		add: redSlider;
		add: greenSlider;
		add: blueSlider;
		add: colorPreview
]

{ #category : #accessing }
SpRGBChooser >> makeRGBForm [

	^ (Form extent: 80 @ 80 depth: 32) fillColor: self color
]

{ #category : #accessing }
SpRGBChooser >> redSlider [

	^ redSlider
]

{ #category : #announcing }
SpRGBChooser >> whenChangedDo: aBlock [

	redSlider whenValueChangedDo: aBlock.
	greenSlider whenValueChangedDo: aBlock.
	blueSlider whenValueChangedDo: aBlock
]
