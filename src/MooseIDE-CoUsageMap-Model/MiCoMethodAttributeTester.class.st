"
Used to obtain a list of inner models and their number of uses on the current method.
"
Class {
	#name : #MiCoMethodAttributeTester,
	#superclass : #Object,
	#category : #'MooseIDE-CoUsageMap-Model'
}

{ #category : #'as yet unclassified' }
MiCoMethodAttributeTester >> numberOfUsesOf: aMiCoAttribute on: aMiCoMethod [
	"returns a number"
	^ self subclassResponsibility
]
