"
I am a class that holder the information of the tree of a query. Tree means all the sequence of a query and all of its children (and the choldren of its children). And the index of were the query has to be inserted.

I am used to help the sorting of the queries.
"
Class {
	#name : #TreeQueryHolder,
	#superclass : #Object,
	#instVars : [
		'tree',
		'index'
	],
	#category : #'MooseIDE-QueriesBrowser-Commands'
}

{ #category : #'instance creation' }
TreeQueryHolder class >> tree: aCollection index: anIndex [

	^ self new
		tree: aCollection;
		index: anIndex;
		yourself
]

{ #category : #adding }
TreeQueryHolder >> addQuery: aQuery [

	^ tree add: aQuery
]

{ #category : #accessing }
TreeQueryHolder >> index [

	^ index
]

{ #category : #accessing }
TreeQueryHolder >> index: anObject [

	index := anObject
]

{ #category : #accessing }
TreeQueryHolder >> tree [

	^ tree
]

{ #category : #accessing }
TreeQueryHolder >> tree: anObject [

	tree := anObject
]
