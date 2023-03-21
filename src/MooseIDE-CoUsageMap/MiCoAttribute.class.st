"
Model for attributes
"
Class {
	#name : #MiCoAttribute,
	#superclass : #MiCoTaggedObject,
	#instVars : [
		'usedInMethods'
	],
	#category : #'MooseIDE-CoUsageMap-Model'
}

{ #category : #converting }
MiCoAttribute >> asStringForMethod: aMicoMethod [
	^ String streamContents: [:s | self printForMethod: aMicoMethod on: s] 
]

{ #category : #initialization }
MiCoAttribute >> initialize [
	super initialize.
	usedInMethods := Dictionary new.
]

{ #category : #public }
MiCoAttribute >> method: aMiCoMethod counter: aNumber [
	usedInMethods at: aMiCoMethod put: aNumber
]

{ #category : #accessing }
MiCoAttribute >> numberOfUses [
	^ self usedInMethods size
]

{ #category : #public }
MiCoAttribute >> numberOfUsesOn: aMiCoMethod [
	^ usedInMethods at: aMiCoMethod
]

{ #category : #printing }
MiCoAttribute >> printForMethod: aMicoMethod on: stream [
	| n numberOfUsers |
	stream 
		<< 'Links for ';
		<< name;
		<< ':';
		crlf; crlf.
	n := self numberOfUsesOn: aMicoMethod.
	n printOn: stream.
	stream 
		<< ' links from this container(';
		<< aMicoMethod name;
		<< ')'.
	numberOfUsers := self usedInMethods size - 1.
	numberOfUsers <= 0 ifTrue: [ ^ self ].
	n := self usedInMethods sum - n.
	n <= 0 ifTrue: [ ^ self ].
	stream crlf.
	n printOn: stream.
	
	stream << ' links from '.
	numberOfUsers printOn: stream.
	stream << ' local container'.
	
	numberOfUsers > 1 
		ifTrue: [ stream nextPutAll: 's' ]
	
	
]

{ #category : #accessing }
MiCoAttribute >> type [
	^ 'Inner entity'
]

{ #category : #accessing }
MiCoAttribute >> usedInMethods [
	^ usedInMethods
]

{ #category : #accessing }
MiCoAttribute >> usedInMethods: aCollection [
	usedInMethods := aCollection
]
