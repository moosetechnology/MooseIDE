Class {
	#name : #MiImportModelFromFileDialog,
	#superclass : #MiImportModelDialog,
	#instVars : [
		'mooseModelDroplist',
		'filePathInput',
		'filePathButton',
		'importedFile',
		'modelNameInput',
		'rootFolderInput',
		'rootFolderButton',
		'modelFile',
		'rootFolder'
	],
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #'instance creation' }
MiImportModelFromFileDialog class >> open [

	<script>
	^ self new
		  openDialogWithSpec;
		  yourself
]

{ #category : #accessing }
MiImportModelFromFileDialog class >> title [

	^ 'Import model from file'
]

{ #category : #accessing }
MiImportModelFromFileDialog class >> windowExtent [

	^ 500 @ 220
]

{ #category : #action }
MiImportModelFromFileDialog >> getModelFile [

	| chosenFile |
	chosenFile := UIManager default
		              chooseExistingFileReference:
		              'Select your model source file, MSE or JSON'
		              extensions: #( 'mse' 'json' )
		              path: FileLocator home.

	chosenFile ifNotNil: [ 
		self modelFile: chosenFile.
		self updateSubpresenters ]
]

{ #category : #action }
MiImportModelFromFileDialog >> getRootFolder [

	| chosenDirectory |
	chosenDirectory := UIManager default
		                   chooseDirectory:
		                   'Select your model root directory'
		                   path:
		                   (modelFile parent ifNil: [ FileLocator home ]).
	chosenDirectory ifNotNil: [ 
		self rootFolder: chosenDirectory.
		rootFolderInput text: chosenDirectory asFileReference pathString ]
]

{ #category : #initialization }
MiImportModelFromFileDialog >> initializeLayout [

	| spacing size labelWidth |
	spacing := 10.
	size := 25.
	labelWidth := 120.
	self layout: (SpBoxLayout newTopToBottom
			 spacing: spacing;
			 add: (SpBoxLayout newLeftToRight
					  spacing: spacing;
					  add: 'Model type:' width: labelWidth;
					  add: mooseModelDroplist;
					  yourself)
			 height: size;
			 add: (SpBoxLayout newLeftToRight
					  spacing: spacing;
					  add: 'File path:' width: labelWidth;
					  add: filePathInput;
					  add: filePathButton width: 25;
					  yourself)
			 height: size;
			 add: (SpBoxLayout newLeftToRight
					  spacing: spacing;
					  add: 'Model name:' width: labelWidth;
					  add: modelNameInput;
					  add: self newNullPresenter width: 25;
					  yourself)
			 height: size;
			 add: (SpBoxLayout newLeftToRight
					  spacing: spacing;
					  add: 'Root folder (optional):' width: labelWidth;
					  add: rootFolderInput;
					  add: rootFolderButton width: 25;
					  yourself)
			 height: size;
			 yourself)
]

{ #category : #initialization }
MiImportModelFromFileDialog >> initializePresenters [

	super initializePresenters.
	mooseModelDroplist := self newDropList
		                      items:
			                      (MooseModel withAllSubclasses reject: [ 
					                       :model | 
					                       model isDeprecated or: [ 
							                       model canBeImportedFromFile not ] ]);
		                      yourself.
	filePathInput := self newTextInput placeholder:
		                 FileLocator home asFileReference pathString.
	filePathButton := self newButton
		                  action: [ self getModelFile ];
		                  icon: (self iconNamed: #open).
	modelNameInput := self newTextInput placeholder: 'MooseModel'.
	rootFolderInput := self newTextInput.
	rootFolderButton := self newButton
		                    action: [ self getRootFolder ];
		                    icon: (self iconNamed: #open).
	self initializeLayout
]

{ #category : #accessing }
MiImportModelFromFileDialog >> modelFile: aFile [

	modelFile := aFile
]

{ #category : #action }
MiImportModelFromFileDialog >> privateImportModel [

	| model stream |
	model := mooseModelDroplist selectedItem new.

	stream := modelFile readStream.
	modelFile extension = 'mse' ifTrue: [ 
		model importFromMSEStream: stream ].
	modelFile extension = 'json' ifTrue: [ 
		model importFromJSONStream: stream ].
	stream close.

	model name: (modelNameInput text ifEmpty: [ 'MooseModel' ]).

	^ model
]

{ #category : #accessing }
MiImportModelFromFileDialog >> rootFolder: aFolder [

	rootFolder := aFolder
]

{ #category : #initialization }
MiImportModelFromFileDialog >> setRootFolderIfAvailableForModel: aModel [

	rootFolder ifNotNil: [ aModel rootFolder: rootFolder fullName ]
]

{ #category : #action }
MiImportModelFromFileDialog >> updateSubpresenters [

	filePathInput text: modelFile asFileReference pathString.
	modelNameInput text: modelFile basenameWithoutExtension
]
