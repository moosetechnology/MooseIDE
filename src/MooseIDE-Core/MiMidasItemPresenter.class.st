Class {
	#name : #MiMidasItemPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'nameLabel',
		'midasModel'
	],
	#category : #'MooseIDE-Core-Overview'
}

{ #category : #actions }
MiMidasItemPresenter >> activateItem: aBusOrBrowser [
	self subclassResponsibility
]

{ #category : #actions }
MiMidasItemPresenter >> deactivateItem: aBusOrBrowser [
	self subclassResponsibility
]

{ #category : #initialization }
MiMidasItemPresenter >> initializePresenters [
	super initializePresenters.
	nameLabel := self newLabel label: self toolbarLabel
]

{ #category : #'accessing - model' }
MiMidasItemPresenter >> setModelBeforeInitialization: aBusOrBrowser [
	midasModel := aBusOrBrowser
]

{ #category : #settings }
MiMidasItemPresenter >> toolbarLabel [
	^ self subclassResponsibility
]
