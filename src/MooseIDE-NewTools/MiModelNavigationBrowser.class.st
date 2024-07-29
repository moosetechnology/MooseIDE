Class {
	#name : #MiModelNavigationBrowser,
	#superclass : #MiNavigationBrowser,
	#category : #'MooseIDE-NewTools-Inspector tabs'
}

{ #category : #initialization }
MiModelNavigationBrowser >> iconBlock [

	^ [ :el | self iconNamed: #mooseMetamodelGroup ]
]

{ #category : #initialization }
MiModelNavigationBrowser >> initializePresenters [

	super initializePresenters.
	navigation whenActivatedDo: [ :selection |
		self inspectorObjectContextPresenter owner
			changeSelection: (selection selectedItem value value: self model)
			from: self inspectorObjectContextPresenter ]
]

{ #category : #'as yet unclassified' }
MiModelNavigationBrowser >> itemsFor: anEntity [

	^ anEntity navigationItemsFromPragmas
]

{ #category : #accessing }
MiModelNavigationBrowser >> selectedItem [

	^ ([ 
	   self model mooseInterestingEntity perform:
		   navigation selection selectedItem value ] onErrorDo: [ nil ])
		  mooseInterestingEntity
]

{ #category : #initialization }
MiModelNavigationBrowser >> selectedObject [

	^ navigation selection selectedItem value value: self model
]
