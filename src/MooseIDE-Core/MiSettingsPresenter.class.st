Class {
	#name : 'MiSettingsPresenter',
	#superclass : 'MiPresenter',
	#instVars : [
		'browserModel',
		'memento'
	],
	#category : 'MooseIDE-Core-Settings',
	#package : 'MooseIDE-Core',
	#tag : 'Settings'
}

{ #category : 'visiting' }
MiSettingsPresenter >> acceptChanges [

	browserModel updateFromMemento: memento
]

{ #category : 'adding' }
MiSettingsPresenter >> addPresenter: aPresenter inBuilder: aBuilder [

	aBuilder
		add: aPresenter labelPresenter;
		add: aPresenter;
		nextRow
]

{ #category : 'layout' }
MiSettingsPresenter >> defaultLayout [

	^ self newGridLayout
]

{ #category : 'initialization' }
MiSettingsPresenter >> initializeDialogWindow: aSpDialogWindowPresenter [

	super initializeDialogWindow: aSpDialogWindowPresenter.

	aSpDialogWindowPresenter initialExtent: browserModel settingsPresenterExtent.
	aSpDialogWindowPresenter toolbar: self toolbar.

	aSpDialogWindowPresenter okAction: [ self acceptChanges ]
]

{ #category : 'initialization' }
MiSettingsPresenter >> initializePresenters [

	self layout build: [ :builder |
			(memento settingsPresenters) do: [ :presenterClass |
				self addPresenter: presenterClass inBuilder: builder ] ]
]

{ #category : 'initialization' }
MiSettingsPresenter >> resetToDefault [

	memento := browserModel newMementoForDefaultValues.
	self initializePresenters
]

{ #category : 'accessing - model' }
MiSettingsPresenter >> setModelBeforeInitialization: aSpecModel [

	browserModel := aSpecModel.
	memento := aSpecModel newMemento
]

{ #category : 'accessing' }
MiSettingsPresenter >> toolbar [

	^ self newToolbar addItemRight: (self newToolbarButton
			   action: [ self resetToDefault ];
			   label: 'Reset';
			   help: 'Restore all settings to default values';
			   icon: (self iconNamed: #smallUpdate);
			   yourself)
]

{ #category : 'accessing' }
MiSettingsPresenter >> windowTitle [

	^ browserModel toolName , ' settings'
]
