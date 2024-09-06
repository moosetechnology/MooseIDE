Class {
	#name : #MiModelNavigationBrowser,
	#superclass : #MiNavigationBrowser,
	#category : #'MooseIDE-NewTools-Inspector tabs'
}

{ #category : #initialization }
MiModelNavigationBrowser >> entitiesForActivationOf: selection [

	^ selection value value: self model
]

{ #category : #initialization }
MiModelNavigationBrowser >> iconBlock [

	^ [ :el | self iconNamed: #mooseMetamodelGroup ]
]

{ #category : #'as yet unclassified' }
MiModelNavigationBrowser >> itemsFor: anEntity [

	^ anEntity navigationItemsFromPragmas
]

{ #category : #initialization }
MiModelNavigationBrowser >> selectedObject [

	^ navigation selectedItem value value: self model
]
