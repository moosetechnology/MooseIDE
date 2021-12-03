Class {
	#name : #MiNonUsedFunctionBrowserModel,
	#superclass : #Object,
	#instVars : [
		'deadMethods',
		'container'
	],
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #accessing }
MiNonUsedFunctionBrowserModel >> container [

	^ container
]

{ #category : #accessing }
MiNonUsedFunctionBrowserModel >> container: anObject [

	container := anObject.
	deadMethods := ((container allToScope: FamixTMethod) select: [ 
		                :method | method isDead ]) asMooseGroup specialize
]

{ #category : #accessing }
MiNonUsedFunctionBrowserModel >> deadMethods [

	^ deadMethods
]

{ #category : #initialization }
MiNonUsedFunctionBrowserModel >> initialize [

	super initialize.
	deadMethods := FamixMethodGroup new
]

{ #category : #accessing }
MiNonUsedFunctionBrowserModel >> refresh [

	deadMethods := (container allToScope: FamixTMethod) select: [ :method | 
		           method incomingInvocations isEmpty ]
]
