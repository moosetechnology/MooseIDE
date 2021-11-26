Class {
	#name : #MiSelectedEntityLog,
	#superclass : #MiLog,
	#instVars : [
		'entity'
	],
	#category : #'MooseIDE-Core-Logger'
}

{ #category : #accessing }
MiSelectedEntityLog class >> entity: aSelectedEntity [
	^ self new entity: aSelectedEntity
]

{ #category : #activation }
MiSelectedEntityLog >> activateIn: anApplication [
	anApplication refreshBrowsersWith: self entity
]

{ #category : #accessing }
MiSelectedEntityLog >> entity [
	^ entity
]

{ #category : #accessing }
MiSelectedEntityLog >> entity: anObject [
	entity := anObject
]

{ #category : #printing }
MiSelectedEntityLog >> printOn: aStream [
	aStream
		nextPutAll: 'log(';
		nextPutAll: entity class name;
		nextPutAll: ')'
]
