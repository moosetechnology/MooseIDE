Class {
	#name : #MiTagExtentPageTest,
	#superclass : #MiTagPresenterTest,
	#category : #'MooseIDE-Tagging-Tests'
}

{ #category : #helpers }
MiTagExtentPageTest >> presenterClass [

	^ MiTagExtentPage
]

{ #category : #helpers }
MiTagExtentPageTest >> presenterOwner [

	^ browser
]

{ #category : #tests }
MiTagExtentPageTest >> setUp [

	| entities tag |
	super setUp.

	entities := #( Lorem iposum dolor sit amet ) collect: [ :each | 
		            FamixStClass named: each ].
	self createExtentTag: 'Tag001'.
	tag := browser tagModel allTags first.
	browser setTagTo: tag.

	(entities first: 3)
		do: [ :e | browser tagModel tagEntityNotYourself: e ].

	browser followEntity: entities asMooseGroup
]

{ #category : #tests }
MiTagExtentPageTest >> testEntitesListIsSorted [

	| entities |
	entities := presenter incomingEntitiesFilteringList items.
	self assert: (entities isSortedBy: [ :a :b | a name <= b name])
	
]

{ #category : #tests }
MiTagExtentPageTest >> testEntitiesListIsNotEmpty [

	| entities |
	entities := presenter incomingEntitiesFilteringList items.
	self assert: entities isNotEmpty.
]

{ #category : #tests }
MiTagExtentPageTest >> testTaggedEntitesListIsSorted [

	| entities |
	entities := presenter taggedEntities.
	self assert: (entities isSortedBy: [ :a :b | a name <= b name])
	
]

{ #category : #tests }
MiTagExtentPageTest >> testTaggedEntitiesListIsNotEmpty [

	| entities |
	entities := presenter taggedEntities.
	self assert: entities isNotEmpty.
]
