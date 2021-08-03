"
A query configuration presenter for the `FQBooleanQuery`
"
Class {
	#name : #MiBooleanQueryPresenter,
	#superclass : #MiPropertyQueryPresenter,
	#category : #'MooseIDE-NewTools-Queries Browser configuration'
}

{ #category : #specs }
MiBooleanQueryPresenter class >> layout [

	| padding |
	padding := 5.
	^ SpBoxLayout newLeftToRight
		  add: #propertyDropList
		  expand: false
		  fill: true
		  padding: padding;
		  yourself
]

{ #category : #actions }
MiBooleanQueryPresenter >> computeQuery: aProperty [

	self updateProperty: aProperty
]

{ #category : #initialization }
MiBooleanQueryPresenter >> initializePresenters [

	super initializePresenters.

	propertyDropList isImpossibleQueryPresenter ifFalse: [ 
		propertyDropList whenSelectedItemChangedDo: [ :property | 
			self computeQueryAction: property ] ]
]

{ #category : #initialization }
MiBooleanQueryPresenter >> newComparatorDropList [
	^ self newNullPresenter 
]

{ #category : #initialization }
MiBooleanQueryPresenter >> newValueInputField [
	"Boolean queries do not have a value to comapre to (only a comparator: #not or #yourself)"
	^self newNullPresenter
]
