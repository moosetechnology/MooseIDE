Class {
	#name : #MiHideEntitiesSettingCommand,
	#superclass : #MiBooleanSettingCommand,
	#category : #'MooseIDE-Dependency-ArchitecturalMap'
}

{ #category : #default }
MiHideEntitiesSettingCommand class >> defaultDescription [

	^ 'When showing tags, hide the received entities to show only the tagged entities'
]

{ #category : #default }
MiHideEntitiesSettingCommand class >> defaultName [

	^ 'Hide received entities'
]

{ #category : #accessing }
MiHideEntitiesSettingCommand >> currentValue [

	^ self context hideReceivedEntities
]

{ #category : #execution }
MiHideEntitiesSettingCommand >> execute: aBoolean [

	self context hideReceivedEntities: aBoolean
]
