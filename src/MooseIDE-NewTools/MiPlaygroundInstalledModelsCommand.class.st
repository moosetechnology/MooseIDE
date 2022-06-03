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

{ #category : #initialization }
MiPlaygroundInstalledModelsCommand class >> defaultIconName [

	^ #mooseMetamodelGroup
]

{ #category : #default }
MiPlaygroundInstalledModelsCommand class >> defaultName [

	^ 'Models'
]

{ #category : #converting }
MiPlaygroundInstalledModelsCommand >> asSpecCommand [

	^ super asSpecCommand
		  beDisplayedOnRightSide;
		  yourself
]

{ #category : #executing }
MiPlaygroundInstalledModelsCommand >> execute [

	| modelsPresenter |
	modelsPresenter := MiPlaygroundModelsPresenter
		                   newApplication: context application
		                   model: context.

	modelsPresenter openDialog okAction: [ 
		self context addModelExpression: modelsPresenter codeToAdd ]
]
