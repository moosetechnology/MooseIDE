Class {
	#name : #MiCreateCacheSettingCommand,
	#superclass : #MiBooleanSettingCommand,
	#category : #'MooseIDE-Meta-Settings'
}

{ #category : #default }
MiCreateCacheSettingCommand class >> defaultDescription [

	^ 'Caching entities in the model may improve some functionalities but takes time on import'
]

{ #category : #default }
MiCreateCacheSettingCommand class >> defaultName [

	^ 'Import with cache?'
]

{ #category : #accessing }
MiCreateCacheSettingCommand >> currentValue [

	^ self context shouldCreateCache
]

{ #category : #execution }
MiCreateCacheSettingCommand >> execute: aBoolean [

	self context shouldCreateCache: aBoolean
]
