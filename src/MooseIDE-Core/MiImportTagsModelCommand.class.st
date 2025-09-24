Class {
	#name : 'MiImportTagsModelCommand',
	#superclass : 'MiModelUtilityCommand',
	#category : 'MooseIDE-Core-Command',
	#package : 'MooseIDE-Core',
	#tag : 'Command'
}

{ #category : 'default' }
MiImportTagsModelCommand class >> defaultDescription [
	^ 'Import tags from another model'
]

{ #category : 'default' }
MiImportTagsModelCommand class >> defaultIconName [
	^ #mooseIncoming
]

{ #category : 'default' }
MiImportTagsModelCommand class >> defaultName [
	^ 'Import tags'
]

{ #category : 'executing' }
MiImportTagsModelCommand >> execute [

	| models chosen |

	models := self context allModels.
	chosen := UIManager default chooseFrom: models  message: 'Select model to import the tags from...'.

	(chosen = 0) ifTrue: [ ^self ].

	self model importTagsFrom: (models at: chosen)
]
