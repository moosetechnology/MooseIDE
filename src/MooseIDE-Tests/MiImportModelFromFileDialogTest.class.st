Class {
	#name : #MiImportModelFromFileDialogTest,
	#superclass : #TestCase,
	#instVars : [
		'dialog',
		'emptyJSONFile',
		'modelJSONFile'
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

	modelJSONFile := self famixTest1ModelFile.
	emptyJSONFile := self emptyJSONFile.

	dialog := MiImportModelFromFileDialog new
]

{ #category : #tests }
MiImportModelFromFileDialogTest >> testAddingFilePathSelectsAppropriateMetaModel [

	(dialog presenterAt: #mooseModelDroplist)
		addItemLabeled: FamixTest1Model
		do: [  ].

	dialog updateForModelFile: modelJSONFile.

	self
		assert: (dialog presenterAt: #mooseModelDroplist) selectedItem
		equals: FamixTest1Model
]

{ #category : #tests }
MiImportModelFromFileDialogTest >> testAddingFilePathUpdatesFilePathInput [

	dialog updateForModelFile: emptyJSONFile.

	self
		assert: (dialog presenterAt: #filePathInput) text
		equals: emptyJSONFile pathString
]

{ #category : #tests }
MiImportModelFromFileDialogTest >> testAddingFilePathUpdatesModelName [

	dialog updateForModelFile: emptyJSONFile.

	self
		assert: (dialog presenterAt: #modelNameInput) text
		equals: emptyJSONFile basenameWithoutExtension
]

{ #category : #tests }
MiImportModelFromFileDialogTest >> testAddingFilePathUpdatesRootFolderInput [

	dialog updateForModelFile: emptyJSONFile.

	self
		assert: (dialog presenterAt: #rootFolderInput) text
		equals: emptyJSONFile parent pathString
]

{ #category : #tests }
MiImportModelFromFileDialogTest >> testAddingFilePathWithoutAppropriateMetaModel [

	self
		should: [ dialog updateForModelFile: modelJSONFile ]
		raise: Error
]
