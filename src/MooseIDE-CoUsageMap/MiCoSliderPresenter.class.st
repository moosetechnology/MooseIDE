"
simple slider presenter based on roassal
"
Class {
	#name : #MiCoSliderPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'slider',
		'text',
		'sliderBuilder'
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

{ #category : #accessing }
MiCoSliderPresenter >> get: anObject [
	sliderBuilder getValueSelector: anObject
]

{ #category : #initialization }
MiCoSliderPresenter >> initializePresenters [
	text := self newTextInput.
	slider := self instantiate: SpRoassalPresenter.
	sliderBuilder := MiCoSlider new.
	sliderBuilder renderIn: slider canvas.
]

{ #category : #accessing }
MiCoSliderPresenter >> model: anObject [
	sliderBuilder model: anObject
]

{ #category : #accessing }
MiCoSliderPresenter >> range: anObject [
	sliderBuilder
		min: anObject first;
		max: anObject last;
		quantum: anObject increment;
		updateValue.
	
]

{ #category : #accessing }
MiCoSliderPresenter >> set: anObject [
	sliderBuilder setValueSelector: anObject
]
