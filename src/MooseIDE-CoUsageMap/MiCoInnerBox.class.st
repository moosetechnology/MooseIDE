"
Model for attributes
"
Class {
	#name : #MiCoInnerBox,
	#superclass : #MiCoAbstractBox,
	#instVars : [
		'usedInMethods'
	],
	#category : #'MooseIDE-CoUsageMap-Model'
}

{ #category : #converting }
MiCoInnerBox >> asStringForMethod: aMicoMethod [
	^ String streamContents: [:s | self printForMethod: aMicoMethod on: s] 
]

{ #category : #initialization }
MiCoInnerBox >> initialize [
	super initialize.
	usedInMethods := Dictionary new.
]

{ #category : #public }
MiCoInnerBox >> method: aMiCoMethod counter: aNumber [
	usedInMethods at: aMiCoMethod put: aNumber
]

{ #category : #accessing }
MiCoInnerBox >> numberOfUses [
	^ self usedInMethods size
]

{ #category : #public }
MiCoInnerBox >> numberOfUsesOn: aMiCoMethod [
	^ usedInMethods at: aMiCoMethod
]

{ #category : #printing }
MiCoInnerBox >> printForMethod: aMicoMethod on: stream [
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
MiCoInnerBox >> type [
	^ 'Inner entity'
]

{ #category : #accessing }
MiCoInnerBox >> usedInMethods [
	^ usedInMethods
]

{ #category : #accessing }
MiCoInnerBox >> usedInMethods: aCollection [
	usedInMethods := aCollection
]
