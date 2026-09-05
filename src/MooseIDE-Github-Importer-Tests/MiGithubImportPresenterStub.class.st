"
I am a MiGithubImportPresenter whose privateImportModel answers canned models without downloading anything, to test the import flow of the dialog.
"
Class {
	#name : 'MiGithubImportPresenterStub',
	#superclass : 'MiGithubImportPresenter',
	#instVars : [
		'importedModels'
	],
	#category : 'MooseIDE-Github-Importer-Tests-Tests',
	#package : 'MooseIDE-Github-Importer-Tests',
	#tag : 'Tests'
}

{ #category : 'accessing' }
MiGithubImportPresenterStub >> importedModels [

	^ importedModels
]

{ #category : 'accessing' }
MiGithubImportPresenterStub >> importedModels: aCollection [

	importedModels := aCollection
]

{ #category : 'action' }
MiGithubImportPresenterStub >> privateImportModel [

	^ MiMooseModelsWrapper models: importedModels
]
