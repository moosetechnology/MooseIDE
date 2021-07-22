"
This is the negation query. It receives one query and negates it. Obviously, can only negate queries that can be negated.
"
Class {
	#name : #MiNegationQueryPresenter,
	#superclass : #MiQueryConfigurationPresenter,
	#instVars : [
		'subqueryDropListPresenter'
	],
	#category : #'Midas-NewTools-Queries Browser configuration'
}

{ #category : #accessing }
MiNegationQueryPresenter class >> dropListWidth [

	^ 57
]

{ #category : #layout }
MiNegationQueryPresenter >> buildLayout [

	self layout: (SpBoxLayout newLeftToRight
			 add: #subqueryDropListPresenter width: self class dropListWidth;
			 yourself)
]

{ #category : #initialization }
MiNegationQueryPresenter >> initializePresenters [

	subqueryDropListPresenter := self newDropList.
	subqueryDropListPresenter
		items:
			(owner allQueryPresenters reject: [ :q | 
					 q query = self owner query ]);
		display: [ :each | each name ];
		whenSelectedItemChangedDo: [ :item | self negateQueryAction: item ]
]

{ #category : #actions }
MiNegationQueryPresenter >> negateQueryAction: selectedPresenter [

	query := FQComplementQuery queryToNegate: selectedPresenter query.
	query runOn: selectedPresenter query parent result.
	self notifyQueryChanged
]
