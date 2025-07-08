Class {
	#name : #MiAssociationTypesSettingCommand,
	#superclass : #MiSelectableSettingCommand,
	#category : #'MooseIDE-Dependency-ArchitecturalMap'
}

{ #category : #default }
MiAssociationTypesSettingCommand class >> defaultDescription [

	^ 'Select dependencies you want to see in the visualization'
]

{ #category : #default }
MiAssociationTypesSettingCommand class >> defaultName [

	^ 'Show dependencies: '
]

{ #category : #'adding - removing' }
MiAssociationTypesSettingCommand >> addItem: anAssociationType [

	self context associationTypes add: anAssociationType
]

{ #category : #accessing }
MiAssociationTypesSettingCommand >> allItems [

	^ self context availableAssociationTypes
]

{ #category : #accessing }
MiAssociationTypesSettingCommand >> currentValue [

	^ self context associationTypes
]

{ #category : #execution }
MiAssociationTypesSettingCommand >> execute: aCollection [

	self context associationTypes: aCollection
]

{ #category : #'adding - removing' }
MiAssociationTypesSettingCommand >> removeItem: anAssociationType [

	self context associationTypes remove: anAssociationType
]
