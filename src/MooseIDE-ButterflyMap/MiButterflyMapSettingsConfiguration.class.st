Class {
	#name : #MiButterflyMapSettingsConfiguration,
	#superclass : #MiAbstractSettingsConfiguration,
	#instVars : [
		'childrenQuery',
		'clientsQuery',
		'providersQuery'
	],
	#category : #'MooseIDE-ButterflyMap-Model'
}

{ #category : #accessing }
MiButterflyMapSettingsConfiguration >> childrenQuery [

	^ childrenQuery
]

{ #category : #accessing }
MiButterflyMapSettingsConfiguration >> childrenQuery: aQuery [

	childrenQuery := aQuery
]

{ #category : #accessing }
MiButterflyMapSettingsConfiguration >> clientsQuery [

	^ clientsQuery
]

{ #category : #accessing }
MiButterflyMapSettingsConfiguration >> clientsQuery: aQuery [

	clientsQuery := aQuery
]

{ #category : #accessing }
MiButterflyMapSettingsConfiguration >> providersQuery [

	^ providersQuery
]

{ #category : #accessing }
MiButterflyMapSettingsConfiguration >> providersQuery: aQuery [

	providersQuery := aQuery
]

{ #category : #ui }
MiButterflyMapSettingsConfiguration >> settingsPresenters [

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
