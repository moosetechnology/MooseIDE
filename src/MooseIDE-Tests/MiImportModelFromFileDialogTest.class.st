Class {
	#name : #MiImportModelFromFileDialogTest,
	#superclass : #TestCase,
	#instVars : [
		'dialog'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #tests }
MiImportModelFromFileDialogTest >> emptyJSONFile [
	| file |
	file := FileSystem memory workingDirectory / 'somefile.json'.
	file writeStreamDo: [ :stream | stream << '{}' ].
	^file
]

{ #category : #running }
MiImportModelFromFileDialogTest >> famixTest1ModelFile [
	"Creating an in-memory JSON file containing a class from FamixTest1Model"
	| file model |
	model := FamixTest1Model new.
	FamixTest1Class named: 'Class1' model: model.

	file := FileSystem memory workingDirectory / 'test1Model.json'.
	file writeStreamDo: [ :stream | model exportToJSONStream: stream ].
	^file
]

{ #category : #running }
MiImportModelFromFileDialogTest >> setUp [
	super setUp.
	
	dialog := MiImportModelFromFileDialog open.
]

{ #category : #running }
MiImportModelFromFileDialogTest >> tearDown [

	dialog window close.
	super tearDown
]

{ #category : #tests }
MiImportModelFromFileDialogTest >> testAddingFilePathSelectsAppropriateMetaModel [
	| file |
	(dialog presenterAt: #mooseModelDroplist) addItemLabeled: FamixTest1Model do: [ ].
	file := self famixTest1ModelFile.

	dialog updateForModelFile: file.

	self
		assert: (dialog presenterAt: #mooseModelDroplist) selectedItem
		equals: FamixTest1Model
]

{ #category : #tests }
MiImportModelFromFileDialogTest >> testAddingFilePathUpdatesFilePathInput [

	| jsonFile |
	jsonFile := self emptyJSONFile.

	dialog updateForModelFile: jsonFile.

	self
		assert: (dialog presenterAt: #filePathInput) text
		equals: jsonFile pathString
]

{ #category : #tests }
MiImportModelFromFileDialogTest >> testAddingFilePathUpdatesModelName [

	| jsonFile |
	jsonFile := self emptyJSONFile.

	dialog updateForModelFile: jsonFile.

	self
		assert: (dialog presenterAt: #modelNameInput) text
		equals: jsonFile basenameWithoutExtension
]

{ #category : #tests }
MiImportModelFromFileDialogTest >> testAddingFilePathUpdatesRootFolderInput [

	| jsonFile |
	jsonFile := self emptyJSONFile.

	dialog updateForModelFile: jsonFile.

	self
		assert: (dialog presenterAt: #rootFolderInput) text
		equals: jsonFile parent pathString
]

{ #category : #tests }
MiImportModelFromFileDialogTest >> testAddingFilePathWithoutAppropriateMetaModel [
	| file |
	file := self famixTest1ModelFile.

	self should: [ dialog updateForModelFile: file ] raise: Error.

]
