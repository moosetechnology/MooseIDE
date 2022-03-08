"
I use the block text from MiCoUsageMapSettingsPresenter, stored in MiCoUsageMapSettings
If there is an error with the user input, I will return an empy list
"
Class {
	#name : #MiCoFromSettingsMethodAttributeTester,
	#superclass : #MiCoMethodAttributeTester,
	#category : #'MooseIDE-CoUsageMap-Browser'
}

{ #category : #'as yet unclassified' }
MiCoFromSettingsMethodAttributeTester >> numberOfUsesOf: aMiCoAttribute on: aMiCoMethod [
	| attribute method |
	attribute := aMiCoAttribute rawObject.
	method := aMiCoMethod rawObject.
	
	^ (attribute incomingAccesses select: [ :slotLink | slotLink accessor = method ]) size
]
