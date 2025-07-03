Class {
	#name : #MiProvidersQuerySettingCommand,
	#superclass : #MiQuerySettingCommand,
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #default }
MiProvidersQuerySettingCommand class >> defaultAction [

	^ [ :query | manager providersQuery: query ]
]

{ #category : #default }
MiProvidersQuerySettingCommand class >> defaultDescription [

	^ 'Query used to get the providers of an entity, i.e. dependencies from this entity'
]

{ #category : #default }
MiProvidersQuerySettingCommand class >> defaultDisplayAction [

	^ [ :query | query name ]
]

{ #category : #default }
MiProvidersQuerySettingCommand class >> defaultInitialValue [

	^ (FQCollectScriptQuery script: [ :entity | entity allClients ])
		  name: 'anEntity allProviders';
		  yourself
]

{ #category : #default }
MiProvidersQuerySettingCommand class >> defaultName [

	^ 'Providers query'
]
