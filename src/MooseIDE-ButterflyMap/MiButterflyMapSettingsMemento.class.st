Class {
	#name : 'MiButterflyMapSettingsMemento',
	#superclass : 'MiMemento',
	#instVars : [
		'childrenQuery',
		'clientsQuery',
		'providersQuery'
	],
	#category : 'MooseIDE-ButterflyMap-Model',
	#package : 'MooseIDE-ButterflyMap',
	#tag : 'Model'
}

{ #category : 'accessing' }
MiButterflyMapSettingsMemento >> childrenQuery [

	^ childrenQuery
]

{ #category : 'accessing' }
MiButterflyMapSettingsMemento >> childrenQuery: aQuery [

	childrenQuery := aQuery
]

{ #category : 'accessing' }
MiButterflyMapSettingsMemento >> clientsQuery [

	^ clientsQuery
]

{ #category : 'accessing' }
MiButterflyMapSettingsMemento >> clientsQuery: aQuery [

	clientsQuery := aQuery
]

{ #category : 'accessing' }
MiButterflyMapSettingsMemento >> providersQuery [

	^ providersQuery
]

{ #category : 'accessing' }
MiButterflyMapSettingsMemento >> providersQuery: aQuery [

	providersQuery := aQuery
]

{ #category : 'ui' }
MiButterflyMapSettingsMemento >> settingsPresenters [

	^ super settingsPresenters
		  add: ((MiQuerySettingPresenter on: self)
				   beForChildren;
				   yourself);
		  add: ((MiQuerySettingPresenter on: self)
				   beForClients;
				   yourself);
		  add: ((MiQuerySettingPresenter on: self)
				   beForProviders;
				   yourself);
		  yourself
]
