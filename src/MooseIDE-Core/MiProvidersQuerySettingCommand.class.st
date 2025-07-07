Class {
	#name : #MiProvidersQuerySettingCommand,
	#superclass : #MiQuerySettingCommand,
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #default }
MiProvidersQuerySettingCommand class >> defaultDescription [

	^ 'Query used to get the providers of an entity, i.e. dependencies from this entity'
]

{ #category : #default }
MiProvidersQuerySettingCommand class >> defaultName [

	^ 'Providers query'
]

{ #category : #accessing }
MiProvidersQuerySettingCommand >> currentValue [

	^ self context providersQuery
]

{ #category : #'as yet unclassified' }
MiProvidersQuerySettingCommand >> defaultQuery [

	^ self context defaultProvidersQuery
]

{ #category : #execution }
MiProvidersQuerySettingCommand >> execute: aQuery [

	self context providersQuery: aQuery
]
