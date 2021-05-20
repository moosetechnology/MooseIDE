Class {
	#name : #MiModelNavigationBrowser,
	#superclass : #MiNavigationBrowser,
	#category : #'Midas-NewTools-Inspector tabs'
}

{ #category : #initialization }
MiModelNavigationBrowser >> itemsFor: anEntity [
	| classes result |
	classes := anEntity metamodel allImplementingClasses select: [ :each | each inheritsFrom: MooseEntity ].

	result := OrderedCollection new.
	classes
		do: [ :each | 
			| aGroup |
			aGroup := anEntity allWithType: each.
			aGroup isEmpty ifFalse: [ result add: each mooseName -> (anEntity allWithType: each) ] ].
	^ result
]
