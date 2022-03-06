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
		'modelFile'
	],
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #'instance creation' }
MiImportModelFromFileDialog class >> open [

	<script>
	^ self new
		  openDialog;
		  yourself
]

{ #category : #accessing }
MiImportModelFromFileDialog class >> title [

	^ 'Import model from file'
]

{ #category : #accessing }
MiImportModelFromFileDialog class >> windowExtent [

	^ 600 @ 220
]

{ #category : #action }
MiImportModelFromFileDialog >> defaultDirectory [

	^ FileLocator home
]

{ #category : #action }
MiImportModelFromFileDialog >> getModelFile [

	| chosenFile |
	chosenFile := UIManager default
		chooseExistingFileReference: 'Select your model source file'
		extensions: MiAbstractFileImporter knownExtensions
		path:
			(modelFile
				ifNil: [ self defaultDirectory ]
				ifNotNil: [ 
					modelFile isFile
						ifTrue: [ modelFile parent ]
						ifFalse: [ modelFile ] ]).

	chosenFile ifNotNil: [ self updateForModelFile: chosenFile ]
]

{ #category : #action }
MiImportModelFromFileDialog >> getModelFileFromTextInput [

	filePathInput text ifNotEmpty: [ 
		self updateForModelFile: filePathInput text asFileReference ]
]

{ #category : #action }
MiImportModelFromFileDialog >> getRootFolder [

	| chosenDirectory |
	chosenDirectory := UIManager default
		                   chooseDirectory:
		                   'Select your model root directory'
		                   path: (rootFolderInput text ifEmpty: [ 
				                    modelFile
					                    ifNotNil: [ modelFile parent ]
					                    ifNil: [ self defaultDirectory ] ]).

	chosenDirectory ifNotNil: [ 
		rootFolderInput text: chosenDirectory asFileReference pathString ]
]

{ #category : #action }
MiImportModelFromFileDialog >> importModel [

	| rootFolder mooseModel |
	
	"If rootFolderInput isEmpty, rootFolder will be nil. That is expected."
	rootFolderInput text ifNotEmpty: [ 
		rootFolder := rootFolderInput text asFileReference.
		rootFolder isDirectory ifFalse: [ 
			self error: 'Your root folder path is incorrect' ] ].

	mooseModel := super importModel.
	mooseModel ifNotNil: [ mooseModel rootFolder: rootFolder ].
	^ mooseModel
]

{ #category : #initialization }
MiImportModelFromFileDialog >> initializeFilePathWidgets [

	filePathInput := self newTextInput
		placeholder: self defaultDirectory asFileReference pathString;
		whenSubmitDo: [ self getModelFileFromTextInput ];
		help: 'Tip: to choose a file in the directory of this Pharo image, type ''local/path/to/myFile.mse''';
		yourself.

	filePathInput eventHandler whenFocusLostDo: [ 
		self getModelFileFromTextInput ].

	filePathButton := self newButton
		action: [ self getModelFile ];
		icon: (self iconNamed: #open)
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
					  add: filePathButton width: size;
					  yourself)
			 height: size;
			 add: (SpBoxLayout newLeftToRight
					  spacing: spacing;
					  add: 'Model name:' width: labelWidth;
					  add: modelNameInput;
					  add: self newNullPresenter width: size;
					  yourself)
			 height: size;
			 add: (SpBoxLayout newLeftToRight
					  spacing: spacing;
					  add: 'Root folder (optional):' width: labelWidth;
					  add: rootFolderInput;
					  add: rootFolderButton width: size;
					  yourself)
			 height: size;
			 yourself)
]

{ #category : #initialization }
MiImportModelFromFileDialog >> initializePresenters [

	super initializePresenters.

	mooseModelDroplist := self newDropList
		items:
			(MooseModel withAllSubclasses reject: [ :model | 
				model isDeprecated or:
				[ model canBeImportedFromFile not ] ]) ;
			yourself.

	self initializeFilePathWidgets.

	modelNameInput := self newTextInput placeholder: 'MooseModel'.

	rootFolderInput := self newTextInput.
	rootFolderButton := self newButton
		action: [ self getRootFolder ];
		icon: (self iconNamed: #open).
	self initializeLayout
]

{ #category : #action }
MiImportModelFromFileDialog >> privateImportModel [

	| model importer |

	importer := MiAbstractFileImporter importerFor: modelFile.
	importer ifNil: [ 
		self error: 'No importer found for this input file' ].

	model := mooseModelDroplist selectedItem new.

	importer new
		model: model ;
		inputFile: modelFile ;
		run.

	model name: (modelNameInput text ifEmpty: [ 'MooseModel' ]).

	^ model
]

{ #category : #accessing }
MiImportModelFromFileDialog >> updateForModelFile: aFile [

	modelFile := aFile.

	filePathInput text: modelFile asFileReference pathString.
	modelNameInput text: modelFile basenameWithoutExtension.
	rootFolderInput text: modelFile asFileReference parent pathString.

]

{ #category : #action }
MiImportModelFromFileDialog >> validateImportForm [
	"checks that required fields are properly filled in"
	filePathInput text ifEmpty: [ Error signal: 'Please choose an input file' ].
	filePathInput text asFileReference exists ifFalse: [ Error signal: 'File path not found' ].
	modelNameInput text ifEmpty: [ Error signal: 'Please name the model' ].
	rootFolderInput text asFileReference isDirectory ifFalse: [ Error signal: 'Root folder path is not a directory' ].
]
