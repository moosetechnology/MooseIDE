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
			changeSelection: selection selectedItem value
			from: self inspectorObjectContextPresenter ].
	navigation children: [ :aFMPackage |
		aFMPackage value isFM3Package
			ifTrue: [
				((aFMPackage value classes reject: [ :a |
					  a implementingClass isTrait ])
					 collect: [ :metaClass |
						 metaClass name
						 -> (self model allWithType: metaClass implementingClass) ]
					 thenReject: [ :a | a value isEmpty ]) sorted: [ :a :b |
					a name < b name ] ]
			ifFalse: [ {  } ] ].
	navigation expandRoots
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
