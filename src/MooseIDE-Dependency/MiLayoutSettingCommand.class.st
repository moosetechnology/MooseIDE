Class {
	#name : #MiLayoutSettingCommand,
	#superclass : #MiCollectionSettingCommand,
	#category : #'MooseIDE-Dependency-ArchitecturalMap'
}

{ #category : #default }
MiLayoutSettingCommand class >> defaultDefault [

	^ 'The layout used to display entities'
]

{ #category : #default }
MiLayoutSettingCommand class >> defaultName [

	^ 'Entities layout'
]

{ #category : #accessing }
MiLayoutSettingCommand >> currentValue [

	^ self context layout
]

{ #category : #execution }
MiLayoutSettingCommand >> execute: aLayout [

	^ self context layout: aLayout
]

{ #category : #building }
MiLayoutSettingCommand >> helpForItem: aLayout [

	^ aLayout layoutDescription
]

{ #category : #accessing }
MiLayoutSettingCommand >> items [

	^ self context availableLayouts
]

{ #category : #building }
MiLayoutSettingCommand >> labelForItem: aLayout [

	^ aLayout layoutName
]
