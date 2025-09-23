Class {
	#name : 'MiButterflyMapModel',
	#superclass : 'MiAbstractModel',
	#instVars : [
		'currentEntity',
		'childrenQuery',
		'clientsQuery',
		'providersQuery'
	],
	#category : 'MooseIDE-ButterflyMap-Model',
	#package : 'MooseIDE-ButterflyMap',
	#tag : 'Model'
}

{ #category : 'computing' }
MiButterflyMapModel >> childrenFor: anEntity [

	^ childrenQuery runOn: anEntity asMooseGroup
]

{ #category : 'settings management' }
MiButterflyMapModel >> currentConfiguration [

	^ MiButterflyMapSettingsConfiguration new
		  childrenQuery: childrenQuery;
		  clientsQuery: clientsQuery;
		  providersQuery: providersQuery;
		  yourself
]

{ #category : 'accessing' }
MiButterflyMapModel >> currentEntity [

	^ currentEntity
]

{ #category : 'accessing' }
MiButterflyMapModel >> currentEntity: anObject [

	currentEntity := anObject.
	browser runVisualization
]

{ #category : 'settings management' }
MiButterflyMapModel >> defaultConfiguration [

	^ MiButterflyMapSettingsConfiguration new
		  childrenQuery: self defaultChildrenQuery;
		  clientsQuery: self currentApplication defaultClientsQuery;
		  providersQuery: self currentApplication defaultProvidersQuery;
		  yourself
]

{ #category : 'accessing' }
MiButterflyMapModel >> entities [
	"should probably return all entities displayed and not only the central one"
	^self currentEntity
		ifNil: [ #() ]
		ifNotNil: [ :entity | { entity } ]
]

{ #category : 'testing' }
MiButterflyMapModel >> hasSettings [

	^ true
]

{ #category : 'initialization' }
MiButterflyMapModel >> initializeSettings [

	childrenQuery := self defaultChildrenQuery.
	clientsQuery := self currentApplication defaultClientsQuery.
	providersQuery := self currentApplication defaultProvidersQuery
]

{ #category : 'computing' }
MiButterflyMapModel >> leftEntitiesFor: anEntity [

	^ clientsQuery runOn: anEntity asMooseGroup
]

{ #category : 'accessing' }
MiButterflyMapModel >> miSelectedItem [

	^ self entities
]

{ #category : 'computing' }
MiButterflyMapModel >> rightEntitiesFor: anEntity [

	^ providersQuery runOn: anEntity asMooseGroup
]

{ #category : 'settings management' }
MiButterflyMapModel >> settingsPresenterExtent [

	^ 300 @ 250
]

{ #category : 'settings management' }
MiButterflyMapModel >> updateFromConfiguration: aConfiguration [

	childrenQuery := aConfiguration childrenQuery.
	clientsQuery := aConfiguration clientsQuery.
	providersQuery := aConfiguration providersQuery.

	browser runVisualization
]
