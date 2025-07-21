Class {
	#name : #MiDoubleClickSettingCommand,
	#superclass : #MiCollectionSettingCommand,
	#category : #'MooseIDE-Dependency-ArchitecturalMap'
}

{ #category : #default }
MiDoubleClickSettingCommand class >> defaultDescription [

	^ 'What happens when double-clicking on an entity? '
]

{ #category : #default }
MiDoubleClickSettingCommand class >> defaultName [

	^ 'Double click action'
]

{ #category : #accessing }
MiDoubleClickSettingCommand >> currentValue [

	^ self context doubleClickAction
]

{ #category : #execution }
MiDoubleClickSettingCommand >> execute: aCommand [

	self context doubleClickAction: aCommand
]

{ #category : #building }
MiDoubleClickSettingCommand >> helpForItem: aCommand [

	^ aCommand description
]

{ #category : #testing }
MiDoubleClickSettingCommand >> isCurrentValue: anItem [

	^ anItem class = self currentValue class
]

{ #category : #accessing }
MiDoubleClickSettingCommand >> items [

	^ self context availableDoubleClickActions
]

{ #category : #building }
MiDoubleClickSettingCommand >> labelForItem: aCommand [

	^ aCommand name
]
