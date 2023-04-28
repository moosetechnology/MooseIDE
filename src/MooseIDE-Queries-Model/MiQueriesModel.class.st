Class {
	#name : #MiQueriesModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'entities'
	],
	#category : #'MooseIDE-Queries-Model'
}

{ #category : #'instance creation' }
MiQueriesModel class >> newModel [

	^ FQRootQuery new 
]

{ #category : #accessing }
MiQueriesModel >> entities [

	^ entities ifNil: [ #(  ) ]
]
