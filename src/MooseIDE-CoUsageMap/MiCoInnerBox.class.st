"
Model for the used entities, inner boxes (eg. attributes)

Knows all the container boxes it is in and how many uses each one does
"
Class {
	#name : #MiCoInnerBox,
	#superclass : #MiCoAbstractBox,
	#instVars : [
		'usedInContainers'
	],
	#category : #'MooseIDE-CoUsageMap-Model'
}

{ #category : #converting }
MiCoInnerBox >> asStringForContainerBox: containerBox [
	^ String streamContents: [:s | self printForMethod: containerBox on: s] 
]

{ #category : #public }
MiCoInnerBox >> containerBox: aMiCoMethod numberOfUses: aNumber [
	usedInContainers at: aMiCoMethod put: aNumber
]

{ #category : #accessing }
MiCoInnerBox >> containerBoxes [
	^ usedInContainers
]

{ #category : #initialization }
MiCoInnerBox >> initialize [
	super initialize.
	usedInContainers := Dictionary new.
]

{ #category : #accessing }
MiCoInnerBox >> numberOfUses [
	^ self containerBoxes size
]

{ #category : #public }
MiCoInnerBox >> numberOfUsesOn: containerBox [
	^ usedInContainers at: containerBox
]

{ #category : #printing }
MiCoInnerBox >> printForMethod: containerBox on: stream [
	| n numberOfUsers |
	stream 
		<< 'Links for <';
		<< self name;
		<< '>:';
		crlf; crlf.
	n := self numberOfUsesOn: containerBox.
	n printOn: stream.
	stream 
		<< ' links from this container(';
		<< containerBox name;
		<< ')'.
	numberOfUsers := self containerBoxes size - 1.
	numberOfUsers <= 0 ifTrue: [ ^ self ].
	n := self containerBoxes sum - n.
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
