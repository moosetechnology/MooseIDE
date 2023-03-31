Class {
	#name : #MiModelNavigationBrowser,
	#superclass : #MiNavigationBrowser,
	#category : #'MooseIDE-NewTools-Inspector tabs'
}

{ #category : #initialization }
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
