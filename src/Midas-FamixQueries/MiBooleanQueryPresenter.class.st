Class {
	#name : #MiBooleanQueryPresenter,
	#superclass : #MiPropertyQueryPresenter,
	#category : #'Midas-FamixQueries-QueriesConfiguration'
}

{ #category : #specs }
MiBooleanQueryPresenter class >> layout [
	| padding |
	padding := 5.
	^SpBoxLayout newVertical
		  add: #propertyDropList
		  expand: true
		  fill: true
		  padding: padding;

		  yourself.
]

{ #category : #'instance creation' }
MiBooleanQueryPresenter >> newComparatorDropList [
	^ self newNullPresenter 
]

{ #category : #initialization }
MiBooleanQueryPresenter >> newValueInputField [
	"Boolean queries do not have a value to comapre to (only a comparator: #not or #yourself)"
	^self newNullPresenter
]
