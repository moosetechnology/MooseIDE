"
I am responsible for the opening of a `MiPlaygroundModelsPresenter` and used as toolbar button in `MiPlaygroundPagePresenter`.
"
Class {
	#name : #MiPlaygroundInstalledModelsCommand,
	#superclass : #MiPlaygroundCommand,
	#category : #'MooseIDE-NewTools-Playground'
}

{ #category : #default }
MiPlaygroundInstalledModelsCommand class >> defaultDescription [

	^ 'Add a model to the playground'
]

{ #category : #default }
MiPlaygroundInstalledModelsCommand class >> defaultName [

	^ 'Models'
]

{ #category : #converting }
MiPlaygroundInstalledModelsCommand >> asSpecCommand [

	^ super asSpecCommand
		  iconName: #mooseMetamodelGroup from: MooseIcons;
		  beDisplayedOnRightSide;
		  yourself
]

{ #category : #executing }
MiPlaygroundInstalledModelsCommand >> execute [

	| modelsPresenter |
	modelsPresenter := MiPlaygroundModelsPresenter
		                   newApplication: context application
		                   model: context.

	modelsPresenter openDialogWithSpec okAction: [ 
		self context addModelExpression: modelsPresenter codeToAdd ]
]
