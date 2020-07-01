Class {
	#name : #MiBus,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'Midas-Core-Application'
}

{ #category : #'instance creation' }
MiBus class >> named: aName [
	^ self new
		name: aName;
		yourself
]

{ #category : #accessing }
MiBus >> name [
	^ name
]

{ #category : #accessing }
MiBus >> name: anObject [
	name := anObject
]
