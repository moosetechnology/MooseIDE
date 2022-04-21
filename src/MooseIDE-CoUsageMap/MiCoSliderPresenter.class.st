"
simple slider presenter based on roassal
"
Class {
	#name : #MiCoSliderPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'slider',
		'text'
	],
	#category : #'MooseIDE-CoUsageMap-Settings'
}

{ #category : #layout }
MiCoSliderPresenter class >> defaultLayout [
	^ SpBoxLayout newLeftToRight
		spacing: 10;
		add: #text width: 40;
		add: (SpBoxLayout newTopToBottom
			add: #slider height: 20;
			yourself);
		yourself
]

{ #category : #initialization }
MiCoSliderPresenter >> initializePresenters [
	| sliderBuilder |
	text := self newTextInput.
	slider := self instantiate: SpRoassalPresenter.
	sliderBuilder := MiCoSlider new.
	sliderBuilder renderIn: slider canvas.
]
