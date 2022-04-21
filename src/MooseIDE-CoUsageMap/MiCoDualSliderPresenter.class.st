"
Dual slider presenter for co usage map
"
Class {
	#name : #MiCoDualSliderPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'slider',
		'text',
		'leftText',
		'sliderBuilder',
		'rightText'
	],
	#category : #'MooseIDE-CoUsageMap-Settings'
}

{ #category : #layout }
MiCoDualSliderPresenter class >> defaultLayout [
	^ SpBoxLayout newLeftToRight
		spacing: 10;
		add: #leftText width: 40;
		add: (SpBoxLayout newTopToBottom
			add: #slider height: 25;
			yourself);
		add: #rightText width: 40;
		yourself
		
]

{ #category : #initialization }
MiCoDualSliderPresenter >> initializePresenters [
	leftText := self newTextInput.
	slider := self instantiate: SpRoassalPresenter.
	sliderBuilder := MiCoDualSlider new.
	sliderBuilder renderIn: slider canvas.
	rightText := self newTextInput.
]
