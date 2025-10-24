Class {
	#name : 'MiSettingsPresenter',
	#superclass : 'MiPresenter',
	#instVars : [
		'browserModel',
		'configuration',
		'saveButton',
		'cancelButton',
		'loadButton',
		'okButton',
		'settingsLayout'
	],
	#category : 'MooseIDE-Core-Settings',
	#package : 'MooseIDE-Core',
	#tag : 'Settings'
}

{ #category : 'visiting' }
MiSettingsPresenter >> acceptChanges [

	browserModel updateFromConfiguration: configuration
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
		  beColumnNotHomogeneous;
		  column: 2 expand: false;
		  yourself
]

{ #category : 'accessing' }
MiSettingsPresenter >> defaultSettingsFileName [

	^ browserModel toolName asCamelCase , 'Settings.ston'
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
			configuration settingsPresenters do: [ :presenterClass |
				self addPresenter: presenterClass inBuilder: builder ] ]
]

{ #category : 'file in/out' }
MiSettingsPresenter >> loadSettings [
	"We change the #configuration for a new object loaded from Json"

	| fileReference |
	fileReference := UITheme builder
		                 chooseExistingFileReference: 'Choose settings file to import'
		                 extensions: { 'ston' }
		                 path: './pharo-local' asFileReference.

	[
		fileReference ifNotNil: [
				configuration := STON fromStream: fileReference readStream.
				self initializePresenters.
				self inform: fileReference basename , ' loaded' ] ]
		on: Error
		do: [ :err | self inform: 'Error while loading settings: ' , err messageText ]
]

{ #category : 'initialization' }
MiSettingsPresenter >> resetToDefault [

	configuration := browserModel defaultConfiguration.
	self initializePresenters
]

{ #category : 'file in/out' }
MiSettingsPresenter >> saveSettings [

	| fileReference |
	fileReference := UITheme builder
		                 chooseForSaveFileReference: 'Choose a location to save your settings'
		                 extensions: { 'ston' }
		                 path: ('./pharo-local/' , self defaultSettingsFileName) asFileReference.

	[
		fileReference ifNotNil: [
				fileReference writeStreamDo: [ :str | STON put: configuration onStream: str ].
				self inform: 'Settings saved to: ' , fileReference pathString ] ] onErrorDo: [ :err |
		self inform: 'Error while saving settings: ' , err messageText ]
]

{ #category : 'accessing - model' }
MiSettingsPresenter >> setModelBeforeInitialization: aSpecModel [

	browserModel := aSpecModel.
	configuration := aSpecModel currentConfiguration
]

{ #category : 'accessing' }
MiSettingsPresenter >> toolbar [

	^ self newToolbar
		  addItemRight: (self newToolbarButton
				   action: [ self resetToDefault ];
				   label: 'Reset';
				   help: 'Restore all settings to default values';
				   icon: (self iconNamed: #smallUpdate);
				   yourself);
		  addItemRight: (self newToolbarButton
				   action: [ self saveSettings ];
				   label: 'Save';
				   help: 'Save all settings';
				   icon: (self iconNamed: #smallSave);
				   yourself);
		  addItemRight: (self newToolbarButton
				   action: [ self loadSettings ];
				   label: 'Load';
				   help: 'Load settings from a file';
				   icon: (self iconNamed: #smallLoadProject);
				   yourself)
]

{ #category : 'accessing' }
MiSettingsPresenter >> windowTitle [

	^ browserModel toolName , ' settings'
]
