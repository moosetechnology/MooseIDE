"
An abstract model class for all MooseIDE browsers
IT knows its browser and have some default behavior implemented (e.g. to manage settings)
"
Class {
	#name : #MiAbstractModel,
	#superclass : #Object,
	#instVars : [
		'browser',
		'selectedTag'
	],
	#category : #'MooseIDE-Core-Browser'
}

{ #category : #accessing }
MiAbstractModel >> browser [

	^ browser
]

{ #category : #accessing }
MiAbstractModel >> browser: anObject [

	browser := anObject.
	self initializeSettings
]

{ #category : #accessing }
MiAbstractModel >> currentApplication [

	^ browser application
]

{ #category : #accessing }
MiAbstractModel >> currentMooseModel [
	self entities ifNil: [ ^nil ].
	self entities ifEmpty: [ ^nil ].
	^self entities anyOne mooseModel
	
]

{ #category : #accessing }
MiAbstractModel >> doubleClickAction [
	self shouldBeImplemented.
]

{ #category : #accessing }
MiAbstractModel >> entities [
	self subclassResponsibility 
]

{ #category : #testing }
MiAbstractModel >> hasSettings [

	^ false
]

{ #category : #initialization }
MiAbstractModel >> initializeSettings [

	^ MiOldSettingsPresenter owner: self
]

{ #category : #accessing }
MiAbstractModel >> miSelectedItem [

	self subclassResponsibility
]

{ #category : #actions }
MiAbstractModel >> openSettings [

	"Nothing to do when no settings"
]

{ #category : #tagging }
MiAbstractModel >> privateRemoveTag: aTag fromEntity: aMooseEntity [
	"should find the corresponding TagAssociation and remove it and return it
	 does nothing for now"
	
	self flag: #FIXME.
	^FamixTagEntityAssociation
		new
]

{ #category : #tagging }
MiAbstractModel >> privateSetTag: aTag onEntity: aMooseEntity [

	^FamixTagEntityAssociation
		newForEntity: aMooseEntity
		tag: aTag.
	
]

{ #category : #tagging }
MiAbstractModel >> selectedTag [

	^ selectedTag
]

{ #category : #tagging }
MiAbstractModel >> selectedTag: aTag [

	selectedTag := aTag
]

{ #category : #tagging }
MiAbstractModel >> tagEntity: aMooseEntity with: aTag [

	| tagAssociation |
	(aTag = aMooseEntity) ifTrue: [ ^ self ].
	
	aTag
		ifNil: [
			tagAssociation := self privateRemoveTag: aTag fromEntity: aMooseEntity.
			browser application removeItem: tagAssociation ]
		ifNotNil: [
			tagAssociation := self privateSetTag: aTag onEntity: aMooseEntity.
			browser application consumeItem: tagAssociation ].

]

{ #category : #tagging }
MiAbstractModel >> tagList [

	^self currentApplication tagListForMooseModel: self currentMooseModel 
]

{ #category : #tagging }
MiAbstractModel >> tagSelectedEntities [

	| tag entity |
	(tag := self selectedTag) ifNil: [ ^self ].
	(entity := self miSelectedItem) ifNil: [ ^self ].

	entity isCollection
		ifTrue: [ entity do: [:each | self tagEntity: each with: tag] ]
		ifFalse: [ self tagEntity: entity with: tag ].

]

{ #category : #accessing }
MiAbstractModel >> toolName [

	^ browser title
]
