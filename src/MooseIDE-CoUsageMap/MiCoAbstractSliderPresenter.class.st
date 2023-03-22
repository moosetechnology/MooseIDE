"
Abstract class for slider presenters

TODO: Make generic for whole MooseIDE ?
"
Class {
	#name : #MiCoAbstractSliderPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'sliderBuilder',
		'get',
		'set',
		'model',
		'flag',
		'slider'
	],
	#category : #'MooseIDE-CoUsageMap-Sliders'
}

{ #category : #initialization }
MiCoAbstractSliderPresenter >> defaultSlider [
	^ self subclassResponsibility
]

{ #category : #accessing }
MiCoAbstractSliderPresenter >> get [
	^ get
]

{ #category : #accessing }
MiCoAbstractSliderPresenter >> get: anObject [
	get := anObject
]

{ #category : #initialization }
MiCoAbstractSliderPresenter >> initializePresenters [
	flag := false.
	slider := self newRoassal.
	sliderBuilder := self defaultSlider
		container: slider canvas;
		model: self.
]

{ #category : #accessing }
MiCoAbstractSliderPresenter >> model: anObject [
	model := anObject
]

{ #category : #accessing }
MiCoAbstractSliderPresenter >> range: anObject [
	sliderBuilder
		min: anObject first;
		max: anObject last;
		quantum: anObject increment;
		build
]

{ #category : #accessing }
MiCoAbstractSliderPresenter >> realValue [
	^ get value: model
]

{ #category : #accessing }
MiCoAbstractSliderPresenter >> realValue: anObject [
	flag ifTrue: [ ^ self ].
	flag := true.
	self setValue: anObject.
	flag := false.
]

{ #category : #accessing }
MiCoAbstractSliderPresenter >> set [
	^ set
]

{ #category : #accessing }
MiCoAbstractSliderPresenter >> set: anObject [
	set := anObject
]

{ #category : #private }
MiCoAbstractSliderPresenter >> setValue: anObject [
	model perform: set with: anObject.
	sliderBuilder updateValue.
]
