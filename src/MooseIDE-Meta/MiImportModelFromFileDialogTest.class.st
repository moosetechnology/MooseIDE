Class {
	#name : #MiImportModelFromFileDialogTest,
	#superclass : #TestCase,
	#instVars : [
		'dialog'
	],
	#category : #'MooseIDE-Meta-Import'
}

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
MiImportModelFromFileDialogTest >> testAddingFilePathUpdatesFilePathInput [

	| jsonFile |
	jsonFile := FileLocator home / 'nonExistingFile' / 'myModel.json'.

	dialog updateForModelFile: jsonFile.

	self
		assert: (dialog presenterAt: #filePathInput) text
		equals: jsonFile asFileReference pathString
]

{ #category : #tests }
MiImportModelFromFileDialogTest >> testAddingFilePathUpdatesModelName [

	| jsonFile |
	jsonFile := FileLocator home / 'nonExistingFile' / 'myModel.json'.

	dialog updateForModelFile: jsonFile.

	self
		assert: (dialog presenterAt: #modelNameInput) text
		equals: jsonFile basenameWithoutExtension
]
