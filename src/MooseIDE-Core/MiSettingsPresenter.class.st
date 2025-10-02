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

	^self class name , '-settings.json'
]

{ #category : 'initialization' }
MiSettingsPresenter >> initializeDialogWindow: aSpDialogWindowPresenter [

	super initializeDialogWindow: aSpDialogWindowPresenter.

	aSpDialogWindowPresenter initialExtent: browserModel settingsPresenterExtent.
	aSpDialogWindowPresenter toolbar: self toolbar.

	aSpDialogWindowPresenter okAction: [ self acceptChanges ].
	
	aSpDialogWindowPresenter addButton: 'Load' do: [ self loadSettings ];
	addButton: 'Save' do: [ self saveSettings ].	

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

	[
		configuration := configuration class fromJson: self defaultSettingsFileName asFileReference contents.
		self initializePresenters
	] on: Error
	do: [ :err | self inform: 'Error while loading settings: ' , err messageText ]
]

{ #category : 'initialization' }
MiSettingsPresenter >> resetToDefault [

	configuration := browserModel defaultConfiguration.
	self initializePresenters
]

{ #category : 'file in/out' }
MiSettingsPresenter >> saveSettings [

	| jsonFilename |
	jsonFilename := self defaultSettingsFileName.
	jsonFilename asFileReference
		writeStreamDo: [ :str |
			str << configuration asJSON
		].

	self inform: 'Settings saved to: ' , jsonFilename

]

{ #category : 'accessing - model' }
MiSettingsPresenter >> setModelBeforeInitialization: aSpecModel [

	browserModel := aSpecModel.
	configuration := aSpecModel currentConfiguration
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
