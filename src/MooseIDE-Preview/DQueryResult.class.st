Class {
	#name : #DQueryResult,
	#superclass : #Object,
	#instVars : [
		'browsers',
		'result',
		'name',
		'queryBlock',
		'group',
		'description'
	],
	#category : #'MooseIDE-Preview-Queries'
}

{ #category : #accessing }
DQueryResult >> browsers [

	^ browsers
]

{ #category : #accessing }
DQueryResult >> browsers: anObject [

	browsers := anObject
]

{ #category : #accessing }
DQueryResult >> description [

	^ description
]

{ #category : #accessing }
DQueryResult >> description: anObject [

	description := anObject
]

{ #category : #accessing }
DQueryResult >> group [

	^ group
]

{ #category : #accessing }
DQueryResult >> group: anObject [

	group := anObject
]

{ #category : #accessing }
DQueryResult >> name [

	^ name
]

{ #category : #accessing }
DQueryResult >> name: anObject [

	name := anObject
]

{ #category : #accessing }
DQueryResult >> queryBlock [

	^ queryBlock
]

{ #category : #accessing }
DQueryResult >> queryBlock: anObject [

	queryBlock := anObject
]

{ #category : #accessing }
DQueryResult >> result [

	^ result ifNil: [ result := queryBlock value ]
]
