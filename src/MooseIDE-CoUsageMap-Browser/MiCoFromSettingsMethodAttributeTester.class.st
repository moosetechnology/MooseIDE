"
TODO
"
Class {
	#name : #MiCoFromSettingsMethodAttributeTester,
	#superclass : #MiCoMethodAttributeTester,
	#category : #'MooseIDE-CoUsageMap-Model'
}

{ #category : #'as yet unclassified' }
MiCoFromSettingsMethodAttributeTester >> numberOfUsesOf: aMiCoAttribute on: aMiCoMethod [
	| attribute method |
	attribute := aMiCoAttribute rawObject.
	method := aMiCoMethod rawObject.
	
	^ (attribute incomingAccesses select: [ :slotLink | slotLink accessor = method ]) size
]
