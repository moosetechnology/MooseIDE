Class {
	#name : #MiQueriesModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'entities'
	],
	#category : #'MooseIDE-QueriesBrowser-Model'
}

{ #category : #'instance creation' }
MiQueriesModel class >> newModel [

	^ FQRootQuery new
]

{ #category : #accessing }
MiQueriesModel >> entities [

	^ entities ifNil: [ #(  ) ]
]

{ #category : #accessing }
MiQueriesModel >> entities: anObject [

	entities := anObject
]
