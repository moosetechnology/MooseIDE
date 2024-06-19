"
Most model importers of Moose IDE are importing one model and the browser got planned like this. 

But it is possible to have an importer importing multiple models. I am here to make it compatible to import one or mulitple models.
"
Class {
	#name : #MiMooseModelsWrapper,
	#superclass : #Object,
	#instVars : [
		'models'
	],
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #accessing }
MiMooseModelsWrapper class >> models: aCollection [

	^ self new
		  models: aCollection;
		  yourself
]

{ #category : #initialization }
MiMooseModelsWrapper >> initialize [

	super initialize.
	models := OrderedCollection new
]

{ #category : #actions }
MiMooseModelsWrapper >> install [

	models do: [ :model | model install ]
]

{ #category : #accessing }
MiMooseModelsWrapper >> models: aCollection [

	models := aCollection
]
