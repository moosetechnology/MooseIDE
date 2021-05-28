Class {
	#name : #MiModelNavigationBrowser,
	#superclass : #MiNavigationBrowser,
	#category : #'Midas-NewTools-Inspector tabs'
}

{ #category : #initialization }
MiModelNavigationBrowser >> itemsFor: anEntity [

	^ anEntity navigationItemsFromPragmas
	  , anEntity navigationItemsFromAttributes
	  , anEntity customNavigationItems
]
