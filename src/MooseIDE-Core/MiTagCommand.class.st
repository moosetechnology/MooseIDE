"
Use me to tag selected entities. One can also choose what tag to use
"
Class {
	#name : #MiTagCommand,
	#superclass : #MiCommand,
	#instVars : [
		'tagButton'
	],
	#category : #'MooseIDE-Core-Command'
}

{ #category : #'accessing - defaults' }
MiTagCommand class >> defaultDescription [

	^ 'Tag selected entities with current tag'
]

{ #category : #'accessing - defaults' }
MiTagCommand class >> defaultIconName [

	^ #famixTagLabel
]

{ #category : #'accessing - defaults' }
MiTagCommand class >> defaultName [
	^ 'Tag entities'
]

{ #category : #testing }
MiTagCommand >> canBeExecuted [

	^ self context canTagEntities and: [ context selectedTag isNotNil ]
]

{ #category : #accessing }
MiTagCommand >> dynamicName [

	^ context tagName
]

{ #category : #executing }
MiTagCommand >> execute [

	context tagSelectedEntities
]
