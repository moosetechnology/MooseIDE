Class {
	#name : #MiOverviewItemPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'nameLabel',
		'model'
	],
	#category : #'MooseIDE-Core-Overview'
}

{ #category : #initialization }
MiOverviewItemPresenter >> initializePresenters [

	super initializePresenters.
	nameLabel := self newLabel label: self toolbarLabel
]

{ #category : #'accessing - model' }
MiOverviewItemPresenter >> setModelBeforeInitialization: aBusOrBrowser [

	model := aBusOrBrowser
]

{ #category : #settings }
MiOverviewItemPresenter >> toolbarLabel [

	^ self subclassResponsibility
]
