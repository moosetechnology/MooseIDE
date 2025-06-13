Class {
	#name : #MiCreateCacheSettingBuilder,
	#superclass : #MiBooleanSettingBuilder,
	#category : #'MooseIDE-Meta-ModelsBrowser'
}

{ #category : #default }
MiCreateCacheSettingBuilder >> defaultAction [

	^ [ :boolean | self manager shouldCreateCache: boolean ]
]

{ #category : #default }
MiCreateCacheSettingBuilder >> defaultCurrentValue [

	^ self manager shouldCreateCache
]

{ #category : #default }
MiCreateCacheSettingBuilder >> defaultHelp [

	^ 'Caching entities in the model may improve some functionalities but takes time on import'
]

{ #category : #default }
MiCreateCacheSettingBuilder >> defaultInitialValue [

	^ false
]

{ #category : #default }
MiCreateCacheSettingBuilder >> defaultLabel [

	^ 'Import with cache?'
]
