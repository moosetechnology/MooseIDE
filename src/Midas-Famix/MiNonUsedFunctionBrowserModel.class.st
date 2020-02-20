Class {
	#name : #MiNonUsedFunctionBrowserModel,
	#superclass : #Object,
	#instVars : [
		'selected',
		'model'
	],
	#category : #'Midas-Famix-SourceText'
}

{ #category : #accessing }
MiNonUsedFunctionBrowserModel >> initialize [ 
	super initialize.
	model := OrderedCollection new
]

{ #category : #accessing }
MiNonUsedFunctionBrowserModel >> model [
	^ model
]

{ #category : #accessing }
MiNonUsedFunctionBrowserModel >> refreshModel [
	model := (selected allToScope: FamixTMethod) select: [ :method | method incomingInvocations isEmpty ]
]

{ #category : #accessing }
MiNonUsedFunctionBrowserModel >> selected [
	^ selected
]

{ #category : #accessing }
MiNonUsedFunctionBrowserModel >> selected: anObject [
	selected := anObject.
	self refreshModel
]
