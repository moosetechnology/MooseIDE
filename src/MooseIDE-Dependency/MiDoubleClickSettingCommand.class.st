Class {
	#name : #MiDoubleClickSettingCommand,
	#superclass : #MiCollectionSettingCommand,
	#category : #'MooseIDE-Dependency-ArchitecturalMap'
}

{ #category : #accessing }
MiDoubleClickSettingCommand >> currentValue [

	^ self context doubleClickAction
]

{ #category : #execution }
MiDoubleClickSettingCommand >> execute: aCommand [

	self context doubleClickAction: aCommand
]

{ #category : #'instance creation' }
MiDoubleClickSettingCommand >> helpForItem: aCommand [

	^ aCommand description
]

{ #category : #'as yet unclassified' }
MiDoubleClickSettingCommand >> isCurrentValue: anItem [

	^ anItem class = self currentValue class
]

{ #category : #accessing }
MiDoubleClickSettingCommand >> items [

	^ self context availableDoubleClickActions
]

{ #category : #'instance creation' }
MiDoubleClickSettingCommand >> labelForItem: aCommand [

	^ aCommand name
]
