Class {
	#name : #MiSettingsPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'layoutBuilder',
		'browserModel',
		'memento'
	],
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #validation }
MiSettingsPresenter >> acceptChanges [

	browserModel updateFromMemento: memento
]

{ #category : #initialization }
MiSettingsPresenter >> buildPresenterForCommand: aMiSettingCommand [

	layoutBuilder
		add: (self newLabel
				 label: aMiSettingCommand name;
				 help: aMiSettingCommand description;
				 yourself);
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
