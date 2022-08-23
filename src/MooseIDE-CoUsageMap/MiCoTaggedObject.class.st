"
Base of Attribute and Methods of one clase, these objects recives tag:
But also this objects are a wrapper for the real object from users domain.
Then use rawObject to access to the real object model
"
Class {
	#name : #MiCoTaggedObject,
	#superclass : #Object,
	#instVars : [
		'tag',
		'name',
		'rawObject',
		'application'
	],
	#category : #'MooseIDE-CoUsageMap-Model'
}

{ #category : #accessing }
MiCoTaggedObject >> application [
	^ application
]

{ #category : #accessing }
MiCoTaggedObject >> application: anObject [
	application := anObject
]

{ #category : #'building - menus' }
MiCoTaggedObject >> createMenuOn: aMenuMorph markManager: aMiCoMarkManager [
	aMenuMorph
		addTitle: self type, ': <', (aMiCoMarkManager contractLabel: self name),'>';
		add: 'Tags' 
			subMenu: (aMiCoMarkManager subMenuTagsFor: self subMenu: MenuMorph new);
		add: 'Inspect'
			target: self
			selector: #mooseInspect:
			argument: self rawObject
]

{ #category : #inspector }
MiCoTaggedObject >> mooseInspect: anObject [ 
	MiInspectorBrowser inspect: anObject
]

{ #category : #accessing }
MiCoTaggedObject >> name [
	^ name
]

{ #category : #accessing }
MiCoTaggedObject >> name: aString [
	name := aString
]

{ #category : #printing }
MiCoTaggedObject >> printOn: s [
	s nextPutAll: name
]

{ #category : #private }
MiCoTaggedObject >> privateTag: aTag [
	tag := aTag
]

{ #category : #accessing }
MiCoTaggedObject >> rawObject [
	^ rawObject
]

{ #category : #accessing }
MiCoTaggedObject >> rawObject: anObject [
	rawObject := anObject
]

{ #category : #accessing }
MiCoTaggedObject >> tag [
	^ tag
]

{ #category : #accessing }
MiCoTaggedObject >> tag: aMiCoTag [
	tag ifNotNil: [ tag removeReference: self ].
	tag := aMiCoTag.
	tag ifNotNil: [ tag addReference: self ]
]

{ #category : #accessing }
MiCoTaggedObject >> type [
	^ self subclassResponsibility
]
