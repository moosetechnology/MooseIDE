"
This is a command for adding a new child query. I am called in `MiQueryListItemPresenter`
"
Class {
	#name : 'MiAddChildQueryCommand',
	#superclass : 'MiCommand',
	#category : 'MooseIDE-QueriesBrowser-Commands',
	#package : 'MooseIDE-QueriesBrowser',
	#tag : 'Commands'
}

{ #category : 'initialization' }
MiAddChildQueryCommand class >> defaultDescription [

	^ 'Narrow result by adding a query'
]

{ #category : 'default' }
MiAddChildQueryCommand class >> defaultIconName [

	^ #smallAdd
]

{ #category : 'accessing - defaults' }
MiAddChildQueryCommand class >> defaultName [

	^ 'Add a child query'
]

{ #category : 'executing' }
MiAddChildQueryCommand >> execute [

	self context queriesListPresenter addNewChildQueryAction:
		self context query
]
