Class {
	#name : #MiImportModelFromFileDialog,
	#superclass : #MiImportModelDialog,
	#instVars : [
		'mooseModelDroplist',
		'filePathInput',
		'filePathButton',
		'modelNameInput',
		'rootFolderInput',
		'rootFolderButton',
		'modelFile',
		'importingContext',
		'customEntities',
		'customEntitiesButton',
		'allEntitiesButton'
	],
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #accessing }
MiImportModelFromFileDialog class >> defaultDirectory [

	^ FileLocator home
]

{ #category : #accessing }
MiImportModelFromFileDialog class >> fullWindowExtent [

	^ self windowExtent + (0 @ MiImportingContextPresenter windowExtent y)
]

{ #category : #opening }
MiImportModelFromFileDialog class >> open [

	<script>
	^ super open
]

{ #category : #accessing }
MiImportModelFromFileDialog class >> title [

	^ 'Import model from file'
]

{ #category : #accessing }
MiImportModelFromFileDialog class >> windowExtent [

	^ 600 @ 250
]

{ #category : #action }
MiImportModelFromFileDialog >> closeEntitiesChoice [

	self withWindowDo: [ :window | window extent: self class windowExtent ]
]

{ #category : #initialization }
MiImportModelFromFileDialog >> connectPresenters [

	mooseModelDroplist whenSelectionChangedDo: [ 
		customEntitiesButton state ifTrue: [ self openEntitiesChoice ] ]
]

{ #category : #initialization }
MiImportModelFromFileDialog >> defaultLayout [

	| spacing size labelWidth |
	spacing := 10.
	size := 25.
	labelWidth := 120.
	^ SpBoxLayout newTopToBottom
		  spacing: spacing;
		  add: (SpBoxLayout newLeftToRight
				   spacing: spacing;
				   add: 'File path:' width: labelWidth;
				   add: filePathInput;
				   add: filePathButton width: size;
				   yourself)
		  height: size;
		  add: (SpBoxLayout newLeftToRight
				   spacing: spacing;
				   add: 'Model type:' width: labelWidth;
				   add: mooseModelDroplist;
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
		  add: (SpBoxLayout newLeftToRight
				   spacing: spacing;
				   add: 'Entity types:' width: labelWidth;
				   add: allEntitiesButton;
				   add: customEntitiesButton;
				   yourself)
		  height: size;
		  yourself
]

{ #category : #private }
MiImportModelFromFileDialog >> getModelFile [

	| chosenFile |
	chosenFile := UIManager default
		              chooseExistingFileReference:
		              'Select your model source file'
		              extensions: FamixAbstractFileImporter knownExtensions
		              path:
			              (modelFile
				               ifNil: [ self class defaultDirectory ]
				               ifNotNil: [
					               modelFile isFile
						               ifTrue: [ modelFile parent ]
						               ifFalse: [ modelFile ] ]).

	chosenFile ifNil: [ ^ self ].

	self tryUpdatingForModelFile:  chosenFile
]

{ #category : #private }
MiImportModelFromFileDialog >> getRootFolder [

	| chosenDirectory |
	chosenDirectory := UIManager default
		                   chooseDirectory:
		                   'Select your model root directory'
		                   path: (rootFolderInput text ifEmpty: [ 
				                    modelFile
					                    ifNotNil: [ modelFile parent ]
					                    ifNil: [ self class defaultDirectory ] ]).

	chosenDirectory ifNotNil: [ 
		rootFolderInput text: chosenDirectory asFileReference pathString ]
]

{ #category : #action }
MiImportModelFromFileDialog >> handleDropFile: aFileReference [

	self tryUpdatingForModelFile: aFileReference
]

{ #category : #action }
MiImportModelFromFileDialog >> handleDropFileAndImport: aFileReference [

	self handleDropFile: aFileReference.

	self importModelThenCloseDialogWindow
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

{ #category : #private }
MiImportModelFromFileDialog >> importerForFile [

	^ (FamixAbstractFileImporter importerFor: modelFile) ifNil: [ 
		  self error: 'No importer found for this input file' ]
]

{ #category : #initialization }
MiImportModelFromFileDialog >> initializeEntitiesSelectionWidgets [

	allEntitiesButton := self newRadioButton
		                     label: 'All Entities';
		                     whenActivatedDo: [ 
			                     importingContext importMaximum ];
		                     yourself.

	customEntitiesButton := self newRadioButton
		                        label: 'Custom Entities';
		                        whenActivatedDo: [ self openEntitiesChoice ];
		                        whenDeactivatedDo: [ 
			                        self closeEntitiesChoice ];
		                        yourself.

	allEntitiesButton associatedRadioButtons: { customEntitiesButton }
]

{ #category : #initialization }
MiImportModelFromFileDialog >> initializeFilePathWidgets [

	filePathInput := self newTextInput
		                 placeholder:
			                 self class defaultDirectory asFileReference
				                 pathString;
		                 whenSubmitDo: [ :modelPath |
			                 self newFilePathInput: modelPath ];
		                 help:
			                 'Tip: to choose a file in the directory of this Pharo image, type ''local/path/to/myFile.mse''';
		                 yourself.

	filePathInput eventHandler whenFocusLostDo: [
		self newFilePathInput: filePathInput text ].

	filePathButton := self newButton
		                  action: [ self getModelFile ];
		                  icon: (self iconNamed: #open)
]

{ #category : #initialization }
MiImportModelFromFileDialog >> initializeMooseModelDroplist [

	mooseModelDroplist := self newDropList
		                      items: MooseModel possibleModelsToImportFromFiles;
		                      whenSelectedItemChangedDo: [ :mooseModelClass |
			                      importingContext := mooseModelClass importingContextClass new
				                                          importMaximum;
				                                          yourself ];
		                      selectItem: FamixStModel;
		                      yourself
]

{ #category : #initialization }
MiImportModelFromFileDialog >> initializePresenters [

	super initializePresenters.
	self initializeMooseModelDroplist.
	self initializeFilePathWidgets.

	modelNameInput := self newTextInput placeholder: 'MooseModel'.
	rootFolderInput := self newTextInput.
	rootFolderButton := self newButton
		                    action: [ self getRootFolder ];
		                    icon: (self iconNamed: #open).

	self initializeEntitiesSelectionWidgets
]

{ #category : #'metamodel-guess' }
MiImportModelFromFileDialog >> metaModelForFile [

	mooseModelDroplist selectItem: (self importerForFile
			 findPossibleModelClassIn: mooseModelDroplist items
			 forFile: modelFile)
]

{ #category : #'instance creation' }
MiImportModelFromFileDialog >> newFilePathInput: aString [

	| file |
	aString ifEmpty: [ ^ self ].

	file := aString asFileReference.
	file isFile ifFalse: [ ^ self ].

	self tryUpdatingForModelFile: file
]

{ #category : #action }
MiImportModelFromFileDialog >> openEntitiesChoice [

	customEntities := self
		                  instantiate: MiImportingContextPresenter
		                  on: importingContext.

	self withWindowDo: [ :window | 
		window extent: self class fullWindowExtent ].

	self layout: (self simpleLayout
			 add: customEntities;
			 yourself).

	"Add style AFTER #layout: or it will be applied to all sub-layouts"
	customEntities addStyle: 'mooseContainer'
]

{ #category : #action }
MiImportModelFromFileDialog >> privateImportModel [

	| model importer |
	importer := self importerForFile.

	model := mooseModelDroplist selectedItem new.

	importer new
		model: model;
		inputFile: modelFile;
		runFilteredBy: importingContext.

	model name: (modelNameInput text ifEmpty: [ 'MooseModel' ]).

	^ model
]

{ #category : #private }
MiImportModelFromFileDialog >> tryUpdatingForModelFile: aFile [

	[ self updateForModelFile: aFile ]
		on: Error
		do: [ :err |
			err freeze.
			MiImportErrorDialog new
				label: 'Error: ' , err messageText;
				onCancel: [ err debug ];
				openDialog ]
]

{ #category : #private }
MiImportModelFromFileDialog >> updateForModelFile: aFile [
	"updates all fileds in the presenter according to new modelFile"

	modelFile := aFile.

	filePathInput text: modelFile asFileReference pathString.
	modelNameInput text: modelFile basenameWithoutExtension.
	rootFolderInput text: modelFile asFileReference parent pathString.

	self metaModelForFile
]

{ #category : #private }
MiImportModelFromFileDialog >> validateImportForm [
	"checks that required fields are properly filled in"
	filePathInput text ifEmpty: [ Error signal: 'Please choose an input file' ].
	filePathInput text asFileReference exists ifFalse: [ Error signal: 'File path not found' ].
	modelNameInput text ifEmpty: [ Error signal: 'Please name the model' ].
	rootFolderInput text asFileReference isDirectory ifFalse: [ Error signal: 'Root folder path is not a directory' ].
]
