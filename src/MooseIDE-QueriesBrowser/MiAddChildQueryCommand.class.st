"
This is a command for adding a new child query. I am called in `MiQueryListItemPresenter`
"
Class {
	#name : #MiAddChildQueryCommand,
	#superclass : #CmCommand,
	#category : #'MooseIDE-QueriesBrowser-Commands'
}

{ #category : #initialization }
MiAddChildQueryCommand class >> defaultDescription [

	^ 'Narrow result by adding a query'
]

{ #category : #'accessing - defaults' }
MiAddChildQueryCommand class >> defaultName [

	^ 'Add a child query'
]

{ #category : #initialization }
MiAddChildQueryCommand class >> iconName [

	^ #smallAdd
]

{ #category : #executing }
MiAddChildQueryCommand >> execute [

	self context queriesListPresenter addNewChildQueryAction:
		self context query
]
