"
Simple slider presenter (for Spec) for MiCoSlider
"
Class {
	#name : #MiCoSliderPresenter,
	#superclass : #MiCoAbstractSliderPresenter,
	#instVars : [
		'text'
	],
	#category : #'MooseIDE-CoUsageMap-Sliders'
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
MiCoSliderPresenter >> defaultSlider [
	^ MiCoSlider new
]

{ #category : #initialization }
MiCoSliderPresenter >> initializePresenters [
	super initializePresenters.
	text := self newNumberInput.
	sliderBuilder 
		getValueSelector: #realValue;
		setValueSelector: #realValue:
]

{ #category : #accessing }
MiCoSliderPresenter >> range: anObject [
	super range: anObject.
	text 
		text: self realValue asString;
		beInteger;
		minimum: anObject first;
		maximum: anObject last;
		whenNumberChangedDo: [ :number | self realValue: number ].
		
]

{ #category : #private }
MiCoSliderPresenter >> setValue: anObject [
	| newValue |
	newValue := anObject min: sliderBuilder max max: sliderBuilder min.
	super setValue: newValue.
	text text: self realValue asString
]
