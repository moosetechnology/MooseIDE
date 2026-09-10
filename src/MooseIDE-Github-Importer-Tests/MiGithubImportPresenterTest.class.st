"
I test the import flow of MiGithubImportPresenter with a stubbed privateImportModel: the imported models are checked not to be empty and are answered in a MiMooseModelsWrapper.
"
Class {
	#name : 'MiGithubImportPresenterTest',
	#superclass : 'TestCase',
	#category : 'MooseIDE-Github-Importer-Tests-Tests',
	#package : 'MooseIDE-Github-Importer-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
MiGithubImportPresenterTest >> testImportModelWithEmptyModel [

	| presenter |
	presenter := MiGithubImportPresenterStub new
		             importedModels: { FamixStModel new };
		             yourself.

	self should: [ presenter importModel ] raise: Error
]

{ #category : 'tests' }
MiGithubImportPresenterTest >> testImportModelWithModels [

	| presenter modelsWrapper model |
	model := FamixStModel new.
	model newClassNamed: 'AClass'.
	presenter := MiGithubImportPresenterStub new
		             importedModels: { model };
		             yourself.
	modelsWrapper := presenter importModel.

	self assert: modelsWrapper models size equals: 1.
	self assert: modelsWrapper models anyOne size equals: 1
]
