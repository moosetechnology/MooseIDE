Class {
	#name : #MiButterflyMapModel,
	#superclass : #MiAbstractModel,
	#traits : 'MiTSpecModelWithSettings',
	#classTraits : 'MiTSpecModelWithSettings classTrait',
	#instVars : [
		'currentEntity',
		'childrenQuery',
		'clientsQuery',
		'providersQuery'
	],
	#category : #'MooseIDE-ButterflyMap-Model'
}

{ #category : #default }
MiButterflyMapModel class >> defaultChildrenQuery [

	^ (FQCollectScriptQuery script: [ :each | each children ])
		  name: 'anEntity children';
		  yourself
]

{ #category : #default }
MiButterflyMapModel class >> defaultClientsQuery [

	^ (FQCollectScriptQuery script: [ :entity | entity allClients ])
		  name: 'anEntity allClients';
		  yourself
]

{ #category : #default }
MiButterflyMapModel class >> defaultProvidersQuery [

	^ (FQCollectScriptQuery script: [ :entity | entity allClients ])
		  name: 'anEntity allProviders';
		  yourself
]

{ #category : #settings }
MiButterflyMapModel class >> mementoForDefaultValues [

	^ MiButterflyMapSettingsMemento new
		  childrenQuery: self defaultChildrenQuery;
		  clientsQuery: self defaultClientsQuery;
		  providersQuery: self defaultProvidersQuery;
		  yourself
]

{ #category : #settings }
MiButterflyMapModel class >> settingsCommandsOn: aMemento [

	^ OrderedCollection new
		  add: (MiChildrenQuerySettingCommand forContext: aMemento);
		  add: (MiClientsQuerySettingCommand forContext: aMemento);
		  add: (MiProvidersQuerySettingCommand forContext: aMemento);
		  yourself
]

{ #category : #computing }
MiButterflyMapModel >> childrenFor: anEntity [

	^ childrenQuery runOn: anEntity asMooseGroup
]

{ #category : #accessing }
MiButterflyMapModel >> currentEntity [

	^ currentEntity
]

{ #category : #accessing }
MiButterflyMapModel >> currentEntity: anObject [

	currentEntity := anObject.
	browser runVisualization
]

{ #category : #accessing }
MiButterflyMapModel >> entities [
	"should probably return all entities displayed and not only the central one"
	^self currentEntity
		ifNil: [ #() ]
		ifNotNil: [ :entity | { entity } ]
]

{ #category : #testing }
MiButterflyMapModel >> hasSettings [

	^ true
]

{ #category : #initialization }
MiButterflyMapModel >> initializeSettings [

	childrenQuery := self class defaultChildrenQuery.
	clientsQuery := self class defaultClientsQuery.
	providersQuery := self class defaultProvidersQuery
]

{ #category : #computing }
MiButterflyMapModel >> leftEntitiesFor: anEntity [

	^ clientsQuery runOn: anEntity asMooseGroup
]

{ #category : #accessing }
MiButterflyMapModel >> miSelectedItem [

	^ self entities
]

{ #category : #'settings management' }
MiButterflyMapModel >> newMemento [

	^ MiButterflyMapSettingsMemento new
		  childrenQuery: childrenQuery;
		  clientsQuery: clientsQuery;
		  providersQuery: providersQuery;
		  yourself
]

{ #category : #computing }
MiButterflyMapModel >> rightEntitiesFor: anEntity [

	^ providersQuery runOn: anEntity asMooseGroup
]

{ #category : #accessing }
MiButterflyMapModel >> settingsChanged: aBoolean [

	aBoolean ifTrue: [ browser runVisualization ]
]

{ #category : #'settings management' }
MiButterflyMapModel >> updateFromMemento: aMemento [

	childrenQuery := aMemento childrenQuery.
	clientsQuery := aMemento clientsQuery.
	providersQuery := aMemento providersQuery.

	browser runVisualization
]
