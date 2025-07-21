Class {
	#name : #MiSettingsPresenter,
	#superclass : #MiPresenter,
	#instVars : [
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
MiSettingsPresenter >> addPresenterForCommand: aMiSettingCommand inBuilder: aBuilder [

	aBuilder
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

	^ self newGridLayout
]

{ #category : #initialization }
MiSettingsPresenter >> initializeDialogWindow: aSpDialogWindowPresenter [

	super initializeDialogWindow: aSpDialogWindowPresenter.
	aSpDialogWindowPresenter toolbar: self toolbar.

	aSpDialogWindowPresenter okAction: [ self acceptChanges ]
]

{ #category : #initialization }
MiSettingsPresenter >> initializePresenters [

	self layout build: [ :builder |
			(browserModel settingsCommandsOn: memento) do: [ :cmd |
				self addPresenterForCommand: cmd inBuilder: builder ] ]
]

{ #category : #initialization }
MiSettingsPresenter >> resetToDefault [

	memento := browserModel newMementoForDefaultValues.
	self initializePresenters
]

{ #category : #'accessing - model' }
MiSettingsPresenter >> setModelBeforeInitialization: aSpecModel [

	browserModel := aSpecModel.
	memento := aSpecModel newMemento
]

{ #category : #accessing }
MiSettingsPresenter >> toolbar [

	^ self newToolbar addItemRight: (self newToolbarButton
			   action: [ self resetToDefault ];
			   label: 'Reset';
			   help: 'Restore all settings to default values';
			   icon: (self iconNamed: #smallUpdate);
			   yourself)
]

{ #category : #accessing }
MiSettingsPresenter >> windowTitle [

	^ browserModel toolName , ' settings'
]
