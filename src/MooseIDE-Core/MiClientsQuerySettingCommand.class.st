Class {
	#name : #MiClientsQuerySettingCommand,
	#superclass : #MiQuerySettingCommand,
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #default }
MiClientsQuerySettingCommand class >> defaultDescription [

	^ 'Query used to get the clients of an entity, i.e. dependencies to this entity'
]

{ #category : #default }
MiClientsQuerySettingCommand class >> defaultName [

	^ 'Clients query'
]

{ #category : #accessing }
MiClientsQuerySettingCommand >> currentValue [

	^ self context clientsQuery
]

{ #category : #'as yet unclassified' }
MiClientsQuerySettingCommand >> defaultQuery [

	^ self context defaultClientsQuery
]

{ #category : #execution }
MiClientsQuerySettingCommand >> execute: aQuery [

	self context clientsQuery: aQuery
]
