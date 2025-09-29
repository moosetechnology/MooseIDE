"
This is a command for removing a query and all of its subqueries. I am called in `MiQueryListItemPresenter`
"
Class {
	#name : #MiSaveQueryCommand,
	#superclass : #MiSaveQueriesCommand,
	#category : #'MooseIDE-QueriesBrowser-Commands'
}

{ #category : #accessing }
MiSaveQueryCommand class >> defaultDescription [

	^ 'Save query and its sub-queries'
]

{ #category : #'accessing - defaults' }
MiSaveQueryCommand class >> defaultName [

	^ 'Save query on disk'
]

{ #category : #executing }
MiSaveQueryCommand >> getQueries [

	| queryToStore |
	queryToStore := self context query.
	^ { queryToStore } , queryToStore children
]

{ #category : #executing }
MiSaveQueryCommand >> jobTitle [

	^ 'Saving query and it''s sub queries on disk'
]
