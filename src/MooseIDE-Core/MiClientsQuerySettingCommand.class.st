Class {
	#name : #MiClientsQuerySettingCommand,
	#superclass : #MiQuerySettingCommand,
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #default }
MiClientsQuerySettingCommand class >> defaultAction [

	^ [ :query | manager clientsQuery: query ]
]

{ #category : #default }
MiClientsQuerySettingCommand class >> defaultDescription [

	^ 'Query used to get the clients of an entity, i.e. dependencies to this entity'
]

{ #category : #default }
MiClientsQuerySettingCommand class >> defaultDisplayAction [

	^ [ :query | query name ]
]

{ #category : #default }
MiClientsQuerySettingCommand class >> defaultInitialValue [

	^ (FQCollectScriptQuery script: [ :entity | entity allClients ])
		  name: 'anEntity allClients';
		  yourself
]

{ #category : #default }
MiClientsQuerySettingCommand class >> defaultName [

	^ 'Clients query'
]
