Class {
	#name : #MiSelectedEntityLog,
	#superclass : #Object,
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
MiSelectedEntityLog >> activateIn: aBus [

	aBus refreshBrowsersWith: self entity
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
