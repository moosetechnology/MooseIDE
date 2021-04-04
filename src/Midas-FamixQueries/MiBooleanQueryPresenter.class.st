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
		  expand: false
		  fill: true
		  padding: padding;
		
		  add: #comparatorDropList
		  expand: false
		  fill: false
		  padding: padding;
	
		  yourself.
]

{ #category : #'instance creation' }
MiBooleanQueryPresenter >> newComparatorDropList [
	"changing the display of comparators"
	^ super newComparatorDropList
		display: [ :prop | prop = #not ifTrue: [ 'is false' ] ifFalse: [ 'is true' ] ] ;
		yourself
]

{ #category : #'instance creation' }
MiBooleanQueryPresenter >> newValueInputField [
	^self newNullPresenter 
]
