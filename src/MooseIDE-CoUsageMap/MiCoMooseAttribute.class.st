"
similar to MiCoAttribute customized for moose necesities
"
Class {
	#name : #MiCoMooseAttribute,
	#superclass : #MiCoAttribute,
	#category : #'MooseIDE-CoUsageMap-Model'
}

{ #category : #accessing }
MiCoMooseAttribute >> methodName [
	^ 'container'
]

{ #category : #public }
MiCoMooseAttribute >> numberOfUsesOn: aMiCoMethod [
	^ usedInMethods sum
]
