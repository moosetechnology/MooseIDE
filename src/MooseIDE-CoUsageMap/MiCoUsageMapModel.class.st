"
A model for the CoUsageMap browser
"
Class {
	#name : #MiCoUsageMapModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'settingsWindow',
		'containerEntities',
		'selectedEntity'
	],
	#category : #'MooseIDE-CoUsageMap-Model'
}

{ #category : #'private - for tests' }
MiCoUsageMapModel >> closeSettings [
	"used only for closing settings opened in tests"
	settingsWindow ifNotNil: [ settingsWindow close ]
]

{ #category : #accessing }
MiCoUsageMapModel >> collectionModel [

	^ containerEntities
]

{ #category : #accessing }
MiCoUsageMapModel >> collectionModel: anObject [

	containerEntities := anObject
]

{ #category : #accessing }
MiCoUsageMapModel >> entities [
	^containerEntities
]

{ #category : #actions }
MiCoUsageMapModel >> followEntity: aCollection [
	self collectionModel: aCollection.
	browser update
]

{ #category : #accessing }
MiCoUsageMapModel >> miSelectedItem [
	^selectedEntity
]

{ #category : #actions }
MiCoUsageMapModel >> openSettings [ 
	"For now, we handle settings here:
	 - create the window 
	 - subscribe to be informed when any window is closed closed
	 - if this is the setting window that is closed
	    - unsubscribe to ALL announcements
	    - update the visualization"

	| settingBrowser |
	settingBrowser := SettingBrowser new.
	settingBrowser
		changePackageSet:
			(OrderedCollection with:
				(RPackage organizer 
					packageNamed: MiCoUsageMapSettings package name)).
	settingsWindow := settingBrowser open.
	settingsWindow position: (self currentWorld extent - settingsWindow extent) // 2.
	settingBrowser expandAll.

	self currentWorld announcer when: WindowClosed do: [ :annoucement |
		(annoucement window = settingsWindow)
		ifTrue: [
			self currentWorld announcer unsubscribe: self.
			browser update
		]
	]
]

{ #category : #tagging }
MiCoUsageMapModel >> removeTagOn: aMooseEntity [
	aMooseEntity allTags
		detect: [ :aTag | aTag isHidden not ]
		ifOne: [ :aTag | aTag removeReference: aMooseEntity ]
		ifNone: [ "nothing" ]
]

{ #category : #accessing }
MiCoUsageMapModel >> selectedEntity [
	^selectedEntity
]

{ #category : #accessing }
MiCoUsageMapModel >> selectedEntity: aMooseEntity [

	selectedEntity := aMooseEntity
]

{ #category : #accessing }
MiCoUsageMapModel >> settings [
	^MiCoUsageMapSettings
]

{ #category : #tagging }
MiCoUsageMapModel >> tagEntitiesSelected [ 
	| tag entity |
	(tag := self selectedTag) ifNil: [ ^self ].
	(entity := self selectedEntity) ifNil: [ ^self ].
	self tagEntity: entity with: tag
	
]

{ #category : #tagging }
MiCoUsageMapModel >> tagEntity: aMooseEntity with: aTag [
	self removeTagOn: aMooseEntity.

	aTag ifNotNil: [ 	| tagAssociation |
		tagAssociation := aTag addReference: aMooseEntity.
		self currentApplication consumeItem: tagAssociation.

		self selectedTag: aTag
	].

	browser updateTagColorFor: aMooseEntity
]
