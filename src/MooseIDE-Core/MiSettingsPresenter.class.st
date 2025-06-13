Class {
	#name : #MiSettingsPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'settingsManager',
		'layoutBuilder'
	],
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #layout }
MiSettingsPresenter >> defaultLayout [

	^ layoutBuilder layout
]

{ #category : #initialization }
MiSettingsPresenter >> initializePresenters [

	layoutBuilder := SpGridLayoutBuilder on: self newGridLayout.
	settingsManager settingsBuilders do: [ :cmd |
		cmd buildPresenterIn: self ]
]

{ #category : #accessing }
MiSettingsPresenter >> layoutBuilder [

	^ layoutBuilder
]

{ #category : #'accessing - model' }
MiSettingsPresenter >> setModelBeforeInitialization: aSettingsManager [

	settingsManager := aSettingsManager
]

{ #category : #accessing }
MiSettingsPresenter >> windowTitle [

	^ settingsManager title
]
