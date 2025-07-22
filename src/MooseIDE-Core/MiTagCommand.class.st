"
Use me to tag selected entities. One can also choose what tag to use
"
Class {
	#name : 'MiTagCommand',
	#superclass : 'MiCommand',
	#instVars : [
		'tagButton'
	],
	#category : 'MooseIDE-Core-Command',
	#package : 'MooseIDE-Core',
	#tag : 'Command'
}

{ #category : 'default' }
MiTagCommand class >> defaultDescription [

	^ 'Tag selected entities with current tag'
]

{ #category : 'default' }
MiTagCommand class >> defaultIconName [

	^ #famixTagLabel
]

{ #category : 'default' }
MiTagCommand class >> defaultName [
	^ 'Set'
]

{ #category : 'testing' }
MiTagCommand >> canBeExecuted [

	^ self context canTagEntities and: [ context selectedTag isNotNil ]
]

{ #category : 'accessing' }
MiTagCommand >> dynamicName [

	^ context tagName
]

{ #category : 'executing' }
MiTagCommand >> execute [

	context tagSelectedEntities
]
