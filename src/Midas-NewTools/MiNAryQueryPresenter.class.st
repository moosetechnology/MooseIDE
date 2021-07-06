"
I am a query configuration presenter for all N-ary queries (before called binary queries but are not longer binaries because can do with the operation with more than two queries)
"
Class {
	#name : #MiNAryQueryPresenter,
	#superclass : #MiQueryConfigurationPresenter,
	#instVars : [
		'addSubqueryButton',
		'subqueryDropLists',
		'dynamicLayout'
	],
	#category : #'Midas-NewTools-Queries configuration'
}

{ #category : #accessing }
MiNAryQueryPresenter class >> dropListWidth [

	^ 57
]

{ #category : #actions }
MiNAryQueryPresenter >> addSubqueryToLayout [

	subqueryDropLists add: self newSubqueryDropList.
	dynamicLayout
		add: subqueryDropLists last
		width: self class dropListWidth.
	self update
]

{ #category : #layout }
MiNAryQueryPresenter >> buildLayout [

	dynamicLayout := SpBoxLayout newLeftToRight
		                 spacing: 5;
		                 yourself.
	subqueryDropLists do: [ :subquery | 
		dynamicLayout add: subquery width: self class dropListWidth ].
	self layout: (SpBoxLayout newLeftToRight
			 add: dynamicLayout;
			 add: #addSubqueryButton withConstraints: [ :c | 
				 c
					 expand: false;
					 width: self class iconWidth ];
			 yourself)
]

{ #category : #initialization }
MiNAryQueryPresenter >> initializeButtons [

	addSubqueryButton := self newButton.
	addSubqueryButton
		icon: (self iconNamed: #smallAdd) asGrayScale;
		action: [ self addSubqueryToLayout ]
]

{ #category : #initialization }
MiNAryQueryPresenter >> initializePresenters [

	self initializeButtons.
	subqueryDropLists := OrderedCollection withAll: { 
			                     self newSubqueryDropList.
			                     self newSubqueryDropList }
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
		  yourself
]
