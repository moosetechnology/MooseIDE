Class {
	#name : #MiCoMooseMethodAttributeTester,
	#superclass : #MiCoMethodAttributeTester,
	#category : #'MooseIDE-CoUsageMap-Browser'
}

{ #category : #public }
MiCoMooseMethodAttributeTester >> numberOfUsesOf: aMiCoAttribute on: aMiCoMethod [
	| attribute method |
	attribute := aMiCoAttribute rawObject.
	method := aMiCoMethod rawObject.
	
	^ (attribute incomingAccesses select: [ :slotLink | slotLink accessor = method ]) size
]
