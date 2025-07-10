Class {
	#name : #MiTagsSettingCommand,
	#superclass : #MiSelectableSettingCommand,
	#category : #'MooseIDE-Dependency-ArchitecturalMap'
}

{ #category : #default }
MiTagsSettingCommand class >> defaultDescription [

	^ 'The selected tags will be represented as entities in the visualisation.
Inner elements will be the tagged entities'
]

{ #category : #default }
MiTagsSettingCommand class >> defaultIcon [

	^ [ :tag | self application iconForTag: tag ]
]

{ #category : #default }
MiTagsSettingCommand class >> defaultItemsDisplay [

	^ #name
]

{ #category : #default }
MiTagsSettingCommand class >> defaultName [

	^ 'Show these tags as entities:'
]

{ #category : #'adding - removing' }
MiTagsSettingCommand >> addItem: anAssociationType [

	self context tags add: anAssociationType
]

{ #category : #accessing }
MiTagsSettingCommand >> allItems [

	^ self context availableTags
]

{ #category : #accessing }
MiTagsSettingCommand >> currentValue [

	^ self context tags
]

{ #category : #execution }
MiTagsSettingCommand >> execute: aCollection [

	self context tags: aCollection
]

{ #category : #'adding - removing' }
MiTagsSettingCommand >> removeItem: anAssociationType [

	self context tags remove: anAssociationType
]
