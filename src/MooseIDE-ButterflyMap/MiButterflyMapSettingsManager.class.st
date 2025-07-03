Class {
	#name : #MiButterflyMapSettingsManager,
	#superclass : #MiAbstractSettingsManager,
	#instVars : [
		'childrenQuery',
		'clientsQuery',
		'providersQuery'
	],
	#category : #'MooseIDE-ButterflyMap-Model'
}

{ #category : #accessing }
MiButterflyMapSettingsManager >> childrenQuery [

	^ childrenQuery
]

{ #category : #accessing }
MiButterflyMapSettingsManager >> childrenQuery: aQuery [

	childrenQuery := aQuery
]

{ #category : #accessing }
MiButterflyMapSettingsManager >> clientsQuery [

	^ clientsQuery
]

{ #category : #accessing }
MiButterflyMapSettingsManager >> clientsQuery: aQuery [

	clientsQuery := aQuery
]

{ #category : #default }
MiButterflyMapSettingsManager >> defaultChildrenQuery [

	^ (FQCollectScriptQuery script: [ :each | each children ])
		  name: 'anEntity children';
		  yourself
]

{ #category : #default }
MiButterflyMapSettingsManager >> defaultClientsQuery [

	^ (FQCollectScriptQuery script: [ :entity | entity allClients ])
		  name: 'anEntity allClients';
		  yourself
]

{ #category : #default }
MiButterflyMapSettingsManager >> defaultProvidersQuery [

	^ (FQCollectScriptQuery script: [ :entity | entity allClients ])
		  name: 'anEntity allProviders';
		  yourself
]

{ #category : #initialization }
MiButterflyMapSettingsManager >> initializeSettingsBuilders [

	settingsBuilders
		add: (MiChildrenQuerySettingBuilder on: self);
		add: (MiClientsQuerySettingBuilder on: self);
		add: (MiProvidersQuerySettingBuilder on: self)
]

{ #category : #accessing }
MiButterflyMapSettingsManager >> providersQuery [

	^ providersQuery
]

{ #category : #accessing }
MiButterflyMapSettingsManager >> providersQuery: aQuery [

	providersQuery := aQuery
]
