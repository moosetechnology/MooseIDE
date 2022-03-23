"
Model for methods
"
Class {
	#name : #MiCoMethod,
	#superclass : #MiCoTaggedObject,
	#instVars : [
		'usedAttributes'
	],
	#category : #'MooseIDE-CoUsageMap-Model'
}

{ #category : #adding }
MiCoMethod >> addAttribute: aMiCoAttribute [
	usedAttributes add: aMiCoAttribute
]

{ #category : #accessing }
MiCoMethod >> children [
	^ usedAttributes 
]

{ #category : #initialization }
MiCoMethod >> initialize [
	super initialize.
	usedAttributes := OrderedCollection new: 5.
]

{ #category : #accessing }
MiCoMethod >> type [
	^ 'Container'
]

{ #category : #accessing }
MiCoMethod >> usedAttributes [
	^ usedAttributes
]

{ #category : #accessing }
MiCoMethod >> usedAttributes: aCollection [
	usedAttributes := aCollection
]
