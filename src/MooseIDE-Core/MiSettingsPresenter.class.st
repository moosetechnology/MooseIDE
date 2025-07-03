Class {
	#name : #MiSettingsPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'layoutBuilder',
		'browserModel',
		'settingsCommands',
		'memento'
	],
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #validation }
MiSettingsPresenter >> acceptChanges [

	browserModel updateFromMemento: memento
]

{ #category : #'as yet unclassified' }
MiSettingsPresenter >> buildPresenterForCommand: aMiSettingCommand [

	layoutBuilder
		add: aMiSettingCommand name;
		add: (aMiSettingCommand buildPresenter
				 owner: self;
				 yourself);
		nextRow
]

{ #category : #layout }
MiSettingsPresenter >> defaultLayout [

	^ layoutBuilder layout
]

{ #category : #initialization }
MiSettingsPresenter >> initializeDialogWindow: aSpDialogWindowPresenter [

	super initializeDialogWindow: aSpDialogWindowPresenter.

	aSpDialogWindowPresenter okAction: [ self acceptChanges ]
]

{ #category : #initialization }
MiSettingsPresenter >> initializePresenters [

	layoutBuilder := SpGridLayoutBuilder on: self newGridLayout.
	(browserModel settingsCommandsOn: memento) do: [ :cmd |
		self buildPresenterForCommand: cmd ]
]

{ #category : #initialization }
MiSettingsPresenter >> initializeSettingsCommands [
	"Override this method to add setting commands"

	settingsCommands := OrderedCollection new
]

{ #category : #accessing }
MiSettingsPresenter >> layoutBuilder [

	^ layoutBuilder
]

{ #category : #'accessing - model' }
MiSettingsPresenter >> setModelBeforeInitialization: aSpecModel [

	browserModel := aSpecModel.
	memento := aSpecModel newMemento
]

{ #category : #accessing }
MiSettingsPresenter >> windowTitle [

	^ browserModel toolName , ' settings'
]
