Class {
	#name : #MiMetaModelNavigationBrowser,
	#superclass : #MiMetaNavigationBrowser,
	#category : #'MooseIDE-NewTools-Inspector tabs'
}

{ #category : #initialization }
MiMetaModelNavigationBrowser >> iconBlock [

	^ [ :el | self iconNamed: #mooseMetamodelGroup ]
]

{ #category : #initialization }
MiMetaModelNavigationBrowser >> initializePresenters [

	super initializePresenters.
	navigation whenActivatedDo: [ :selection |
		self inspectorObjectContextPresenter owner
			changeSelection: (selection selectedItem value value: self model)
			from: self inspectorObjectContextPresenter ]
]

{ #category : #initialization }
MiMetaModelNavigationBrowser >> itemsFor: anEntity [

	^ (anEntity metamodel classes sorted: #name ascending) collect: [
		  :fm3class |
		  fm3class name
		  -> [ :model | model allWithType: fm3class implementingClass ] ]
]

{ #category : #accessing }
MiMetaModelNavigationBrowser >> selectedItem [

	^ ([ 
	   self model mooseInterestingEntity perform:
		   navigation selection selectedItem value ] onErrorDo: [ nil ])
		  mooseInterestingEntity
]

{ #category : #initialization }
MiMetaModelNavigationBrowser >> selectedObject [

	^ navigation selection selectedItem value value: self model
]
