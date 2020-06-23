Class {
	#name : #MiAddQuerySequenceToLibraryCommand,
	#superclass : #MiAddQueryToLibraryCommand,
	#category : #'Midas-FamixQueries-Tools'
}

{ #category : #default }
MiAddQuerySequenceToLibraryCommand class >> defaultName [
	^ 'Save this query sequence'
]

{ #category : #executing }
MiAddQuerySequenceToLibraryCommand >> queryNamed: name [
	^ FQComposedQuery new
		queries: self context selectedQuery parentSequence veryDeepCopy;
		name: name
]

{ #category : #executing }
MiAddQuerySequenceToLibraryCommand >> requestText [
	^ 'Please name this query sequence'
]
