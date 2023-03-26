"
Model for the user entities, container boxes (eg. methods)

Knows it #innerBoxes
"
Class {
	#name : #MiCoContainerBox,
	#superclass : #MiCoAbstractBox,
	#instVars : [
		'innerBoxes'
	],
	#category : #'MooseIDE-CoUsageMap-Model'
}

{ #category : #adding }
MiCoContainerBox >> addInnerBox: aMiCoAttribute [
	innerBoxes add: aMiCoAttribute
]

{ #category : #initialization }
MiCoContainerBox >> initialize [
	super initialize.
	innerBoxes := OrderedCollection new: 5.
]

{ #category : #accessing }
MiCoContainerBox >> innerBoxes [
	^ innerBoxes
]

{ #category : #accessing }
MiCoContainerBox >> innerBoxes: aCollection [
	innerBoxes := aCollection
]

{ #category : #accessing }
MiCoContainerBox >> numberOfInnerBoxes [
	^ self innerBoxes size
]

{ #category : #accessing }
MiCoContainerBox >> type [
	^ 'Container'
]
