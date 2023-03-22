"
Dual slider presenter (for Spec) for MiCoDualSlider
"
Class {
	#name : #MiCoDualSliderPresenter,
	#superclass : #MiCoAbstractSliderPresenter,
	#instVars : [
		'leftText',
		'rightText'
	],
	#category : #'MooseIDE-CoUsageMap-Sliders'
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
MiCoDualSliderPresenter >> defaultSlider [
	^ MiCoDualSlider new
]

{ #category : #initialization }
MiCoDualSliderPresenter >> initializePresenters [
	super initializePresenters.
	leftText := self newNumberInput.
	rightText := self newNumberInput.
	
	sliderBuilder 
		getMax: #maxValue;
		setMax: #maxValue:;
		getMin: #minValue;
		setMin: #minValue:
]

{ #category : #accessing }
MiCoDualSliderPresenter >> maxValue [
	^ self realValue last
]

{ #category : #accessing }
MiCoDualSliderPresenter >> maxValue: anObject [
	| newMax |
	newMax := anObject min: sliderBuilder max max: self realValue first.
	self realValue: (self realValue first to: newMax)
]

{ #category : #accessing }
MiCoDualSliderPresenter >> minValue [
	^ self realValue first
]

{ #category : #accessing }
MiCoDualSliderPresenter >> minValue: anObject [
	| newMin |
	newMin := anObject min: self realValue last max: sliderBuilder min.
	self realValue: (newMin to: self realValue last)
]

{ #category : #accessing }
MiCoDualSliderPresenter >> range: anInterval [
	super range: anInterval.
	leftText
		text: self realValue first asString;
		beInteger;
		minimum: anInterval first;
		maximum: anInterval last;
		whenNumberChangedDo: [:number | self minValue: number ].
		
	rightText
		text: self realValue last asString;
		beInteger;
		minimum: anInterval first;
		maximum: anInterval last;
		whenNumberChangedDo: [:number | self maxValue: number ].
]

{ #category : #private }
MiCoDualSliderPresenter >> setValue: anObject [
	super setValue: anObject.
	leftText text: self realValue first asString.
	rightText text: self realValue last asString.	
]
