"
This is a command for removing a query and all of its subqueries. I am called in `MiQueryListItemPresenter`
"
Class {
	#name : #MiRemoveQueryCommand,
	#superclass : #MiCommand,
	#category : #'MooseIDE-QueriesBrowser-Commands'
}

{ #category : #accessing }
MiRemoveQueryCommand class >> defaultDescription [

	^ 'Remove query and its sub-queries'
]

{ #category : #accessing }
MiRemoveQueryCommand class >> defaultIconName [

	^ #remove
]

{ #category : #'accessing - defaults' }
MiRemoveQueryCommand class >> defaultName [

	^ 'Remove query'
]

{ #category : #executing }
MiRemoveQueryCommand >> execute [

	(self context queriesListPresenter isQueryUsed: self context)
		ifTrue: [ 
			UIManager default inform: 'Cannot delete this query. It is used in another query(ies).'.
			^ self ].
	self context queriesListPresenter removeQueryAction: self context
]
