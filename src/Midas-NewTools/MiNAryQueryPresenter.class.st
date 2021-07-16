"
I am a query configuration presenter for all N-ary queries (before called binary queries but are not longer binaries because they can do with the operation with more than two queries)
"
Class {
	#name : #MiNAryQueryPresenter,
	#superclass : #MiQueryConfigurationPresenter,
	#instVars : [
		'subqueryDropLists',
		'addSubqueryToLayoutButton',
		'removeSubqueryFromLayoutButton'
	],
	#category : #'Midas-NewTools-Queries Browser configuration'
}

{ #category : #accessing }
MiNAryQueryPresenter class >> dropListWidth [

	^ 57
]

{ #category : #actions }
MiNAryQueryPresenter >> addSubqueryToLayout [

	subqueryDropLists add: self newSubqueryDropList.
	removeSubqueryFromLayoutButton enable.
	self buildLayout.
	self update
]

{ #category : #layout }
MiNAryQueryPresenter >> buildLayout [

	| tempLayout |
	tempLayout := SpBoxLayout newLeftToRight
		              spacing: 5;
		              yourself.
	subqueryDropLists do: [ :subqueryPresenter | 
		tempLayout add: subqueryPresenter width: self class dropListWidth ].
	tempLayout
		add: #addSubqueryToLayoutButton width: self class iconWidth;
		add: #removeSubqueryFromLayoutButton width: self class iconWidth.
	self layout: tempLayout
]

{ #category : #initialization }
MiNAryQueryPresenter >> initializeButtons [

	addSubqueryToLayoutButton := self newButton.
	addSubqueryToLayoutButton
		icon: (self iconNamed: #smallAdd);
		action: [ self addSubqueryToLayout ].
	removeSubqueryFromLayoutButton := self newButton.
	removeSubqueryFromLayoutButton
		icon: (self iconNamed: #smallDelete);
		action: [ self removeSubqueryFromLayout ].
	"The remove button must be enabled only when there is more than 2 subqueries in the drop lists."
	removeSubqueryFromLayoutButton disable
]

{ #category : #initialization }
MiNAryQueryPresenter >> initializePresenters [

	self initializeButtons.
	subqueryDropLists := OrderedCollection withAll: { 
			                     self newSubqueryDropList.
			                     self newSubqueryDropList }
]

{ #category : #actions }
MiNAryQueryPresenter >> nAryOperationAction [

	| subqueries selectedDropListItems |
	selectedDropListItems := subqueryDropLists collect: #selectedItem.
	subqueries := selectedDropListItems collect: #query.
	query
		subqueries: subqueries;
		resetResult.
	self notifyQueryChanged
]

{ #category : #actions }
MiNAryQueryPresenter >> newSubqueryDropList [

	| availableQueryPresentersForOperation |
	availableQueryPresentersForOperation := owner allQueryPresenters 
		                                        reject: [ :q | 
		                                        q query = self owner query ].
	^ self newDropList
		  items: availableQueryPresentersForOperation;
		  display: [ :each | each name ];
		  whenSelectedItemChangedDo: [ self nAryOperationAction ];
		  yourself
]

{ #category : #actions }
MiNAryQueryPresenter >> removeSubqueryFromLayout [

	subqueryDropLists removeLast.
	subqueryDropLists size < 3 ifTrue: [ removeSubqueryFromLayoutButton disable ].
	self buildLayout.
	self update
]
