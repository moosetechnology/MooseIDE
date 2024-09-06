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

	| sizeColumn |
	super initializePresenters.
	navigation whenActivatedDo: [ :selection |
		self inspectorObjectContextPresenter owner
			changeSelection: selection selectedItem value
			from: self inspectorObjectContextPresenter ].
	navigation children: [ :aFMPackage |
		{  }
		"aFMPackage value isFM3Package
			ifTrue: [
				((aFMPackage value classes reject: [ :a |
					  a implementingClass isTrait ])
					 collect: [ :metaClass |
						 metaClass name
						 -> (self model allWithType: metaClass implementingClass) ]
					 thenReject: [ :a | a value isEmpty ]) sorted: [ :a :b |
					a name < b name ] ]
			ifFalse: [ {  } ]" ].
	sizeColumn := SpStringTableColumn new
		              title: 'Size';
		              width: 50;
		              evaluated: [ :each |
			              each value isCollection
				              ifTrue: [ each value size printString ]
				              ifFalse: [ '' ] ].
	navigation columns: (navigation columns copyWithFirst: sizeColumn).
	navigation items: (((navigation roots flatCollect: [ :el |
			   el value classes
				   reject: [ :a | a implementingClass isTrait ]
				   thenCollect: [ :clazz |
				   clazz name -> (self model allWithType: clazz implementingClass) ] ])
			  reject: [ :a | a value isEmpty ]) sorted: [ :a :b |
			 a name < b name ]).
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
