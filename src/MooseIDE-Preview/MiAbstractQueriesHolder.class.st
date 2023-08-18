"
I am the abstract class of query holders.
My subclasses define queries as methods, these methods are marqued with <query> pragma and can.
A query method has to return a collection.
A query method can define what browser we should use with its result with the pragma <browser:>.
"
Class {
	#name : #MiAbstractQueriesHolder,
	#superclass : #Object,
	#instVars : [
		'mooseModel'
	],
	#category : #'MooseIDE-Preview-Queries'
}

{ #category : #testing }
MiAbstractQueriesHolder class >> canBeAppliedOnModel: aMooseModel [

	^ self subclassResponsibility
]

{ #category : #initialization }
MiAbstractQueriesHolder >> initializeEntities [

	
]

{ #category : #accessing }
MiAbstractQueriesHolder >> mooseModel [

	^ mooseModel
]

{ #category : #accessing }
MiAbstractQueriesHolder >> mooseModel: aMooseModel [

	mooseModel := aMooseModel.
	self initializeEntities
]
