"
similar to MiCoAttribute customized for moose necesities
"
Class {
	#name : #MiCoMooseAttibute,
	#superclass : #MiCoAttribute,
	#category : #'MooseIDE-CoUsageMap-Browser'
}

{ #category : #accessing }
MiCoMooseAttibute >> methodName [
	^ 'container'
]

{ #category : #public }
MiCoMooseAttibute >> numberOfUsesOn: aMiCoMethod [
	
	^ usedInMethods sum
]
