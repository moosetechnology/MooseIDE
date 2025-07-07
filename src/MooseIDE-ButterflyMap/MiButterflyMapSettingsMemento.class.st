Class {
	#name : #MiButterflyMapSettingsMemento,
	#superclass : #Object,
	#instVars : [
		'childrenQuery',
		'clientsQuery',
		'providersQuery'
	],
	#category : #'MooseIDE-ButterflyMap-Model'
}

{ #category : #accessing }
MiButterflyMapSettingsMemento >> childrenQuery [

	^ childrenQuery
]

{ #category : #accessing }
MiButterflyMapSettingsMemento >> childrenQuery: aQuery [

	childrenQuery := aQuery
]

{ #category : #accessing }
MiButterflyMapSettingsMemento >> clientsQuery [

	^ clientsQuery
]

{ #category : #accessing }
MiButterflyMapSettingsMemento >> clientsQuery: aQuery [

	clientsQuery := aQuery
]

{ #category : #default }
MiButterflyMapSettingsMemento >> defaultChildrenQuery [
	"This should probably be set at the application level"

	^ MiButterflyMapModel defaultChildrenQuery
]

{ #category : #default }
MiButterflyMapSettingsMemento >> defaultClientsQuery [
	"This should probably be set at the application level"

	^ MiButterflyMapModel defaultClientsQuery
]

{ #category : #default }
MiButterflyMapSettingsMemento >> defaultProvidersQuery [
	"This should probably be set at the application level"

	^ MiButterflyMapModel defaultProvidersQuery
]

{ #category : #accessing }
MiButterflyMapSettingsMemento >> providersQuery [

	^ providersQuery
]

{ #category : #accessing }
MiButterflyMapSettingsMemento >> providersQuery: aQuery [

	providersQuery := aQuery
]
