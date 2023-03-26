"
Model for methods
"
Class {
	#name : #MiCoContainerBox,
	#superclass : #MiCoAbstractBox,
	#instVars : [
		'usedAttributes'
	],
	#category : #'MooseIDE-CoUsageMap-Model'
}

{ #category : #adding }
MiCoContainerBox >> addAttribute: aMiCoAttribute [
	usedAttributes add: aMiCoAttribute
]

{ #category : #accessing }
MiCoContainerBox >> children [
	^ usedAttributes 
]

{ #category : #initialization }
MiCoContainerBox >> initialize [
	super initialize.
	usedAttributes := OrderedCollection new: 5.
]

{ #category : #accessing }
MiCoContainerBox >> numberOfChildren [
	^ self children size
]

{ #category : #accessing }
MiCoContainerBox >> type [
	^ 'Container'
]

{ #category : #accessing }
MiCoContainerBox >> usedAttributes [
	^ usedAttributes
]

{ #category : #accessing }
MiCoContainerBox >> usedAttributes: aCollection [
	usedAttributes := aCollection
]
